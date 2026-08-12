import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/goal_option_card.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class GoalSelectionScreen extends StatefulWidget {
  final ValueChanged<String> onContinue;

  const GoalSelectionScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<GoalSelectionScreen> createState() =>
      _GoalSelectionScreenState();
}

class _GoalSelectionScreenState
    extends State<GoalSelectionScreen> {
  String? selectedGoal;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final goals = [
      (
      value: 'Lose Weight',
      label: context.l10n.goalLoseWeight,
      emoji: '🏃',
      ),
      (
      value: 'Build Muscle',
      label: context.l10n.goalBuildMuscle,
      emoji: '💪',
      ),
      (
      value: 'Maintain Fitness',
      label: context.l10n.goalMaintainFitness,
      emoji: '⚖️',
      ),
      (
      value: 'Improve Health',
      label: context.l10n.goalImproveHealth,
      emoji: '❤️',
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
              crossAxisAlignment:
              CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 24),

                const SetupProgressIndicator(
                  currentStep: 1,
                  totalSteps: 7,
                ),

                const SizedBox(height: 80),

                Text(
                  context.l10n.planSetupMainGoalTitle,
                  textAlign: TextAlign.center,
                  style:
                  AppTextStyles.headingLarge.copyWith(
                    color: AppColors.authText,
                  ),
                ),

                const SizedBox(height: 42),

                ...goals.map(
                      (goal) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 16,
                    ),
                    child: GoalOptionCard(
                      title:
                      '${goal.emoji}  ${goal.label}',
                      isSelected:
                      selectedGoal ==
                          goal.value,
                      onTap: () {
                        setState(() {
                          selectedGoal =
                              goal.value;
                        });
                      },
                    ),
                  ),
                ),

                const Spacer(),

                CustomButton(
                  text:
                  context.l10n.continueText,
                  onPressed: selectedGoal == null
                      ? null
                      : () => widget.onContinue(
                    selectedGoal!,
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