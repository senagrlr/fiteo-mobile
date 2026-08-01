import 'dart:async';
import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
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

class _AiPlanLoadingScreenState extends State<AiPlanLoadingScreen> {
  final List<String> statuses = const [
    'Analyzing goals...',
    'Calculating calories...',
    'Building meal suggestions...',
    'Designing workout roadmap...',
  ];

  Timer? _statusTimer;

  int currentStatusIndex = 0;

  bool isCreatingPlan = true;
  bool isSaving = false;
  bool didOpenPlanSheet = false;

  late AiNutritionPlan generatedPlan;

  @override
  void initState() {
    super.initState();

    generatedPlan = _createTemporaryPlan();
    _startLoadingAnimation();
  }

  AiNutritionPlan _createTemporaryPlan() {
    final weight = _readDouble(
      widget.userPreferences['weight'],
      fallback: 70,
    );

    final height = _readDouble(
      widget.userPreferences['height'],
      fallback: 170,
    );

    final age = _readDouble(
      widget.userPreferences['age'],
      fallback: 25,
    );

    final gender =
    (widget.userPreferences['gender'] ?? 'Female').toString();

    final goal =
    (widget.userPreferences['goal'] ?? 'Maintain Fitness').toString();

    final activityLevel =
    (widget.userPreferences['activityLevel'] ?? 'Moderately Active')
        .toString();

    final bmr = gender == 'Male'
        ? (10 * weight) +
        (6.25 * height) -
        (5 * age) +
        5
        : (10 * weight) +
        (6.25 * height) -
        (5 * age) -
        161;

    final activityMultiplier = switch (activityLevel) {
      'Sedentary' => 1.20,
      'Lightly Active' => 1.375,
      'Moderately Active' => 1.55,
      'Very Active' => 1.725,
      _ => 1.45,
    };

    double calories = bmr * activityMultiplier;

    if (goal == 'Lose Weight') {
      calories -= 350;
    } else if (goal == 'Build Muscle') {
      calories += 250;
    }

    calories = calories.clamp(1200, 4000);

    final protein = goal == 'Build Muscle'
        ? weight * 1.8
        : weight * 1.5;

    final fatCalories = calories * 0.28;
    final fats = fatCalories / 9;

    final proteinCalories = protein * 4;

    final carbCalories = math.max(
      0,
      calories - fatCalories - proteinCalories,
    );

    final carbs = carbCalories / 4;

    final waterMl = math.max(
      1800,
      weight * 35,
    );

    return AiNutritionPlan(
      calories: calories.round(),
      proteinGrams: protein.round(),
      carbsGrams: carbs.round(),
      fatsGrams: fats.round(),
      waterMl: waterMl.round(),
    );
  }

  double _readDouble(
      dynamic value, {
        required double fallback,
      }) {
    if (value is int) {
      return value.toDouble();
    }

    if (value is double) {
      return value;
    }

    if (value is String) {
      return double.tryParse(value) ?? fallback;
    }

    return fallback;
  }

  void _startLoadingAnimation() {
    _statusTimer = Timer.periodic(
      const Duration(milliseconds: 1700),
          (timer) async {
        if (!mounted) return;

        if (currentStatusIndex < statuses.length - 1) {
          setState(() {
            currentStatusIndex++;
          });

          return;
        }

        timer.cancel();

        setState(() {
          isCreatingPlan = false;
        });

        await Future.delayed(
          const Duration(milliseconds: 500),
        );

        if (!mounted || didOpenPlanSheet) {
          return;
        }

        didOpenPlanSheet = true;

        await _showPlanReadySheet();
      },
    );
  }

  Future<void> _showPlanReadySheet() async {
    final result = await showModalBottomSheet<AiNutritionPlan>(
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

  Future<void> _savePlanAndContinue() async {
    if (isSaving) return;

    setState(() {
      isSaving = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user == null) {
        throw Exception('User not logged in');
      }

      final updatedPreferences = Map<String, dynamic>.from(
        widget.userPreferences,
      );

      updatedPreferences.addAll({
        'calorieGoal': generatedPlan.calories,
        'proteinGoal': generatedPlan.proteinGrams,
        'carbsGoal': generatedPlan.carbsGrams,
        'fatGoal': generatedPlan.fatsGrams,
        'waterGoalMl': generatedPlan.waterMl,
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .set({
        'userPreferences': updatedPreferences,
        'nutritionPlan': {
          'dailyCalories': generatedPlan.calories,
          'proteinGrams': generatedPlan.proteinGrams,
          'carbsGrams': generatedPlan.carbsGrams,
          'fatsGrams': generatedPlan.fatsGrams,
          'waterMl': generatedPlan.waterMl,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        },
        'isOnboardingCompleted': true,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

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
        'Your plan could not be saved.',
      );

      didOpenPlanSheet = false;

      await _showPlanReadySheet();
    }
  }

  @override
  void dispose() {
    _statusTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.10,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  height: screenHeight * 0.14,
                ),

                Center(
                  child: Transform.translate(
                    // Lottie dosyasının iç çizimi biraz solda olduğu
                    // için yalnızca animasyonu sağa taşıyoruz.
                    offset: const Offset(10, 0),
                    child: SizedBox(
                      width: 250,
                      height: 250,
                      child: Lottie.asset(
                        'assets/animations/customize_plan.json',
                        repeat: true,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 26),

                const Center(
                  child: Text(
                    'Customize your plan',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.authText,
                      fontSize: 25,
                      height: 1.2,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                Center(
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 350),
                    layoutBuilder: (
                        currentChild,
                        previousChildren,
                        ) {
                      return Stack(
                        alignment: Alignment.center,
                        children: [
                          ...previousChildren,
                          if (currentChild != null) currentChild,
                        ],
                      );
                    },
                    transitionBuilder: (
                        child,
                        animation,
                        ) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.20),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: Text(
                      isCreatingPlan
                          ? statuses[currentStatusIndex]
                          : 'Your plan is ready!',
                      key: ValueKey(
                        isCreatingPlan
                            ? currentStatusIndex
                            : -1,
                      ),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: AppColors.onboardingText,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),

                const Spacer(),

                Center(
                  child: Text(
                    isSaving
                        ? 'Saving your personalized plan...'
                        : 'This may take a few seconds.',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Color(0xFF5E4A4A),
                      fontSize: 13,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                const SizedBox(height: 34),
              ],
            ),
          ),
        ),
      ),
    );
  }
}