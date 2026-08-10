import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/goal_option_card.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class WorkoutPreferenceScreen extends StatefulWidget {
  final ValueChanged<String> onContinue;
  final VoidCallback onBack;

  const WorkoutPreferenceScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<WorkoutPreferenceScreen> createState() =>
      _WorkoutPreferenceScreenState();
}

class _WorkoutPreferenceScreenState
    extends State<WorkoutPreferenceScreen> {
  String? selectedWorkout;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final workoutOptions = [
      (
      value: 'Home Workouts',
      label: context.l10n.workoutHome,
      ),
      (
      value: 'Gym',
      label: context.l10n.workoutGym,
      ),
      (
      value: 'Walking / Cardio',
      label: context.l10n.workoutWalkingCardio,
      ),
      (
      value: 'Strength Training',
      label: context.l10n.workoutStrengthTraining,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.10,
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),

              const SetupProgressIndicator(
                currentStep: 5,
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
                context.l10n.workoutPreferenceTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 42),

              ...workoutOptions.map(
                    (option) => Padding(
                  padding: const EdgeInsets.only(
                    bottom: 16,
                  ),
                  child: GoalOptionCard(
                    title: option.label,
                    isSelected:
                    selectedWorkout == option.value,
                    onTap: () {
                      setState(() {
                        selectedWorkout = option.value;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: context.l10n.continueText,
                onPressed: selectedWorkout == null
                    ? null
                    : () => widget.onContinue(
                  selectedWorkout!,
                ),
                backgroundColor: AppColors.authButtonGreen,
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
    );
  }
}