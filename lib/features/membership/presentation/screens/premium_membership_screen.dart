import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';

import 'package:fiteo_myapp/features/membership/presentation/models/premium_feature_item.dart';

import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_membership_header.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_benefits_list.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_status_card.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_manage_button.dart';

class PremiumMembershipScreen extends StatefulWidget {
  const PremiumMembershipScreen({
    super.key,
  });

  @override
  State<PremiumMembershipScreen> createState() =>
      _PremiumMembershipScreenState();
}

class _PremiumMembershipScreenState
    extends State<PremiumMembershipScreen> {
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

      PremiumFeatureItem(
        imageAsset:
        'assets/images/premium_recipe_personalization.png',
        title:
        context.l10n.premiumRecipePersonalization,
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

        // Header status bar'ın arkasına kadar gider.
        extendBodyBehindAppBar: true,

        body: SafeArea(
          // Üstte SafeArea boşluğu bırakmıyoruz.
          // Altın header sistem barının arkasına uzanıyor.
          top: false,
          bottom: false,
          child: Column(
            children: [
              // ====================================================
              // PREMIUM HEADER + FEATURES + INDICATOR
              // ====================================================

              SizedBox(
                height: 430,
                child: Stack(
                  clipBehavior:
                  Clip.none,
                  children: [
                    PremiumMembershipHeader(
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
              // INDICATOR ↔ PLAN CARD BOŞLUĞU
              // ====================================================

              const SizedBox(
                height: 40,
              ),

              // ====================================================
              // CURRENT PLAN
              // ====================================================

              const Padding(
                padding:
                EdgeInsets.symmetric(
                  horizontal: 28,
                ),
                child:
                PremiumStatusCard(
                  planName:
                  'Yıllık Plan',
                  renewalDate:
                  '20 Ağustos 2026',
                  price:
                  '₺1659/yıl',
                ),
              ),

              // ====================================================
              // PLAN CARD ↔ MANAGE BUTTON BOŞLUĞU
              // ====================================================

              const SizedBox(
                height: 30,
              ),

              // ====================================================
              // MANAGE SUBSCRIPTION
              // ====================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 48,
                ),
                child:
                PremiumManageButton(
                  onTap: () {
                    // UI callback.
                    // Abonelik yönetimi daha sonra bağlanacak.
                  },
                ),
              ),

              const SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }
}