import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/models/onboarding_page_model.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/widgets/onboarding_indicator.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/widgets/onboarding_page_item.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() =>
      _OnboardingScreenState();
}

class _OnboardingScreenState
    extends State<OnboardingScreen> {
  final PageController _pageController =
  PageController();

  int _currentIndex = 0;

  List<OnboardingPageModel> _pages(
      BuildContext context,
      ) =>
      [
        OnboardingPageModel(
          asset:
          'assets/animations/onboarding_1.json',
          title:
          context.l10n.onboardingPage1Title,
          mediaHeightFactor: 0.50,
          isLottie: true,
        ),
        OnboardingPageModel(
          asset:
          'assets/animations/onboarding_2.json',
          title:
          context.l10n.onboardingPage2Title,
          mediaHeightFactor: 0.30,
          isLottie: true,
          textSpacing: 0.05,
          topSpacing: 0.250,
        ),
        OnboardingPageModel(
          asset:
          'assets/animations/onboarding_3.json',
          title:
          context.l10n.onboardingPage3Title,
          mediaHeightFactor: 0.56,
          textSpacing: 0,
          topSpacing: 0.070,
          isLottie: true,
        ),
        OnboardingPageModel(
          asset:
          'assets/animations/onboarding_4.json',
          headerTitle:
          context.l10n.onboardingMeetFiteo,
          title:
          context.l10n.onboardingPage4Title,
          mediaHeightFactor: 0.44,
          isLottie: true,
          headerSpacing: 0.005,
          topSpacing: 0.15,
        ),
      ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.of(context).size.height;

    final screenWidth =
        MediaQuery.of(context).size.width;

    final pages =
    _pages(context);

    return SystemNavigationBar(
      color:
      AppColors.onboardingBackground,
      child: Scaffold(
        backgroundColor:
        AppColors.onboardingBackground,
        body: SafeArea(
          child: Stack(
            children: [
              PageView.builder(
                controller:
                _pageController,
                onPageChanged:
                _onPageChanged,
                itemCount:
                pages.length,
                itemBuilder:
                    (context, index) {
                  return OnboardingPageItem(
                    page:
                    pages[index],
                  );
                },
              ),

              if (_currentIndex == 3)
                Positioned(
                  top: 16,
                  right: 20,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.signup,
                      );
                    },
                    child: Text(
                      context.l10n.skip,
                      style: AppTextStyles
                          .labelLarge
                          .copyWith(
                        color: AppColors
                            .onboardingText,
                      ),
                    ),
                  ),
                ),

              Positioned(
                bottom:
                screenHeight * 0.05,
                right:
                screenWidth * 0.10,
                child:
                OnboardingIndicator(
                  currentIndex:
                  _currentIndex,
                  itemCount:
                  pages.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}