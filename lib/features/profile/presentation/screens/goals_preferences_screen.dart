import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_dropdown_field.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_input.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/settings_card.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:fiteo_myapp/features/profile/utils/profile_messages.dart';

class GoalsPreferencesScreen extends StatefulWidget {
  const GoalsPreferencesScreen({super.key});

  @override
  State<GoalsPreferencesScreen> createState() => _GoalsPreferencesScreenState();
}

class _GoalsPreferencesScreenState extends State<GoalsPreferencesScreen> {
  String? selectedGoal = 'Lose Weight';
  String? selectedActivity = 'Moderately Active';
  String? selectedNutrition = 'High Protein';
  String? selectedWorkout = 'Home Workouts';

  final weightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final dailyCaloriesController = TextEditingController();
  final _profileRepository = ProfileRepository();

  bool isLoading = true;
  bool isSaving = false;

  final goals = const ['Lose Weight', 'Build Muscle', 'Maintain Fitness', 'Improve Health'];
  final activities = const ['Sedentary', 'Lightly Active', 'Moderately Active', 'Very Active'];
  final nutritionOptions = const ['No Restrictions', 'High Protein', 'Vegetarian', 'Vegan', 'Balanced Diet'];
  final workoutOptions = const ['Home Workouts', 'Gym', 'Walking / Cardio', 'Strength Training'];

  @override
  void initState() {
    super.initState();
    _loadPreferences();
  }

  Future<void> _loadPreferences() async {
    try {
      final doc = await _profileRepository.getCurrentUserDoc();
      final data = doc.data();

      final preferences = data?['userPreferences'] as Map<String, dynamic>?;

      if (preferences != null) {
        selectedGoal = preferences['goal'];
        selectedActivity = preferences['activityLevel'];
        selectedNutrition = preferences['nutritionPreference'];
        selectedWorkout = preferences['workoutPreference'];

        weightController.text = preferences['weight']?.toString() ?? '';
        targetWeightController.text = preferences['targetWeight']?.toString() ?? '';
        dailyCaloriesController.text = preferences['calorieGoal']?.toString() ?? '';
      }

      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });

      AppSnackbar.showError(context, ProfileMessages.profileUpdateFailed);
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    targetWeightController.dispose();
    dailyCaloriesController.dispose();
    super.dispose();
  }

  Future<void> _savePreferences() async {
    setState(() {
      isSaving = true;
    });

    try {
      await _profileRepository.updateUserPreferences({
        'goal': selectedGoal,
        'activityLevel': selectedActivity,
        'nutritionPreference': selectedNutrition,
        'workoutPreference': selectedWorkout,
        'weight': weightController.text.trim().isEmpty
            ? null
            : int.tryParse(weightController.text.trim()),
        'targetWeight': targetWeightController.text.trim().isEmpty
            ? null
            : int.tryParse(targetWeightController.text.trim()),
        'calorieGoal': dailyCaloriesController.text.trim().isEmpty
            ? null
            : int.tryParse(dailyCaloriesController.text.trim()),
      });

      if (!mounted) return;

      AppSnackbar.showSuccess(context, ProfileMessages.preferencesUpdated,
      );

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      AppSnackbar.showError(context, ProfileMessages.preferencesUpdateFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.homeBrown),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Goals & Preferences',
          style: TextStyle(
            color: AppColors.homeBrown,
            fontWeight: FontWeight.w800,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(
            screenWidth * 0.07,
            18,
            screenWidth * 0.07,
            40,
          ),
          child: Column(
            children: [
              SettingsCard(
                title: 'Body Goals',
                children: [
                  ProfileInput(
                    controller: weightController,
                    hintText: 'Current weight (kg)',
                    icon: Icons.monitor_weight_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 14),
                  ProfileInput(
                    controller: targetWeightController,
                    hintText: 'Target weight (kg)',
                    icon: Icons.track_changes,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                  const SizedBox(height: 14),
                  ProfileInput(
                    controller: dailyCaloriesController,
                    hintText: 'Daily calorie goal',
                    icon: Icons.local_fire_department_outlined,
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  ),
                ],
              ),

              const SizedBox(height: 22),

              SettingsCard(
                title: 'Preferences',
                children: [
                  ProfileDropdownField(
                    value: selectedGoal,
                    items: goals,
                    icon: Icons.flag_outlined,
                    onChanged: (value) => setState(() => selectedGoal = value),
                  ),
                  const SizedBox(height: 14),
                  ProfileDropdownField(
                    value: selectedActivity,
                    items: activities,
                    icon: Icons.directions_run_outlined,
                    onChanged: (value) => setState(() => selectedActivity = value),
                  ),
                  const SizedBox(height: 14),
                  ProfileDropdownField(
                    value: selectedNutrition,
                    items: nutritionOptions,
                    icon: Icons.restaurant_menu_outlined,
                    onChanged: (value) => setState(() => selectedNutrition = value),
                  ),
                  const SizedBox(height: 14),
                  ProfileDropdownField(
                    value: selectedWorkout,
                    items: workoutOptions,
                    icon: Icons.fitness_center_outlined,
                    onChanged: (value) => setState(() => selectedWorkout = value),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              CustomButton(
                text: isSaving ? 'Saving...' : 'Save changes',
                onPressed: isSaving || isLoading ? null : _savePreferences,
                backgroundColor: AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 54,
                width: screenWidth * 0.72,
                fontSize: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}