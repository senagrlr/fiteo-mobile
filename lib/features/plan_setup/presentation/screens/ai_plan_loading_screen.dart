import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/plan_ready_sheet.dart';

class AiPlanLoadingScreen extends StatefulWidget {
  final Map<String, dynamic> userPreferences;

  const AiPlanLoadingScreen({
    super.key,
    required this.userPreferences,
  });

  @override
  State<AiPlanLoadingScreen> createState() {
    return _AiPlanLoadingScreenState();
  }
}

class _AiPlanLoadingScreenState
    extends State<AiPlanLoadingScreen> {
  Timer? _statusTimer;

  int currentStatusIndex = 0;

  bool isCreatingPlan = true;
  bool isSaving = false;
  bool didOpenPlanSheet = false;

  late AiNutritionPlan generatedPlan;

  @override
  void initState() {
    super.initState();

    _generatePlan();
  }

  Future<void> _generatePlan() async {
    try {
      _startLoadingAnimation();

      final minimumDelay = Future.delayed(
        const Duration(seconds: 3),
      );

      final response = await http.post(
        Uri.parse(
          'https://us-central1-fiteo-app-39f91.cloudfunctions.net/generatePersonalizedPlan',
        ),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'userPreferences': widget.userPreferences,
        }),
      );

      if (response.statusCode != 200) {
        throw Exception('Plan generation failed');
      }

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final plan = decoded['plan'] as Map<String, dynamic>?;
      final debug = decoded['debug'] as Map<String, dynamic>?;

      print(
        'PLAN DEBUG | '
            'source=${plan?['source']} | '
            'usedFallback=${debug?['usedFallback']} | '
            'baseline=${debug?['baseline']} | '
            'allowedRanges=${debug?['allowedRanges']} | '
            'aiSelection=${debug?['aiSelection']}',
      );

      if (plan == null) {
        throw Exception('Missing plan');
      }

      generatedPlan = AiNutritionPlan(
        calories: (plan['calories'] as num).round(),
        proteinGrams: (plan['proteinGrams'] as num).round(),
        carbsGrams: (plan['carbsGrams'] as num).round(),
        fatsGrams: (plan['fatsGrams'] as num).round(),
        waterMl: (plan['waterMl'] as num).round(),
        expectedWeeklyWeightChangeKg:
        (plan['expectedWeeklyWeightChangeKg'] as num?)?.toDouble() ?? 0,
      );

      await minimumDelay;

      if (!mounted) return;

      setState(() {
        isCreatingPlan = false;
      });

      await Future.delayed(
        const Duration(milliseconds: 500),
      );

      if (!mounted || didOpenPlanSheet) return;

      didOpenPlanSheet = true;
      await _showPlanReadySheet();
    } catch (_) {
      if (!mounted) return;

      AppSnackbar.showError(
        context,
        context.l10n.planCouldNotBeSaved,
      );

      Navigator.pop(context);
    }
  }

  void _startLoadingAnimation() {
    _statusTimer = Timer.periodic(
      const Duration(milliseconds: 1700),
          (timer) {
        if (!mounted) return;

        if (currentStatusIndex < 3) {
          setState(() {
            currentStatusIndex++;
          });
        } else {
          timer.cancel();
        }
      },
    );
  }

  Future<void> _showPlanReadySheet() async {
    final result =
    await showModalBottomSheet<
        AiNutritionPlan>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return PlanReadySheet(
          initialPlan: generatedPlan,
        );
      },
    );

    if (!mounted) return;

    if (result != null) {
      generatedPlan = result;

      await _savePlanAndContinue();
    }
  }

  Future<void>
  _savePlanAndContinue() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      final user =
          FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception(
          'User not logged in',
        );
      }

      final updatedPreferences = Map<String, dynamic>.from(
        widget.userPreferences,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set(
        {
          'userPreferences':
          updatedPreferences,
          'nutritionPlan': {
            'dailyCalories': generatedPlan.calories,
            'proteinGrams': generatedPlan.proteinGrams,
            'carbsGrams': generatedPlan.carbsGrams,
            'fatsGrams': generatedPlan.fatsGrams,
            'waterMl': generatedPlan.waterMl,
            'expectedWeeklyWeightChangeKg':
            generatedPlan.expectedWeeklyWeightChangeKg,
            'createdAt': FieldValue.serverTimestamp(),
            'updatedAt': FieldValue.serverTimestamp(),
          },
          'isOnboardingCompleted': true,
          'updatedAt':
          FieldValue.serverTimestamp(),
        },
        SetOptions(merge: true),
      );

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.main,
            (route) => false,
      );
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.planCouldNotBeSaved,
      );

      didOpenPlanSheet = false;

      await _showPlanReadySheet();
    }
  }

  List<String> _localizedStatuses(
      BuildContext context,
      ) {
    return [
      context.l10n.analyzingGoals,
      context.l10n.calculatingCalories,
      context.l10n
          .buildingMealSuggestions,
      context.l10n
          .designingWorkoutRoadmap,
    ];
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    final screenHeight =
        MediaQuery.sizeOf(context).height;

    final statuses =
    _localizedStatuses(context);

    return SystemNavigationBar(
      color: AppColors.onboardingBackground,
      child: PopScope(
        canPop: false,
        child: Scaffold(
          backgroundColor:
          AppColors.onboardingBackground,
          body: SafeArea(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal:
                screenWidth * 0.10,
              ),
              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height:
                    screenHeight * 0.14,
                  ),

                  Center(
                    child:
                    Transform.translate(
                      offset:
                      const Offset(10, 0),
                      child: SizedBox(
                        width: 250,
                        height: 250,
                        child: Lottie.asset(
                          'assets/animations/customize_plan.json',
                          repeat: true,
                          fit: BoxFit.contain,
                          alignment:
                          Alignment.center,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 26),

                  Center(
                    child: Text(
                      context.l10n
                          .customizeYourPlan,
                      textAlign:
                      TextAlign.center,
                      style: AppTextStyles
                          .headingLarge
                          .copyWith(
                        color:
                        AppColors.authText,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Center(
                    child: AnimatedSwitcher(
                      duration:
                      const Duration(
                        milliseconds: 350,
                      ),
                      layoutBuilder: (
                          currentChild,
                          previousChildren,
                          ) {
                        return Stack(
                          alignment:
                          Alignment.center,
                          children: [
                            ...previousChildren,
                            if (currentChild !=
                                null)
                              currentChild,
                          ],
                        );
                      },
                      transitionBuilder: (
                          child,
                          animation,
                          ) {
                        return FadeTransition(
                          opacity: animation,
                          child:
                          SlideTransition(
                            position:
                            Tween<Offset>(
                              begin:
                              const Offset(
                                0,
                                0.20,
                              ),
                              end:
                              Offset.zero,
                            ).animate(
                              animation,
                            ),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        isCreatingPlan
                            ? statuses[
                        currentStatusIndex]
                            : context.l10n
                            .yourPlanIsReady,
                        key: ValueKey(
                          isCreatingPlan
                              ? currentStatusIndex
                              : -1,
                        ),
                        textAlign:
                        TextAlign.center,
                        style: AppTextStyles
                            .bodyMedium
                            .copyWith(
                          color: AppColors
                              .onboardingText,
                          fontWeight:
                          FontWeight.w500,
                        ),
                      ),
                    ),
                  ),

                  const Spacer(),

                  Center(
                    child: Text(
                      isSaving
                          ? context.l10n
                          .savingPersonalizedPlan
                          : context.l10n
                          .thisMayTakeFewSeconds,
                      textAlign:
                      TextAlign.center,
                      style: AppTextStyles
                          .caption
                          .copyWith(
                        color: AppColors
                            .textSecondary,
                        fontWeight:
                        FontWeight.w400,
                      ),
                    ),
                  ),

                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}