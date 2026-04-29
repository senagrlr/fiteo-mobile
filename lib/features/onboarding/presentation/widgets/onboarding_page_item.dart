import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/features/onboarding/presentation/models/onboarding_page_model.dart';

class OnboardingPageItem extends StatelessWidget {
  final OnboardingPageModel page;

  const OnboardingPageItem({
    super.key,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: screenHeight * page.topSpacing),

            if (page.headerTitle != null) ...[
              Text(
                page.headerTitle!,
                textAlign: TextAlign.center,
                style: AppTextStyles.onboardingHeader(context),
              ),
              SizedBox(height: screenHeight * page.headerSpacing),
            ],

            Center(
              child: SizedBox(
                height: screenHeight * page.mediaHeightFactor,
                width: screenWidth * 0.88,
                child: page.isLottie
                    ? Lottie.asset(
                  page.asset,
                  fit: BoxFit.contain,
                )
                    : Image.asset(
                  page.asset,
                  fit: BoxFit.contain,
                ),
              ),
            ),

            SizedBox(height: screenHeight * page.textSpacing),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.03),
              child: Text(
                page.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.onboardingTitle(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}