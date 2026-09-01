import 'package:fiteo_myapp/features/profile/data/adherence_calculator.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';
import 'package:fiteo_myapp/features/profile/data/activity_calculator.dart';

class OverviewDayProcessor {
  const OverviewDayProcessor();

  static const AdherenceCalculator _adherenceCalculator =
  AdherenceCalculator();

  static const ActivityCalculator _activityCalculator =
  ActivityCalculator();

  void processDay({
    required OverviewStats stats,
    required String date,
    required Map<String, dynamic> data,
  }) {
    stats.trackingEligibleDays++;

    final netCalories =
        (data['netCalories'] as num?)?.toDouble() ?? 0;

    final protein =
        (data['protein'] as num?)?.toDouble() ?? 0;

    final carbs =
        (data['carbs'] as num?)?.toDouble() ?? 0;

    final fat =
        (data['fats'] as num?)?.toDouble() ?? 0;

    final hydrationMl =
        (data['hydrationMl'] as num?)?.toDouble() ?? 0;

    final workoutMinutes =
        (data['workoutMinutes'] as num?)?.round() ?? 0;

    final workoutCount =
        (data['workoutCount'] as num?)?.round() ?? 0;

    final calorieGoal =
    (data['calorieGoal'] as num?)?.toDouble();

    final proteinGoal =
    (data['proteinGoal'] as num?)?.toDouble();

    final carbsGoal =
    (data['carbsGoal'] as num?)?.toDouble();

    final fatGoal =
    (data['fatGoal'] as num?)?.toDouble();

    final waterGoalMl =
    (data['waterGoalMl'] as num?)?.toDouble();

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

    _updateTrackingStreak(
      stats: stats,
      isTracked: isTracked,
    );

    if (hasNutritionTracking) {
      _processNutrition(
        stats: stats,
        date: date,
        netCalories: netCalories,
        protein: protein,
        carbs: carbs,
        fat: fat,
        calorieGoal: calorieGoal,
        proteinGoal: proteinGoal,
        carbsGoal: carbsGoal,
        fatGoal: fatGoal,
      );
    }

    _processWater(
      stats: stats,
      hydrationMl: hydrationMl,
      waterGoalMl: waterGoalMl,
      hasWaterTracking: hasWaterTracking,
    );

    _processWorkout(
      stats: stats,
      date: date,
      workoutMinutes: workoutMinutes,
    );

    stats.lastProcessedDate = date;
  }

  void _updateTrackingStreak({
    required OverviewStats stats,
    required bool isTracked,
  }) {
    if (!isTracked) {
      stats.currentTrackingStreak = 0;
      return;
    }

    stats.trackedDays++;
    stats.currentTrackingStreak++;

    if (stats.currentTrackingStreak >
        stats.longestTrackingStreak) {
      stats.longestTrackingStreak =
          stats.currentTrackingStreak;
    }
  }

