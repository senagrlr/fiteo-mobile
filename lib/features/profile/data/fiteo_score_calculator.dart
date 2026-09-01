import 'package:fiteo_myapp/features/profile/data/activity_calculator.dart';
import 'package:fiteo_myapp/features/profile/data/adherence_calculator.dart';

class FiteoScoreCalculator {
  const FiteoScoreCalculator();

  static const AdherenceCalculator _adherenceCalculator = AdherenceCalculator();
  static const ActivityCalculator _activityCalculator = ActivityCalculator();

  int calculate({
    required List<Map<String, dynamic>> days,
    int? effectiveDays,
  }) {
    if (days.isEmpty && (effectiveDays == null || effectiveDays <= 0)) {
      return 0;
    }

    var trackedDays = 0;

    var nutritionSum = 0.0;
    var nutritionCount = 0;

    var waterSum = 0.0;
    var waterCount = 0;

    var activeDays = 0;

    for (final data in days) {
      final netCalories = (data['netCalories'] as num?)?.toDouble() ?? 0;
      final protein = (data['protein'] as num?)?.toDouble() ?? 0;
      final carbs = (data['carbs'] as num?)?.toDouble() ?? 0;
      final fat =
          (data['fat'] as num?)?.toDouble() ??
              (data['fats'] as num?)?.toDouble() ??
              0;

      final hydration = (data['hydrationMl'] as num?)?.toDouble() ?? 0;
      final workoutMinutes = (data['workoutMinutes'] as num?)?.round() ?? 0;
      final workoutCount = (data['workoutCount'] as num?)?.round() ?? 0;

      final hasNutrition =
          netCalories != 0 ||
              protein > 0 ||
              carbs > 0 ||
              fat > 0;

      final hasWater = hydration > 0;
      final hasWorkout = workoutCount > 0 || workoutMinutes > 0;

      if (hasNutrition || hasWater || hasWorkout) {
        trackedDays++;
      }

      if (_activityCalculator.isActiveDay(workoutMinutes: workoutMinutes)) {
        activeDays++;
      }

      final nutritionAdherences = <double>[];

      final calorieGoal = (data['calorieGoal'] as num?)?.toDouble();
      final proteinGoal = (data['proteinGoal'] as num?)?.toDouble();
      final carbsGoal = (data['carbsGoal'] as num?)?.toDouble();
      final fatGoal = (data['fatGoal'] as num?)?.toDouble();

      if (hasNutrition) {
        if (_validGoal(calorieGoal)) {
          nutritionAdherences.add(
            _adherenceCalculator.targetCloseness(
              actual: netCalories,
              goal: calorieGoal!,
            ),
          );
        }

        if (_validGoal(proteinGoal)) {
          nutritionAdherences.add(
            _adherenceCalculator.targetCloseness(
              actual: protein,
              goal: proteinGoal!,
            ),
          );
        }

        if (_validGoal(carbsGoal)) {
          nutritionAdherences.add(
            _adherenceCalculator.targetCloseness(
              actual: carbs,
              goal: carbsGoal!,
            ),
          );
        }

        if (_validGoal(fatGoal)) {
          nutritionAdherences.add(
            _adherenceCalculator.targetCloseness(
              actual: fat,
              goal: fatGoal!,
            ),
          );
        }
      }

      if (nutritionAdherences.isNotEmpty) {
        nutritionSum +=
            nutritionAdherences.reduce((a, b) => a + b) /
                nutritionAdherences.length;

        nutritionCount++;
      }

      final waterGoal = (data['waterGoalMl'] as num?)?.toDouble();

      if (hasWater && _validGoal(waterGoal)) {
        final waterAdherence = _adherenceCalculator.hydrationAdherence(
          hydrationMl: hydration,
          waterGoalMl: waterGoal,
        );

        if (waterAdherence != null) {
          waterSum += waterAdherence;
          waterCount++;
        }
      }
    }

    final periodDays = effectiveDays ?? days.length;

    if (periodDays <= 0) {
      return 0;
    }

    final trackingConsistency = trackedDays / periodDays * 100;

    final nutritionAdherence =
    nutritionCount == 0 ? 0.0 : nutritionSum / nutritionCount;

    final hydrationAdherence =
    waterCount == 0 ? 0.0 : waterSum / waterCount;

    final workoutActivity = _activityCalculator.periodActivityScore(
      activeDays: activeDays,
      eligibleDays: periodDays,
    );

    return calculateFromComponents(
      nutritionAdherence: nutritionAdherence,
      trackingConsistency: trackingConsistency,
      workoutActivity: workoutActivity,
      hydrationAdherence: hydrationAdherence,
    );
  }

  int calculateFromComponents({
    required double nutritionAdherence,
    required double trackingConsistency,
    required double workoutActivity,
    required double hydrationAdherence,
  }) {
    final score =
        nutritionAdherence * 0.40 +
            trackingConsistency * 0.25 +
            workoutActivity * 0.20 +
            hydrationAdherence * 0.15;

    return score.round().clamp(0, 100);
  }

  bool _validGoal(double? value) {
    return value != null && value > 0;
  }
}