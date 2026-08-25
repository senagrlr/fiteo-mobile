import 'package:fiteo_myapp/features/reports/models/report_daily_result.dart';

class ReportPeriodStats {
  final DateTime startDate;
  final DateTime endDate;

  final int eligibleDays;
  final int trackedDays;

  final double trackingConsistency;
  final int longestTrackingStreak;

  final int nutritionTrackedDays;

  final double calorieAdherence;
  final int calorieEvaluatedDays;
  final double calorieAverage;
  final int calorieTargetDays;

  final double proteinAdherence;
  final int proteinEvaluatedDays;
  final double proteinAverage;
  final int proteinTargetDays;

  final double carbsAdherence;
  final int carbsEvaluatedDays;
  final double carbsAverage;
  final int carbsTargetDays;

  final double fatAdherence;
  final int fatEvaluatedDays;
  final double fatAverage;
  final int fatTargetDays;

  final double nutritionAdherence;

  final int balancedDays;

  final int waterTrackedDays;
  final double waterAdherence;
  final int waterEvaluatedDays;
  final int waterTargetDays;
  final int longestHydrationStreak;

  final int activeDays;
  final int totalWorkoutMinutes;
  final double workoutActivityScore;

  final int successfulGoalChecks;
  final int totalGoalChecks;
  final double goalConsistency;

  final int fiteoScore;

  final List<ReportDailyResult>
  dailyResults;

  const ReportPeriodStats({
    required this.startDate,
    required this.endDate,
    required this.eligibleDays,
    required this.trackedDays,
    required this.trackingConsistency,
    required this.longestTrackingStreak,
    required this.nutritionTrackedDays,
    required this.calorieAdherence,
    required this.calorieEvaluatedDays,
    required this.calorieAverage,
    required this.calorieTargetDays,
    required this.proteinAdherence,
    required this.proteinEvaluatedDays,
    required this.proteinAverage,
    required this.proteinTargetDays,
    required this.carbsAdherence,
    required this.carbsEvaluatedDays,
    required this.carbsAverage,
    required this.carbsTargetDays,
    required this.fatAdherence,
    required this.fatEvaluatedDays,
    required this.fatAverage,
    required this.fatTargetDays,
    required this.nutritionAdherence,
    required this.balancedDays,
    required this.waterTrackedDays,
    required this.waterAdherence,
    required this.waterEvaluatedDays,
    required this.waterTargetDays,
    required this.longestHydrationStreak,
    required this.activeDays,
    required this.totalWorkoutMinutes,
    required this.workoutActivityScore,
    required this.successfulGoalChecks,
    required this.totalGoalChecks,
    required this.goalConsistency,
    required this.fiteoScore,
    required this.dailyResults,
  });
}