  void _processNutrition({
    required OverviewStats stats,
    required String date,
    required double netCalories,
    required double protein,
    required double carbs,
    required double fat,
    required double? calorieGoal,
    required double? proteinGoal,
    required double? carbsGoal,
    required double? fatGoal,
  }) {
    final adherenceValues = <double>[];

    double? calorieAdherence;
    double? proteinAdherence;
    double? carbsAdherence;
    double? fatAdherence;

    if (_validGoal(calorieGoal)) {
      calorieAdherence = _adherenceCalculator.targetCloseness(
        actual: netCalories,
        goal: calorieGoal!,
      );

      adherenceValues.add(calorieAdherence);

      stats.calorieAdherenceSum += calorieAdherence;
      stats.calorieAdherenceCount++;

      _processGoalCheck(
        reached: netCalories >= calorieGoal,
        onReached: () => stats.calorieGoalHitDays++,
        stats: stats,
      );
    }

    if (_validGoal(proteinGoal)) {
      proteinAdherence = _adherenceCalculator.targetCloseness(
        actual: protein,
        goal: proteinGoal!,
      );

      adherenceValues.add(proteinAdherence);

      _processGoalCheck(
        reached: protein >= proteinGoal,
        onReached: () => stats.proteinGoalHitDays++,
        stats: stats,
      );

      if (proteinAdherence > stats.bestProteinAdherence) {
        stats.bestProteinAdherence = proteinAdherence;
        stats.bestProteinValue = protein;
        stats.bestProteinDate = date;
      }
    }

    if (_validGoal(carbsGoal)) {
      carbsAdherence = _adherenceCalculator.targetCloseness(
        actual: carbs,
        goal: carbsGoal!,
      );

      adherenceValues.add(carbsAdherence);

      _processGoalCheck(
        reached: carbs >= carbsGoal,
        onReached: () => stats.carbsGoalHitDays++,
        stats: stats,
      );
    }

    if (_validGoal(fatGoal)) {
      fatAdherence = _adherenceCalculator.targetCloseness(
        actual: fat,
        goal: fatGoal!,
      );

      adherenceValues.add(fatAdherence);

      _processGoalCheck(
        reached: fat >= fatGoal,
        onReached: () => stats.fatGoalHitDays++,
        stats: stats,
      );
    }

    if (adherenceValues.isNotEmpty) {
      final dailyNutritionAdherence =
          adherenceValues.reduce((a, b) => a + b) /
              adherenceValues.length;

      stats.nutritionAdherenceSum +=
          dailyNutritionAdherence;

      stats.nutritionAdherenceCount++;
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
      stats.balancedDays++;
    }
  }

  void _processWater({
    required OverviewStats stats,
    required double hydrationMl,
    required double? waterGoalMl,
    required bool hasWaterTracking,
  }) {
    final canEvaluate =
        hasWaterTracking && _validGoal(waterGoalMl);

    if (!canEvaluate) {
      stats.currentHydrationStreak = 0;
      return;
    }

    final adherence =
    _adherenceCalculator.hydrationAdherence(
      hydrationMl: hydrationMl,
      waterGoalMl: waterGoalMl,
    );

    if (adherence == null) {
      stats.currentHydrationStreak = 0;
      return;
    }

    stats.waterAdherenceSum += adherence;
    stats.waterAdherenceCount++;

    final reached = hydrationMl >= waterGoalMl!;
    
    _processGoalCheck(
      reached: reached,
      onReached: () => stats.waterGoalHitDays++,
      stats: stats,
    );

    if (reached) {
      stats.currentHydrationStreak++;

      if (stats.currentHydrationStreak >
          stats.longestHydrationStreak) {
        stats.longestHydrationStreak =
            stats.currentHydrationStreak;
      }
    } else {
      stats.currentHydrationStreak = 0;
    }
  }

  void _processWorkout({
    required OverviewStats stats,
    required String date,
    required int workoutMinutes,
  }) {
    if (workoutMinutes <= 0) return;

    stats.totalWorkoutMinutes += workoutMinutes;

    if (_activityCalculator.isActiveDay(
      workoutMinutes: workoutMinutes,
    )) {
      stats.activeDays++;
    }

    final parsedDate = DateTime.parse(date);
    final weekday = _weekdayKey(parsedDate.weekday);

    stats.weekdayWorkoutMinutes[weekday] =
        (stats.weekdayWorkoutMinutes[weekday] ?? 0) +
            workoutMinutes;
  }

  void _processGoalCheck({
    required bool reached,
    required void Function() onReached,
    required OverviewStats stats,
  }) {
    stats.totalGoalChecks++;

    if (!reached) return;

    stats.successfulGoalChecks++;
    onReached();
  }

  bool _validGoal(double? value) {
    return value != null && value > 0;
  }

  String _weekdayKey(int weekday) {
    switch (weekday) {
      case DateTime.monday:
        return 'monday';
      case DateTime.tuesday:
        return 'tuesday';
      case DateTime.wednesday:
        return 'wednesday';
      case DateTime.thursday:
        return 'thursday';
      case DateTime.friday:
        return 'friday';
      case DateTime.saturday:
        return 'saturday';
      case DateTime.sunday:
        return 'sunday';
      default:
        return 'monday';
    }
  }
}