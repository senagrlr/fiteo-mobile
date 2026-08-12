import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/goal_option_card.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class ActivityLevelScreen extends StatefulWidget {
  final ValueChanged<String> onContinue;
  final VoidCallback onBack;

  const ActivityLevelScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<ActivityLevelScreen> createState() =>
      _ActivityLevelScreenState();
}

class _ActivityLevelScreenState
    extends State<ActivityLevelScreen> {
  String? selectedActivity;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final activities = [
      (
      value: 'Sedentary',
      label: context.l10n.activitySedentary,
      ),
      (
      value: 'Lightly Active',
      label: context.l10n.activityLightlyActive,
      ),
      (
      value: 'Moderately Active',
      label: context.l10n.activityModeratelyActive,
      ),
      (
      value: 'Very Active',
      label: context.l10n.activityVeryActive,
      ),
    ];

    return SystemNavigationBar(
      color: AppColors.onboardingBackground,
      child: Scaffold(
        backgroundColor:
        AppColors.onboardingBackground,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.10,
            ),
            child: Column(
              children: [
                const SizedBox(height: 18),

                const SetupProgressIndicator(
                  currentStep: 3,
                  totalSteps: 7,
                ),

                const SizedBox(height: 25),

                Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onBack,
                    child: const Icon(
                      Icons.arrow_back_ios_new,
                      size: 24,
                      color: AppColors.authText,
                    ),
                  ),
                ),

                const SizedBox(height: 60),

                Text(
                  context.l10n.activityLevelTitle,
                  textAlign: TextAlign.center,
                  style:
                  AppTextStyles.headingLarge.copyWith(
                    color: AppColors.authText,
                  ),
                ),

                const SizedBox(height: 42),

                ...activities.map(
                      (activity) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: GoalOptionCard(
                      title: activity.label,
                      isSelected:
                      selectedActivity ==
                          activity.value,
                      onTap: () {
                        setState(() {
                          selectedActivity =
                              activity.value;
                        });
                      },
                    ),
                  ),
                ),

                const Spacer(),

                CustomButton(
                  text: context.l10n.continueText,
                  onPressed: selectedActivity == null
                      ? null
                      : () => widget.onContinue(
                    selectedActivity!,
                  ),
                  backgroundColor:
                  AppColors.authButtonGreen,
                  textColor: Colors.white,
                  height: 54,
                  width: screenWidth * 0.72,
                  fontSize: 22,
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}