import 'package:fiteo_myapp/features/profile/data/activity_calculator.dart';
import 'package:fiteo_myapp/features/profile/data/adherence_calculator.dart';
import 'package:fiteo_myapp/features/profile/data/fiteo_score_calculator.dart';
import 'package:fiteo_myapp/features/reports/models/report_daily_result.dart';
import 'package:fiteo_myapp/features/reports/models/report_period_stats.dart';

class ReportPeriodAggregator {
  const ReportPeriodAggregator();

  static const AdherenceCalculator _adherenceCalculator = AdherenceCalculator();
  static const ActivityCalculator _activityCalculator = ActivityCalculator();
  static const FiteoScoreCalculator _fiteoScoreCalculator = FiteoScoreCalculator();

  ReportPeriodStats calculate({
    required DateTime startDate,
    required DateTime endDate,
    required List<Map<String, dynamic>> summaries,
  }) {
    final normalizedStart = _dateOnly(startDate);
    final normalizedEnd = _dateOnly(endDate);

    if (normalizedEnd.isBefore(normalizedStart)) {
      throw ArgumentError('endDate cannot be before startDate');
    }

    final eligibleDays = normalizedEnd.difference(normalizedStart).inDays + 1;

    final summariesByDate = <String, Map<String, dynamic>>{};

    for (final summary in summaries) {
      final date = summary['date'] as String?;

      if (date != null) {
        summariesByDate[date] = summary;
      }
    }

    var trackedDays = 0;

    var currentTrackingStreak = 0;
    var longestTrackingStreak = 0;

    var nutritionTrackedDays = 0;

    var calorieAdherenceSum = 0.0;
    var calorieAdherenceCount = 0;
    var calorieTotal = 0.0;
    var calorieTargetDays = 0;

    var proteinAdherenceSum = 0.0;
    var proteinAdherenceCount = 0;
    var proteinTotal = 0.0;
    var proteinTargetDays = 0;

    var carbsAdherenceSum = 0.0;
    var carbsAdherenceCount = 0;
    var carbsTotal = 0.0;
    var carbsTargetDays = 0;

    var fatAdherenceSum = 0.0;
    var fatAdherenceCount = 0;
    var fatTotal = 0.0;
    var fatTargetDays = 0;

    var nutritionAdherenceSum = 0.0;
    var nutritionAdherenceCount = 0;

    var balancedDays = 0;

    var waterTrackedDays = 0;
    var waterAdherenceSum = 0.0;
    var waterAdherenceCount = 0;
    var waterTargetDays = 0;

    var currentHydrationStreak = 0;
    var longestHydrationStreak = 0;

    var activeDays = 0;
    var totalWorkoutMinutes = 0;

    var successfulGoalChecks = 0;
    var totalGoalChecks = 0;

    final dailyResults = <ReportDailyResult>[];

    var currentDate = normalizedStart;

    while (!currentDate.isAfter(normalizedEnd)) {
      final summary = summariesByDate[_dateKey(currentDate)];
      final data = summary ?? const <String, dynamic>{};

      final netCalories = (data['netCalories'] as num?)?.toDouble() ?? 0;
      final protein = (data['protein'] as num?)?.toDouble() ?? 0;
      final carbs = (data['carbs'] as num?)?.toDouble() ?? 0;
      final fat =
          (data['fat'] as num?)?.toDouble() ??
              (data['fats'] as num?)?.toDouble() ??
              0;

      final hydrationMl = (data['hydrationMl'] as num?)?.toDouble() ?? 0;
      final workoutMinutes = (data['workoutMinutes'] as num?)?.round() ?? 0;
      final workoutCount = (data['workoutCount'] as num?)?.round() ?? 0;

      final calorieGoal = (data['calorieGoal'] as num?)?.toDouble();
      final proteinGoal = (data['proteinGoal'] as num?)?.toDouble();
      final carbsGoal = (data['carbsGoal'] as num?)?.toDouble();
      final fatGoal = (data['fatGoal'] as num?)?.toDouble();
      final waterGoalMl = (data['waterGoalMl'] as num?)?.toDouble();

      final hasNutritionTracking =
          netCalories != 0 ||
              protein > 0 ||
              carbs > 0 ||
              fat > 0;

      final hasWaterTracking = hydrationMl > 0;
      final hasWorkoutTracking = workoutCount > 0 || workoutMinutes > 0;

      final isTracked =
          hasNutritionTracking ||
              hasWaterTracking ||
              hasWorkoutTracking;

      if (isTracked) {
        trackedDays++;
        currentTrackingStreak++;

        if (currentTrackingStreak > longestTrackingStreak) {
          longestTrackingStreak = currentTrackingStreak;
        }
      } else {
        currentTrackingStreak = 0;
      }

      double? calorieAdherence;
      double? proteinAdherence;
      double? carbsAdherence;
      double? fatAdherence;

      bool? calorieTargetHit;
      bool? proteinTargetHit;
      bool? carbsTargetHit;
      bool? fatTargetHit;

      if (hasNutritionTracking) {
        nutritionTrackedDays++;

        calorieTotal += netCalories;
        proteinTotal += protein;
        carbsTotal += carbs;
        fatTotal += fat;

        final dailyNutritionValues = <double>[];

        if (_validGoal(calorieGoal)) {
          calorieAdherence = _adherenceCalculator.targetCloseness(
            actual: netCalories,
            goal: calorieGoal!,
          );

          calorieAdherenceSum += calorieAdherence;
          calorieAdherenceCount++;

          calorieTargetHit = netCalories >= calorieGoal;
          totalGoalChecks++;

          if (calorieTargetHit) {
            calorieTargetDays++;
            successfulGoalChecks++;
          }

          dailyNutritionValues.add(calorieAdherence);
        }

        if (_validGoal(proteinGoal)) {
          proteinAdherence = _adherenceCalculator.targetCloseness(
            actual: protein,
            goal: proteinGoal!,
          );

          proteinAdherenceSum += proteinAdherence;
          proteinAdherenceCount++;

          proteinTargetHit = protein >= proteinGoal;
          totalGoalChecks++;

          if (proteinTargetHit) {
            proteinTargetDays++;
            successfulGoalChecks++;
          }

          dailyNutritionValues.add(proteinAdherence);
        }

        if (_validGoal(carbsGoal)) {
          carbsAdherence = _adherenceCalculator.targetCloseness(
            actual: carbs,
            goal: carbsGoal!,
          );

          carbsAdherenceSum += carbsAdherence;
          carbsAdherenceCount++;

          carbsTargetHit = carbs >= carbsGoal;
          totalGoalChecks++;

          if (carbsTargetHit) {
            carbsTargetDays++;
            successfulGoalChecks++;
          }

          dailyNutritionValues.add(carbsAdherence);
        }

        if (_validGoal(fatGoal)) {
          fatAdherence = _adherenceCalculator.targetCloseness(
            actual: fat,
            goal: fatGoal!,
          );

          fatAdherenceSum += fatAdherence;
          fatAdherenceCount++;

          fatTargetHit = fat >= fatGoal;
          totalGoalChecks++;

          if (fatTargetHit) {
            fatTargetDays++;
            successfulGoalChecks++;
          }

          dailyNutritionValues.add(fatAdherence);
        }

        if (dailyNutritionValues.isNotEmpty) {
          final dailyNutritionAdherence =
              dailyNutritionValues.reduce((a, b) => a + b) /
                  dailyNutritionValues.length;

          nutritionAdherenceSum += dailyNutritionAdherence;
          nutritionAdherenceCount++;
        }

        final isBalancedDay =
            calorieAdherence != null &&
                proteinAdherence != null &&
                carbsAdherence != null &&
                fatAdherence != null &&
                calorieAdherence >= 85 &&
                proteinAdherence >= 85 &&
                carbsAdherence >= 85 &&
                fatAdherence >= 85;

        if (isBalancedDay) {
          balancedDays++;
        }
      }

      double? waterAdherence;
      bool? waterTargetHit;

      if (hasWaterTracking && _validGoal(waterGoalMl)) {
        waterTrackedDays++;

        waterAdherence = _adherenceCalculator.hydrationAdherence(
          hydrationMl: hydrationMl,
          waterGoalMl: waterGoalMl,
        );

        if (waterAdherence != null) {
          waterAdherenceSum += waterAdherence;
          waterAdherenceCount++;
        }

        waterTargetHit = hydrationMl >= waterGoalMl!;
        totalGoalChecks++;

        if (waterTargetHit) {
          waterTargetDays++;
          successfulGoalChecks++;
          currentHydrationStreak++;

          if (currentHydrationStreak > longestHydrationStreak) {
            longestHydrationStreak = currentHydrationStreak;
          }
        } else {
          currentHydrationStreak = 0;
        }
      } else {
        currentHydrationStreak = 0;
      }

      final activityTargetHit =
      hasWorkoutTracking
          ? _activityCalculator.isActiveDay(workoutMinutes: workoutMinutes)
          : null;

      final activityScore =
      hasWorkoutTracking
          ? _activityCalculator.dailyActivityScore(
        workoutMinutes: workoutMinutes,
      )
          : null;

      if (workoutMinutes > 0) {
        totalWorkoutMinutes += workoutMinutes;
      }

      if (activityTargetHit == true) {
        activeDays++;
      }

      final trackedCategoryCount =
          (hasNutritionTracking ? 1 : 0) +
              (hasWaterTracking ? 1 : 0) +
              (hasWorkoutTracking ? 1 : 0);

      final isComparable =
          hasNutritionTracking || trackedCategoryCount >= 2;

      final alignmentValues = <double>[];

      if (calorieAdherence != null) {
        alignmentValues.add(calorieAdherence);
      }

      if (proteinAdherence != null) {
        alignmentValues.add(proteinAdherence);
      }

      if (waterAdherence != null) {
        alignmentValues.add(waterAdherence);
      }

      if (activityScore != null) {
        alignmentValues.add(activityScore);
      }

      final dailyAlignment =
      isComparable && alignmentValues.isNotEmpty
          ? alignmentValues.reduce((a, b) => a + b) /
          alignmentValues.length
          : null;

      dailyResults.add(
        ReportDailyResult(
          date: currentDate,
          hasNutritionTracking: hasNutritionTracking,
          hasWaterTracking: hasWaterTracking,
          hasWorkoutTracking: hasWorkoutTracking,
          isTracked: isTracked,
          isComparable: isComparable,
          calorieAdherence: calorieAdherence,
          proteinAdherence: proteinAdherence,
          carbsAdherence: carbsAdherence,
          fatAdherence: fatAdherence,
          waterAdherence: waterAdherence,
          activityScore: activityScore,
          calorieTargetHit: calorieTargetHit,
          proteinTargetHit: proteinTargetHit,
          carbsTargetHit: carbsTargetHit,
          fatTargetHit: fatTargetHit,
          waterTargetHit: waterTargetHit,
          activityTargetHit: activityTargetHit,
          dailyAlignment: dailyAlignment,
        ),
      );

      currentDate = currentDate.add(const Duration(days: 1));
    }

    final trackingConsistency =
    eligibleDays <= 0 ? 0.0 : trackedDays / eligibleDays * 100;

    final calorieAdherence =
    _average(calorieAdherenceSum, calorieAdherenceCount);

    final proteinAdherence =
    _average(proteinAdherenceSum, proteinAdherenceCount);

    final carbsAdherence =
    _average(carbsAdherenceSum, carbsAdherenceCount);

    final fatAdherence =
    _average(fatAdherenceSum, fatAdherenceCount);

    final nutritionAdherence =
    _average(nutritionAdherenceSum, nutritionAdherenceCount);

    final waterAdherence =
    _average(waterAdherenceSum, waterAdherenceCount);

    final workoutActivityScore = _activityCalculator.periodActivityScore(
      activeDays: activeDays,
      eligibleDays: eligibleDays,
    );

    final goalConsistency =
    totalGoalChecks <= 0
        ? 0.0
        : successfulGoalChecks / totalGoalChecks * 100;

    final fiteoScore = _fiteoScoreCalculator.calculateFromComponents(
      nutritionAdherence: nutritionAdherence,
      trackingConsistency: trackingConsistency,
      workoutActivity: workoutActivityScore,
      hydrationAdherence: waterAdherence,
    );

    return ReportPeriodStats(
      startDate: normalizedStart,
      endDate: normalizedEnd,
      eligibleDays: eligibleDays,
      trackedDays: trackedDays,
      trackingConsistency: trackingConsistency,
      longestTrackingStreak: longestTrackingStreak,
      nutritionTrackedDays: nutritionTrackedDays,
      calorieAdherence: calorieAdherence,
      calorieEvaluatedDays: calorieAdherenceCount,
      calorieAverage: _average(calorieTotal, nutritionTrackedDays),
      calorieTargetDays: calorieTargetDays,
      proteinAdherence: proteinAdherence,
      proteinEvaluatedDays: proteinAdherenceCount,
      proteinAverage: _average(proteinTotal, nutritionTrackedDays),
      proteinTargetDays: proteinTargetDays,
      carbsAdherence: carbsAdherence,
      carbsEvaluatedDays: carbsAdherenceCount,
      carbsAverage: _average(carbsTotal, nutritionTrackedDays),
      carbsTargetDays: carbsTargetDays,
      fatAdherence: fatAdherence,
      fatEvaluatedDays: fatAdherenceCount,
      fatAverage: _average(fatTotal, nutritionTrackedDays),
      fatTargetDays: fatTargetDays,
      nutritionAdherence: nutritionAdherence,
      balancedDays: balancedDays,
      waterTrackedDays: waterTrackedDays,
      waterAdherence: waterAdherence,
      waterEvaluatedDays: waterAdherenceCount,
      waterTargetDays: waterTargetDays,
      longestHydrationStreak: longestHydrationStreak,
      activeDays: activeDays,
      totalWorkoutMinutes: totalWorkoutMinutes,
      workoutActivityScore: workoutActivityScore,
      successfulGoalChecks: successfulGoalChecks,
      totalGoalChecks: totalGoalChecks,
      goalConsistency: goalConsistency,
      fiteoScore: fiteoScore,
      dailyResults: dailyResults,
    );
  }

  double _average(double sum, int count) {
    if (count <= 0) {
      return 0;
    }

    return sum / count;
  }

  bool _validGoal(double? value) {
    return value != null && value > 0;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }
}