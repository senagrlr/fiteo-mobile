import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
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

class _NutritionPreferenceScreenState
    extends State<NutritionPreferenceScreen> {
  String? selectedNutrition;

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final nutritionOptions = [
      (
      value: 'No Restrictions',
      label: context.l10n.nutritionNoRestrictions,
      ),
      (
      value: 'High Protein',
      label: context.l10n.nutritionHighProtein,
      ),
      (
      value: 'Vegetarian',
      label: context.l10n.nutritionVegetarian,
      ),
      (
      value: 'Vegan',
      label: context.l10n.nutritionVegan,
      ),
      (
      value: 'Balanced Diet',
      label: context.l10n.nutritionBalancedDiet,
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
                  currentStep: 4,
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
                  context.l10n.nutritionPreferenceTitle,
                  textAlign: TextAlign.center,
                  style:
                  AppTextStyles.headingLarge.copyWith(
                    color: AppColors.authText,
                  ),
                ),

                const SizedBox(height: 30),

                ...nutritionOptions.map(
                      (option) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: 14,
                    ),
                    child: GoalOptionCard(
                      title: option.label,
                      isSelected:
                      selectedNutrition ==
                          option.value,
                      onTap: () {
                        setState(() {
                          selectedNutrition =
                              option.value;
                        });
                      },
                    ),
                  ),
                ),

                const Spacer(),

                CustomButton(
                  text: context.l10n.continueText,
                  onPressed: selectedNutrition == null
                      ? null
                      : () => widget.onContinue(
                    selectedNutrition!,
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