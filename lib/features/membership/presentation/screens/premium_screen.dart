import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/membership/presentation/models/premium_feature_item.dart';

import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_header.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_benefits_list.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_annual_plan_card.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_monthly_plan_card.dart';

class PremiumScreen extends StatefulWidget {
  final VoidCallback? onAnnualPlanTap;
  final VoidCallback? onMonthlyPlanTap;

  const PremiumScreen({
    super.key,
    this.onAnnualPlanTap,
    this.onMonthlyPlanTap,
  });

  @override
  State<PremiumScreen> createState() =>
      _PremiumScreenState();
}

class _PremiumScreenState
    extends State<PremiumScreen> {
  final PageController _pageController =
  PageController();

  int _currentIndex = 0;

  List<PremiumFeatureItem> _features(
      BuildContext context,
      ) {
    return [
      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_unlimited_recipes.png',
        title:
        context.l10n.premiumUnlimitedRecipes,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_barcode.png',
        title:
        context.l10n.premiumBarcodeScanning,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_smart_notifications.png',
        title:
        context.l10n.premiumSmartNotifications,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_unlimited_ai.png',
        title:
        context.l10n.premiumUnlimitedAi,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_goal_prediction.png',
        title:
        context.l10n.premiumGoalPrediction,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_recipe_personalization.png',
        title:
        context.l10n.premiumRecipePersonalization,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_adaptive_progress.png',
        title:
        context.l10n.premiumAdaptiveProgress,
      ),

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_reports.png',
        title:
        context.l10n.premiumReports,
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final features =
    _features(context);

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
        Brightness.light,
        statusBarBrightness:
        Brightness.dark,
      ),
      child: Scaffold(
        backgroundColor:
        AppColors.surfacePrimary,
        extendBodyBehindAppBar: true,
        body: SafeArea(
          top: false,
          bottom: false,
          child: Column(
            children: [
              // ====================================================
              // HEADER + ILLUSTRATION + TEXT + INDICATOR
              // ====================================================

              SizedBox(
                height: 430,
                child: Stack(
                  clipBehavior:
                  Clip.none,
                  children: [
                    PremiumHeader(
                      onClose: () {
                        Navigator.pop(
                          context,
                        );
                      },
                    ),

                    Positioned(
                      top: 140,
                      left: 0,
                      right: 0,
                      child:
                      PremiumBenefitsList(
                        pageController:
                        _pageController,
                        features:
                        features,
                        currentIndex:
                        _currentIndex,
                        onPageChanged:
                            (index) {
                          setState(() {
                            _currentIndex =
                                index;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),

              // ====================================================
              // INDICATOR ↔ PLAN CARDS
              // ====================================================

              const SizedBox(
                height: 30,
              ),

              // ====================================================
              // ANNUAL PLAN
              // ====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child:
                PremiumAnnualPlanCard(
                  onTap:
                  widget.onAnnualPlanTap,
                ),
              ),

              const SizedBox(
                height: 19,
              ),

              // ====================================================
              // MONTHLY PLAN
              // ====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child:
                PremiumMonthlyPlanCard(
                  onTap:
                  widget.onMonthlyPlanTap,
                ),
              ),

              const SizedBox(
                height: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}