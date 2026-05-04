import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/goal_option_card.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class ActivityLevelScreen extends StatefulWidget {
  final VoidCallback onContinue;
  final VoidCallback onBack;

  const ActivityLevelScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<ActivityLevelScreen> createState() => _ActivityLevelScreenState();
}

class _ActivityLevelScreenState extends State<ActivityLevelScreen> {
  String? selectedActivity;

  final List<String> activities = const [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
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
                currentStep: 3,
                totalSteps: 6,
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
                'How active are you?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 42),

              ...activities.map(
                    (activity) => Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: GoalOptionCard(
                    title: activity,
                    isSelected: selectedActivity == activity,
                    onTap: () {
                      setState(() {
                        selectedActivity = activity;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'Continue',
                onPressed:
                selectedActivity == null ? null : widget.onContinue,
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