import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
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

    return Scaffold(
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

              const Text(
                'Your goals deserve\na plan made for you',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.authText,
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 28),

              const PlanComparisonChart(),

              const SizedBox(height: 26),

              Text(
                'Generic plans often lose momentum over time. '
                    'Fiteo adapts to your goals and lifestyle to help '
                    'you keep progressing toward your goal.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.authText.withValues(
                    alpha: 0.78,
                  ),
                  fontSize: 15,
                  height: 1.50,
                  fontWeight: FontWeight.w500,
                ),
              ),

              const SizedBox(height: 34),

              CustomButton(
                text: 'Create my plan',
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
    );
  }
}