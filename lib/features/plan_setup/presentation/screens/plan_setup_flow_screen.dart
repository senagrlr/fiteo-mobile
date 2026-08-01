import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/plan_setup/presentation/screens/activity_level_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/ai_plan_loading_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/basic_info_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/goal_selection_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/goal_weight_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/nutrition_preference_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/plan_preview_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/workout_preference_screen.dart';

class PlanSetupFlowScreen extends StatefulWidget {
  const PlanSetupFlowScreen({
    super.key,
  });

  @override
  State<PlanSetupFlowScreen> createState() {
    return _PlanSetupFlowScreenState();
  }
}

class _PlanSetupFlowScreenState
    extends State<PlanSetupFlowScreen> {
  final PageController _pageController =
  PageController();

  final Map<String, dynamic> userPreferences = {};

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(
        milliseconds: 350,
      ),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(
        milliseconds: 350,
      ),
      curve: Curves.easeInOut,
    );
  }

  double get _initialGoalWeight {
    final currentWeight =
    userPreferences['weight'];

    if (currentWeight is int) {
      return currentWeight.toDouble();
    }

    if (currentWeight is double) {
      return currentWeight;
    }

    if (currentWeight is String) {
      return double.tryParse(
        currentWeight,
      ) ??
          70;
    }

    return 70;
  }

  void _openAiPlanLoadingScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) {
          return AiPlanLoadingScreen(
            userPreferences:
            Map<String, dynamic>.from(
              userPreferences,
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      physics:
      const NeverScrollableScrollPhysics(),
      children: [
        GoalSelectionScreen(
          onContinue: (goal) {
            userPreferences['goal'] = goal;
            nextPage();
          },
        ),

        BasicInfoScreen(
          onContinue: ({
            required age,
            required height,
            required weight,
            required gender,
          }) {
            userPreferences['age'] = age;
            userPreferences['height'] = height;
            userPreferences['weight'] = weight;
            userPreferences['gender'] = gender;

            nextPage();
          },
          onBack: previousPage,
        ),

        ActivityLevelScreen(
          onContinue: (activityLevel) {
            userPreferences['activityLevel'] =
                activityLevel;

            nextPage();
          },
          onBack: previousPage,
        ),

        NutritionPreferenceScreen(
          onContinue: (
              nutritionPreference,
              ) {
            userPreferences[
            'nutritionPreference'] =
                nutritionPreference;

            nextPage();
          },
          onBack: previousPage,
        ),

        WorkoutPreferenceScreen(
          onContinue: (
              workoutPreference,
              ) {
            userPreferences[
            'workoutPreference'] =
                workoutPreference;

            nextPage();
          },
          onBack: previousPage,
        ),

        GoalWeightScreen(
          initialWeightKg: _initialGoalWeight,
          onContinue: (goalWeightKg) {
            userPreferences['targetWeight'] =
                goalWeightKg;

            nextPage();
          },
          onBack: previousPage,
        ),

        PlanPreviewScreen(
          onBack: previousPage,
          onCreatePlan:
          _openAiPlanLoadingScreen,
        ),
      ],
    );
  }
}