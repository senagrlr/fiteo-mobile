import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';

class WeeklyReportCalculation {
  final int score;
  final ReportPerformanceLevel scoreLevel;

  final WeeklyOverviewCalculation overview;
  final WeeklyMetricsCalculation metrics;

  final WeeklyDayCalculation? bestDay;
  final WeeklyDayCalculation? worstDay;

  const WeeklyReportCalculation({
    required this.score,
    required this.scoreLevel,
    required this.overview,
    required this.metrics,
    required this.bestDay,
    required this.worstDay,
  });
}

class WeeklyOverviewCalculation {
  final ReportPerformanceLevel calories;
  final ReportPerformanceLevel protein;
  final ReportPerformanceLevel carbs;
  final ReportPerformanceLevel fat;
  final ReportPerformanceLevel hydration;
  final ReportPerformanceLevel activity;

  const WeeklyOverviewCalculation({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.hydration,
    required this.activity,
  });
}

class WeeklyMetricsCalculation {
  final double caloriesAverage;
  final int calorieTargetDays;
  final int calorieEvaluatedDays;

  final int activeDays;
  final int totalWorkoutMinutes;

  final double proteinAverage;
  final int proteinTargetDays;
  final int proteinEvaluatedDays;

  const WeeklyMetricsCalculation({
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

class WeeklyDayCalculation {
  final DateTime date;
  final int alignmentPercent;

  final bool? caloriesAligned;
  final bool? activityAligned;
  final bool? waterAligned;
  final bool? proteinAligned;

  const WeeklyDayCalculation({
    required this.date,
    required this.alignmentPercent,
    required this.caloriesAligned,
    required this.activityAligned,
    required this.waterAligned,
    required this.proteinAligned,
  });
}