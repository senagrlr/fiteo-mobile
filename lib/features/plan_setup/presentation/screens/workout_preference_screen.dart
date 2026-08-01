import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
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

class _WorkoutPreferenceScreenState extends State<WorkoutPreferenceScreen> {
  String? selectedWorkout;

  final List<String> workoutOptions = const [
    'Home Workouts',
    'Gym',
    'Walking / Cardio',
    'Strength Training',
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.10),
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

              const Text(
                'How do you like\nto work out?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 42),

              ...workoutOptions.map(
                    (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GoalOptionCard(
                    title: option,
                    isSelected: selectedWorkout == option,
                    onTap: () {
                      setState(() {
                        selectedWorkout = option;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'Continue',
                onPressed: selectedWorkout == null
                    ? null
                    : () => widget.onContinue(selectedWorkout!),
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