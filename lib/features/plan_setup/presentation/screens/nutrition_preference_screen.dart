import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/goal_option_card.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class NutritionPreferenceScreen extends StatefulWidget {
  final ValueChanged<String> onContinue;
  final VoidCallback onBack;

  const NutritionPreferenceScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<NutritionPreferenceScreen> createState() =>
      _NutritionPreferenceScreenState();
}

class _NutritionPreferenceScreenState extends State<NutritionPreferenceScreen> {
  String? selectedNutrition;

  final List<String> nutritionOptions = const [
    'No Restrictions',
    'High Protein',
    'Vegetarian',
    'Vegan',
    'Balanced Diet',
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
                currentStep: 4,
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
                'What do you prefer\nto eat?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  height: 1.2,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 30),

              ...nutritionOptions.map(
                    (option) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: GoalOptionCard(
                    title: option,
                    isSelected: selectedNutrition == option,
                    onTap: () {
                      setState(() {
                        selectedNutrition = option;
                      });
                    },
                  ),
                ),
              ),

              const Spacer(),

              CustomButton(
                text: 'Continue',
                onPressed: selectedNutrition == null
                    ? null
                    : () => widget.onContinue(selectedNutrition!),
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