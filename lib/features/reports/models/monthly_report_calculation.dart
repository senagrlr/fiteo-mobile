import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';

enum MonthlyAreaType {
  calories,
  protein,
  carbs,
  fat,
  hydration,
  activity,
  tracking,
  weekends,
}

enum MonthlyChangeType {
  trackingConsistency,
  goalConsistency,
  calorieTargetDays,
  proteinTargetDays,
  hydrationTargetDays,
  activeDays,
}

enum MonthlyCalculationChangeDirection {
  up,
  down,
  same,
}

class MonthlyReportCalculation {
  final int score;
  final ReportPerformanceLevel scoreLevel;

  final MonthlyMetricsCalculation metrics;
  final MonthlyConsistencyCalculation consistency;

  final MonthlyAreaCalculation? strongestArea;
  final MonthlyAreaCalculation? weakestArea;

  final List<MonthlyChangeCalculation> changes;

  const MonthlyReportCalculation({
    required this.score,
    required this.scoreLevel,
    required this.metrics,
    required this.consistency,
    required this.strongestArea,
    required this.weakestArea,
    required this.changes,
  });
}

class MonthlyMetricsCalculation {
  final double caloriesAverage;
  final int calorieTargetDays;
  final int calorieEvaluatedDays;

  final int activeDays;
  final int totalWorkoutMinutes;

  final double proteinAverage;
  final int proteinTargetDays;
  final int proteinEvaluatedDays;

  const MonthlyMetricsCalculation({
    required this.caloriesAverage,
    required this.calorieTargetDays,
    required this.calorieEvaluatedDays,
    required this.activeDays,
    required this.totalWorkoutMinutes,
    required this.proteinAverage,
    required this.proteinTargetDays,
    required this.proteinEvaluatedDays,
  });
}

class MonthlyConsistencyCalculation {
  final double trackingConsistency;
  final int trackedDays;
  final int eligibleDays;

  final double goalConsistency;
  final int longestTrackingStreak;
  final int perfectDays;

  const MonthlyConsistencyCalculation({
    required this.trackingConsistency,
    required this.trackedDays,
    required this.eligibleDays,
    required this.goalConsistency,
    required this.longestTrackingStreak,
    required this.perfectDays,
  });
}

class MonthlyAreaCalculation {
  final MonthlyAreaType type;
  final double score;

  final int? targetDays;
  final int? evaluatedDays;

  final double? weekdayAverage;
  final double? weekendAverage;
  final double? weekendDifference;

  const MonthlyAreaCalculation({
    required this.type,
    required this.score,
    this.targetDays,
    this.evaluatedDays,
    this.weekdayAverage,
    this.weekendAverage,
    this.weekendDifference,
  });
}

class MonthlyChangeCalculation {
  final MonthlyChangeType type;
  final double difference;
  final MonthlyCalculationChangeDirection direction;

  const MonthlyChangeCalculation({
    required this.type,
    required this.difference,
    required this.direction,
  });
}