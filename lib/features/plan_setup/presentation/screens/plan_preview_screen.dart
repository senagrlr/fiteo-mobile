import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/plan_comparison_chart.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class PlanPreviewScreen extends StatelessWidget {
  final VoidCallback onBack;
  final VoidCallback onCreatePlan;

  const PlanPreviewScreen({
    super.key,
    required this.onBack,
    required this.onCreatePlan,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;

    return SystemNavigationBar(
      color: AppColors.onboardingBackground,
      child: Scaffold(
        backgroundColor: AppColors.onboardingBackground,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.10,
              24,
              screenWidth * 0.10,
              36,
            ),
            child: Column(
              children: [
                const SetupProgressIndicator(
                  currentStep: 7,
                  totalSteps: 7,
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: onBack,
                    behavior: HitTestBehavior.opaque,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(
                        Icons.arrow_back_ios_new,
                        size: 24,
                        color: AppColors.authText,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 28),

                Text(
                  context.l10n.planPreviewTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingLarge.copyWith(
                    color: AppColors.authText,
                  ),
                ),

                const SizedBox(height: 28),

                const PlanComparisonChart(),

                const SizedBox(height: 26),

                Text(
                  context.l10n.planPreviewDescription,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.authText.withValues(
                      alpha: 0.78,
                    ),
                    height: 1.50,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 34),

                CustomButton(
                  text: context.l10n.createMyPlan,
                  onPressed: onCreatePlan,
                  backgroundColor: AppColors.authButtonGreen,
                  textColor: Colors.white,
                  height: 54,
                  width: screenWidth * 0.72,
                  fontSize: 21,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}