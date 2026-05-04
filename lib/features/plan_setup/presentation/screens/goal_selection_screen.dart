import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/goal_option_card.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class GoalSelectionScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const GoalSelectionScreen({
    super.key,
    required this.onContinue,
  });

  @override
  State<GoalSelectionScreen> createState() => _GoalSelectionScreenState();
}

class _GoalSelectionScreenState extends State<GoalSelectionScreen> {
  String? selectedGoal;

  final List<String> goals = const [
    'Lose Weight',
    'Build Muscle',
    'Maintain Fitness',
    'Improve Health',
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 24),

              const SetupProgressIndicator(
                currentStep: 1,
                totalSteps: 6,
              ),

              const SizedBox(height: 80),

              const Text(
                'What is your main goal?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 42),

              ...goals.map(
                    (goal) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GoalOptionCard(
                    title: goal,
                    isSelected: selectedGoal == goal,
                    onTap: () {
                      setState(() {
                        selectedGoal = goal;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'Continue',
                onPressed: selectedGoal == null ? null : widget.onContinue,
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