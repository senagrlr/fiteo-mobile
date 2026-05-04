import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/basic_info_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/goal_selection_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/activity_level_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/nutrition_preference_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/workout_preference_screen.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/screens/ai_plan_loading_screen.dart';

class PlanSetupFlowScreen extends StatefulWidget {
  const PlanSetupFlowScreen({super.key});

  @override
  State<PlanSetupFlowScreen> createState() => _PlanSetupFlowScreenState();
}

class _PlanSetupFlowScreenState extends State<PlanSetupFlowScreen> {
  final PageController _pageController = PageController();

  void nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
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
      physics: const NeverScrollableScrollPhysics(),
      children: [
        GoalSelectionScreen(
          onContinue: nextPage,
        ),
        BasicInfoScreen(
          onContinue: nextPage,
          onBack: previousPage,
        ),
        ActivityLevelScreen(
          onContinue: nextPage,
          onBack: previousPage,
        ),
        NutritionPreferenceScreen(
          onContinue: nextPage,
          onBack: previousPage,
        ),
        WorkoutPreferenceScreen(
          onContinue: nextPage,
          onBack: previousPage,
        ),
        const AiPlanLoadingScreen(),
      ],
    );
  }
}