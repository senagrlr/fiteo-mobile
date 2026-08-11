import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/workout/data/workout_repository.dart';
import 'package:fiteo_myapp/features/workout/presentation/screens/workout_screen.dart';

class AddExerciseForm extends StatefulWidget {
  final ValueChanged<ExerciseItem> onAddExercise;

  const AddExerciseForm({
    super.key,
    required this.onAddExercise,
  });

  @override
  State<AddExerciseForm> createState() =>
      _AddExerciseFormState();
}

class _AddExerciseFormState extends State<AddExerciseForm> {
  final exerciseController = TextEditingController();
  final durationController = TextEditingController();

  String? selectedIntensity;
  String? matchedExerciseName;

  int estimatedCalories = 0;

  bool isEstimating = false;

  final WorkoutRepository _workoutRepository =
  WorkoutRepository();

  final List<String> intensities = const [
    'Low',
    'Medium',
    'High',
  ];

  String _localizedIntensity(
      BuildContext context,
      String intensity,
      ) {
    switch (intensity) {
      case 'Low':
        return context.l10n.intensityLow;

      case 'Medium':
        return context.l10n.intensityMedium;

      case 'High':
        return context.l10n.intensityHigh;

      default:
        return intensity;
    }
  }

  Future<void> _estimateCalories() async {
    final name = exerciseController.text.trim();

    final duration =
        int.tryParse(
          durationController.text.trim(),
        ) ??
            0;

    if (name.isEmpty ||
        duration == 0 ||
        selectedIntensity == null) {
      setState(() {
        estimatedCalories = 0;
        matchedExerciseName = null;
      });

      return;
    }

    setState(() {
      isEstimating = true;
    });

    try {
      final metData =
      await _workoutRepository.findExerciseMet(
        name,
      );

      if (metData == null) {
        if (!mounted) return;

        setState(() {
          estimatedCalories = 0;
          matchedExerciseName = null;
          isEstimating = false;
        });

        return;
      }

      final metValues = Map<String, dynamic>.from(
        metData['metValues'] ?? {},
      );

      final intensityKey =
      selectedIntensity!.toLowerCase();

      final met =
      (metValues[intensityKey] as num?)
          ?.toDouble();

      if (met == null) {
        if (!mounted) return;

        setState(() {
          estimatedCalories = 0;
          matchedExerciseName = null;
          isEstimating = false;
        });

        return;
      }

      final weightKg =
      await _workoutRepository.getUserWeightKg();

      final calories =
      _workoutRepository.calculateCaloriesBurned(
        met: met,
        weightKg: weightKg,
        durationMinutes: duration,
      );

      if (!mounted) return;

      setState(() {
        estimatedCalories = calories;
        matchedExerciseName =
        metData['name'] as String?;
        isEstimating = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        estimatedCalories = 0;
        matchedExerciseName = null;
        isEstimating = false;
      });
    }
  }

  void _addExercise() {
    final name = exerciseController.text.trim();

    final duration =
        int.tryParse(
          durationController.text.trim(),
        ) ??
            0;

    if (name.isEmpty ||
        duration == 0 ||
        selectedIntensity == null ||
        estimatedCalories == 0) {
      return;
    }

    widget.onAddExercise(
      ExerciseItem(
        name: matchedExerciseName ?? name,
        durationMinutes: duration,

        // Internal değer İngilizce kalıyor.
        intensity: selectedIntensity!,

        caloriesBurned: estimatedCalories,
      ),
    );

    exerciseController.clear();
    durationController.clear();

    setState(() {
      selectedIntensity = null;
      estimatedCalories = 0;
      matchedExerciseName = null;
    });
  }

  @override
  void dispose() {
    exerciseController.dispose();
    durationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: GestureDetector(
            onTap: _addExercise,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 22,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: AppColors.calendarCompleted,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Text(
                context.l10n.addExercise,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 18),

        _WorkoutInputField(
          controller: exerciseController,
          hintText: context.l10n.exerciseName,
          onChanged: (_) => _estimateCalories(),
        ),

        const SizedBox(height: 10),

        _WorkoutInputField(
          controller: durationController,
          hintText: context.l10n.durationMinutes,
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: (_) => _estimateCalories(),
        ),

        const SizedBox(height: 10),

        SizedBox(
          width: 230,
          height: 38,
          child: DropdownButtonFormField<String>(
            value: selectedIntensity,
            dropdownColor: AppColors.homeCardBackground,

            icon: const Icon(
              Icons.keyboard_arrow_down,
              color: AppColors.homeSecondaryValue,
            ),

            decoration: InputDecoration(
              labelText: context.l10n.intensity,
              floatingLabelBehavior:
              FloatingLabelBehavior.never,

              labelStyle:
              AppTextStyles.bodySmall.copyWith(
                color:
                AppColors.homeSecondaryValue,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),

              filled: true,
              fillColor:
              AppColors.homeCardBackground,

              contentPadding:
              const EdgeInsets.symmetric(
                horizontal: 18,
                vertical: 8,
              ),

              border: OutlineInputBorder(
                borderRadius:
                BorderRadius.circular(22),
                borderSide: BorderSide.none,
              ),
            ),

            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.homeBrown,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),

            items: intensities.map(
                  (intensity) {
                return DropdownMenuItem<String>(
                  value: intensity,
                  child: Text(
                    _localizedIntensity(
                      context,
                      intensity,
                    ),
                    style:
                    AppTextStyles.bodySmall.copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                );
              },
            ).toList(),

            onChanged: (value) {
              setState(() {
                selectedIntensity = value;
              });

              _estimateCalories();
            },
          ),
        ),

        const SizedBox(height: 18),

        Container(
          width: 160,
          height: 38,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.homeCardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            isEstimating
                ? context.l10n.calculating
                : estimatedCalories == 0
                ? context.l10n.caloriesBurned
                : '$estimatedCalories kcal',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.homeBrown,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 22),

        Text(
          context.l10n.metEstimateDisclaimer,
          textAlign: TextAlign.center,
          style: AppTextStyles.labelSmall.copyWith(
            color: AppColors.homeSecondaryValue,
            fontSize: 10,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
      ],
    );
  }
}

class _WorkoutInputField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  const _WorkoutInputField({
    required this.controller,
    required this.hintText,
    this.keyboardType,
    this.onChanged,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 230,
      height: 38,
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        onChanged: onChanged,
        inputFormatters: inputFormatters,

        // Kullanıcının girdiği değer.
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.homeBrown,
          fontSize: 13,
          fontWeight: FontWeight.w500,
        ),

        decoration: InputDecoration(
          hintText: hintText,

          hintStyle:
          AppTextStyles.bodySmall.copyWith(
            color: AppColors.homeSecondaryValue,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),

          filled: true,
          fillColor: AppColors.homeCardBackground,

          contentPadding:
          const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 8,
          ),

          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(22),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}