import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/utils/weight_unit_converter.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/membership/data/premium_access_service.dart';
import 'package:fiteo_myapp/features/membership/presentation/premium_navigation.dart';

import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_dropdown_field.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_input.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/settings_card.dart';

class GoalsPreferencesScreen extends StatefulWidget {
  const GoalsPreferencesScreen({
    super.key,
  });

  @override
  State<GoalsPreferencesScreen> createState() =>
      _GoalsPreferencesScreenState();
}

class _GoalsPreferencesScreenState
    extends State<GoalsPreferencesScreen> {
  String? selectedGoal = 'Lose Weight';
  String? selectedActivity = 'Moderately Active';
  String? selectedNutrition = 'High Protein';
  String? selectedWorkout = 'Home Workouts';

  List<String> selectedDietaryRequirements = [];

  String weightUnit = 'kg';

  final weightController = TextEditingController();
  final targetWeightController = TextEditingController();
  final dailyCaloriesController = TextEditingController();

  final ProfileRepository _profileRepository =
  ProfileRepository();

  final PremiumAccessService _premiumAccessService =
  PremiumAccessService();

  bool isLoading = true;
  bool isSaving = false;
  bool isPremium = false;

  final List<String> goals = const [
    'Lose Weight',
    'Build Muscle',
    'Maintain Fitness',
    'Improve Health',
  ];

  final List<String> activities = const [
    'Sedentary',
    'Lightly Active',
    'Moderately Active',
    'Very Active',
  ];

  final List<String> nutritionOptions = const [
    'No Restrictions',
    'Balanced Diet',
    'High Protein',
    'Mediterranean',
  ];

  final List<String> workoutOptions = const [
    'Home Workouts',
    'Gym',
    'Walking / Cardio',
    'Strength Training',
  ];

  final List<String> dietaryRequirementOptions = const [
    'Vegetarian',
    'Vegan',
    'Pescatarian',
    'Keto',
    'Gluten Free',
    'Dairy Free',
  ];

  @override
  void initState() {
    super.initState();
    _initializeScreen();
  }

  Future<void> _initializeScreen() async {
    final premium =
    await _premiumAccessService.isPremium();

    if (!mounted) {
      return;
    }

    setState(() {
      isPremium = premium;
    });

    await _loadPreferences();
  }

  Future<void> _showDietaryRequirementsPremiumDialog() async {
    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (dialogContext) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.symmetric(
            horizontal: 32,
          ),
          child: Container(
            padding: const EdgeInsets.fromLTRB(
              24,
              28,
              24,
              24,
            ),
            decoration: BoxDecoration(
              color: AppColors.surfacePrimary,
              borderRadius: BorderRadius.circular(28),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.lock_rounded,
                  size: 62,
                  color: AppColors.homeBrown,
                ),

                const SizedBox(height: 14),

                Text(
                  context.l10n.goPremiumToUnlockFeature,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 20),

                SizedBox(
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();

                      PremiumNavigation.openPaywall(
                        context,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor:
                      AppColors.brandPrimary,
                      foregroundColor:
                      AppColors.onPrimary,
                      padding:
                      const EdgeInsets.symmetric(
                        horizontal: 30,
                      ),
                      shape: const StadiumBorder(),
                    ),
                    child: Text(
                      context.l10n.goPremium,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showDietaryRequirementsDialog() async {
    if (!isPremium) {
      await _showDietaryRequirementsPremiumDialog();
      return;
    }

    final tempSelected =
    List<String>.from(selectedDietaryRequirements);

    final result = await showDialog<List<String>>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(
        alpha: 0.22,
      ),
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (
              context,
              setDialogState,
              ) {
            return Dialog(
              backgroundColor: Colors.transparent,
              insetPadding: const EdgeInsets.symmetric(
                horizontal: 26,
              ),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(
                  24,
                  28,
                  24,
                  22,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfacePrimary,
                  borderRadius:
                  BorderRadius.circular(28),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.dietaryRequirements,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyles.titleMedium.copyWith(
                        color: AppColors.homeBrown,
                        fontSize: 19,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 22),

                    Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      runSpacing: 10,
                      children:
                      dietaryRequirementOptions
                          .map((option) {
                        final isSelected =
                        tempSelected.contains(
                          option,
                        );

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              setDialogState(() {
                                if (isSelected) {
                                  tempSelected.remove(
                                    option,
                                  );
                                } else {
                                  tempSelected.add(
                                    option,
                                  );
                                }
                              });
                            },
                            borderRadius:
                            BorderRadius.circular(22),
                            child: AnimatedContainer(
                              duration: const Duration(
                                milliseconds: 160,
                              ),
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 15,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.brandPrimary
                                    .withValues(
                                  alpha: 0.16,
                                )
                                    : AppColors.surfaceSoft,
                                borderRadius:
                                BorderRadius.circular(22),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.brandPrimary
                                      : AppColors.homeBrown
                                      .withValues(
                                    alpha: 0.08,
                                  ),
                                  width:
                                  isSelected ? 1.5 : 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  if (isSelected) ...[
                                    const Icon(
                                      Icons.check_rounded,
                                      color:
                                      AppColors.brandPrimary,
                                      size: 17,
                                    ),
                                    const SizedBox(width: 5),
                                  ],
                                  Text(
                                    _dietaryRequirementLabel(
                                      option,
                                    ),
                                    style: AppTextStyles
                                        .labelMedium
                                        .copyWith(
                                      color: isSelected
                                          ? AppColors.homeBrown
                                          : AppColors
                                          .homeSecondaryValue,
                                      fontSize: 13,
                                      fontWeight: isSelected
                                          ? FontWeight.w700
                                          : FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      context.l10n
                          .dietaryRequirementsHint,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyles.bodySmall.copyWith(
                        color:
                        AppColors.homeSecondaryValue,
                        fontSize: 11,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(
                            dialogContext,
                            tempSelected,
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor:
                          AppColors.homeBrown,
                          side: BorderSide(
                            color: AppColors.homeBrown
                                .withValues(
                              alpha: 0.22,
                            ),
                          ),
                          shape: const StadiumBorder(),
                        ),
                        child: Text(
                          context.l10n.save,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(
                          dialogContext,
                          <String>[],
                        );
                      },
                      child: Text(
                        context.l10n.noRestriction,
                        style: AppTextStyles.bodySmall
                            .copyWith(
                          color:
                          AppColors.homeSecondaryValue,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );

    if (result == null || !mounted) {
      return;
    }

    setState(() {
      selectedDietaryRequirements = result;
    });
  }

  String _formatWeight(double value) {
    return value.toStringAsFixed(1);
  }

  Future<void> _loadPreferences() async {
    try {
      final doc =
      await _profileRepository.getCurrentUserDoc();

      final data = doc.data();

      final preferences =
      data?['userPreferences']
      as Map<String, dynamic>?;

      final nutritionPlan =
      data?['nutritionPlan']
      as Map<String, dynamic>?;

      if (preferences != null) {
        selectedGoal =
        preferences['goal'] as String?;

        selectedActivity =
        preferences['activityLevel']
        as String?;

        selectedNutrition =
        preferences['nutritionPreference']
        as String?;

        final rawDietaryRequirements =
        preferences['dietaryRequirements'];

        selectedDietaryRequirements =
        rawDietaryRequirements is List
            ? rawDietaryRequirements
            .map((item) => item.toString())
            .where(
              (item) =>
              dietaryRequirementOptions
                  .contains(item),
        )
            .toList()
            : <String>[];

        selectedWorkout =
        preferences['workoutPreference']
        as String?;

        weightUnit =
            (preferences['weightUnit'] ?? 'kg')
                .toString()
                .toLowerCase();

        final weightKg =
        (preferences['weight'] as num?)
            ?.toDouble();

        final targetWeightKg =
        (preferences['targetWeight'] as num?)
            ?.toDouble();

        weightController.text =
        weightKg == null
            ? ''
            : _formatWeight(
          WeightUnitConverter.kgToDisplay(
            kg: weightKg,
            unit: weightUnit,
          ),
        );

        targetWeightController.text =
        targetWeightKg == null
            ? ''
            : _formatWeight(
          WeightUnitConverter.kgToDisplay(
            kg: targetWeightKg,
            unit: weightUnit,
          ),
        );

        dailyCaloriesController.text =
            (nutritionPlan?['calorieGoal'] ??
                nutritionPlan?['dailyCalories'])
                ?.toString() ??
                '';
      }

      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isLoading = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.profileUpdateFailed,
      );
    }
  }

  String _goalLabel(String value) {
    switch (value) {
      case 'Lose Weight':
        return context.l10n.goalLoseWeight;

      case 'Build Muscle':
        return context.l10n.goalBuildMuscle;

      case 'Maintain Fitness':
        return context.l10n.goalMaintainFitness;

      case 'Improve Health':
        return context.l10n.goalImproveHealth;

      default:
        return value;
    }
  }

  String _goalValueFromLabel(String label) {
    for (final value in goals) {
      if (_goalLabel(value) == label) {
        return value;
      }
    }

    return label;
  }

  String _activityLabel(String value) {
    switch (value) {
      case 'Sedentary':
        return context.l10n.activitySedentary;

      case 'Lightly Active':
        return context.l10n.activityLightlyActive;

      case 'Moderately Active':
        return context.l10n.activityModeratelyActive;

      case 'Very Active':
        return context.l10n.activityVeryActive;

      default:
        return value;
    }
  }

  String _activityValueFromLabel(String label) {
    for (final value in activities) {
      if (_activityLabel(value) == label) {
        return value;
      }
    }

    return label;
  }

  String _nutritionLabel(String value) {
    switch (value) {
      case 'No Restrictions':
        return context.l10n.nutritionNoRestrictions;

      case 'High Protein':
        return context.l10n.nutritionHighProtein;

      case 'Vegetarian':
        return context.l10n.nutritionVegetarian;

      case 'Vegan':
        return context.l10n.nutritionVegan;

      case 'Balanced Diet':
        return context.l10n.nutritionBalancedDiet;

      case 'Mediterranean':
        return context.l10n.nutritionMediterranean;

      default:
        return value;
    }
  }

  String _nutritionValueFromLabel(String label) {
    for (final value in nutritionOptions) {
      if (_nutritionLabel(value) == label) {
        return value;
      }
    }

    return label;
  }

  String _dietaryRequirementLabel(
      String value,
      ) {
    switch (value) {
      case 'Vegetarian':
        return context.l10n.nutritionVegetarian;

      case 'Vegan':
        return context.l10n.nutritionVegan;

      case 'Pescatarian':
        return context.l10n.dietaryPescatarian;

      case 'Keto':
        return context.l10n.dietaryKeto;

      case 'Gluten Free':
        return context.l10n.dietaryGlutenFree;

      case 'Dairy Free':
        return context.l10n.dietaryDairyFree;

      default:
        return value;
    }
  }

  String _workoutLabel(String value) {
    switch (value) {
      case 'Home Workouts':
        return context.l10n.workoutHome;

      case 'Gym':
        return context.l10n.workoutGym;

      case 'Walking / Cardio':
        return context.l10n.workoutWalkingCardio;

      case 'Strength Training':
        return context.l10n.workoutStrengthTraining;

      default:
        return value;
    }
  }

  String _workoutValueFromLabel(String label) {
    for (final value in workoutOptions) {
      if (_workoutLabel(value) == label) {
        return value;
      }
    }

    return label;
  }

  Future<void> _savePreferences() async {
    setState(() {
      isSaving = true;
    });

    try {
      await _profileRepository.updateUserPreferences(
        {
          'goal': selectedGoal,
          'activityLevel': selectedActivity,
          'nutritionPreference':
          selectedNutrition,
          if (isPremium)
            'dietaryRequirements':
            selectedDietaryRequirements,
          'workoutPreference':
          selectedWorkout,

          'weight':
          weightController.text.trim().isEmpty
              ? null
              : double.tryParse(
            weightController.text.trim(),
          ) ==
              null
              ? null
              : double.parse(
            WeightUnitConverter.displayToKg(
              value: double.parse(
                weightController.text.trim(),
              ),
              unit: weightUnit,
            ).toStringAsFixed(1),
          ),

          'targetWeight':
          targetWeightController.text
              .trim()
              .isEmpty
              ? null
              : double.tryParse(
            targetWeightController.text
                .trim(),
          ) ==
              null
              ? null
              : double.parse(
            WeightUnitConverter.displayToKg(
              value: double.parse(
                targetWeightController.text
                    .trim(),
              ),
              unit: weightUnit,
            ).toStringAsFixed(1),
          ),

          'weightUnit': weightUnit,
        },
      );

      await _profileRepository.updateNutritionPlan(
        {
          'calorieGoal':
          dailyCaloriesController.text
              .trim()
              .isEmpty
              ? null
              : int.tryParse(
            dailyCaloriesController.text
                .trim(),
          ),
        },
      );

      if (!mounted) {
        return;
      }

      AppSnackbar.showSuccess(
        context,
        context.l10n.preferencesUpdated,
      );

      Navigator.pop(
        context,
        true,
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        isSaving = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.preferencesUpdateFailed,
      );
    }
  }

  @override
  void dispose() {
    weightController.dispose();
    targetWeightController.dispose();
    dailyCaloriesController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    final localizedGoals =
    goals.map(_goalLabel).toList();

    final localizedActivities =
    activities.map(_activityLabel).toList();

    final localizedNutrition =
    nutritionOptions.map(_nutritionLabel).toList();

    final dietaryRequirementsText =
    selectedDietaryRequirements.isEmpty
        ? context.l10n.noRestriction
        : selectedDietaryRequirements
        .map(_dietaryRequirementLabel)
        .join(', ');

    final localizedWorkouts =
    workoutOptions.map(_workoutLabel).toList();

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.homeBrown,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            context.l10n.goalsPreferences,
            style:
            AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
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
                  title: context.l10n.bodyGoals,
                  children: [
                    ProfileInput(
                      controller:
                      weightController,
                      hintText:
                      weightUnit == 'lb'
                          ? 'Current Weight (lb)'
                          : context.l10n
                          .currentWeightKg,
                      icon:
                      Icons.monitor_weight_outlined,
                      keyboardType:
                      const TextInputType
                          .numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .allow(
                          RegExp(
                            r'^\d*\.?\d{0,1}',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    ProfileInput(
                      controller:
                      targetWeightController,
                      hintText:
                      weightUnit == 'lb'
                          ? 'Target Weight (lb)'
                          : context.l10n
                          .targetWeightKg,
                      icon: Icons.track_changes,
                      keyboardType:
                      const TextInputType
                          .numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .allow(
                          RegExp(
                            r'^\d*\.?\d{0,1}',
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    ProfileInput(
                      controller:
                      dailyCaloriesController,
                      hintText:
                      context.l10n.dailyCalorieGoal,
                      icon: Icons
                          .local_fire_department_outlined,
                      keyboardType:
                      TextInputType.number,
                      inputFormatters: [
                        FilteringTextInputFormatter
                            .digitsOnly,
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 22),

                SettingsCard(
                  title:
                  context.l10n.preferencesTitle,
                  children: [
                    ProfileDropdownField(
                      value:
                      selectedGoal == null
                          ? null
                          : _goalLabel(
                        selectedGoal!,
                      ),
                      items: localizedGoals,
                      icon: Icons.flag_outlined,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedGoal =
                              _goalValueFromLabel(
                                value,
                              );
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    ProfileDropdownField(
                      value:
                      selectedActivity == null
                          ? null
                          : _activityLabel(
                        selectedActivity!,
                      ),
                      items:
                      localizedActivities,
                      icon: Icons
                          .directions_run_outlined,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedActivity =
                              _activityValueFromLabel(
                                value,
                              );
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    ProfileDropdownField(
                      value:
                      selectedNutrition == null
                          ? null
                          : _nutritionLabel(
                        selectedNutrition!,
                      ),
                      items:
                      localizedNutrition,
                      icon: Icons
                          .restaurant_menu_outlined,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedNutrition =
                              _nutritionValueFromLabel(
                                value,
                              );
                        });
                      },
                    ),

                    const SizedBox(height: 14),

                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: _showDietaryRequirementsDialog,
                        borderRadius: BorderRadius.circular(24),
                        child: Ink(
                          height: 52,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.restaurant_outlined,
                                color: AppColors.homeBrown,
                                size: 21,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  dietaryRequirementsText,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyMedium.copyWith(
                                    color: AppColors.homeSecondaryValue,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                isPremium
                                    ? Icons.keyboard_arrow_down
                                    : Icons.lock_outline_rounded,
                                color: AppColors.homeSecondaryValue,
                                size: isPremium ? 24 : 18,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 14),

                    ProfileDropdownField(
                      value:
                      selectedWorkout == null
                          ? null
                          : _workoutLabel(
                        selectedWorkout!,
                      ),
                      items:
                      localizedWorkouts,
                      icon: Icons
                          .fitness_center_outlined,
                      onChanged: (value) {
                        if (value == null) {
                          return;
                        }

                        setState(() {
                          selectedWorkout =
                              _workoutValueFromLabel(
                                value,
                              );
                        });
                      },
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                CustomButton(
                  text:
                  context.l10n.saveChanges,
                  onPressed:
                  isSaving || isLoading
                      ? null
                      : _savePreferences,
                  backgroundColor:
                  AppColors.authButtonGreen,
                  textColor: Colors.white,
                  height: 54,
                  width: screenWidth * 0.72,
                  fontSize: 17,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}