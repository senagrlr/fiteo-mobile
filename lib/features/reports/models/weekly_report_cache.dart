import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_calculation.dart';

class WeeklyReportCache {
  final int schemaVersion;

  final DateTime periodStart;
  final DateTime periodEnd;

  final DateTime generatedAt;
  final DateTime availableFrom;

  final bool isAvailable;
  final bool dismissed;
  final DateTime? dismissedAt;
  final DateTime? emailSentAt;

  final int score;
  final int? previousScore;
  final int? scoreChange;
  final ReportPerformanceLevel scoreLevel;

  final WeeklyOverviewCalculation overview;
  final WeeklyMetricsCalculation metrics;

  final WeeklyDayCalculation? bestDay;
  final WeeklyDayCalculation? worstDay;

  final WeeklyWeightPlanCache weightPlan;

  final List<String> reviewParagraphs;
  final WeeklyNextWeekCache nextWeek;

  final WeeklyComparisonBasis comparisonBasis;

  const WeeklyReportCache({
    required this.schemaVersion,
    required this.periodStart,
    required this.periodEnd,
    required this.generatedAt,
    required this.availableFrom,
    required this.isAvailable,
    required this.dismissed,
    required this.dismissedAt,
    required this.emailSentAt,
    required this.score,
    required this.previousScore,
    required this.scoreChange,
    required this.scoreLevel,
    required this.overview,
    required this.metrics,
    required this.bestDay,
    required this.worstDay,
    required this.weightPlan,
    required this.reviewParagraphs,
    required this.nextWeek,
    required this.comparisonBasis,
  });
}

class WeeklyWeightPlanCache {
  final double? startWeightKg;
  final double? currentWeightKg;

  final String planStatus;
  final String? planStatusDescription;

  const WeeklyWeightPlanCache({
    required this.startWeightKg,
    required this.currentWeightKg,
    required this.planStatus,
    required this.planStatusDescription,
  });
}

class WeeklyNextWeekCache {
  final String focusTitle;
  final String focusDescription;
  final List<String> tips;

  const WeeklyNextWeekCache({
    required this.focusTitle,
    required this.focusDescription,
    required this.tips,
  });
}

class WeeklyComparisonBasis {
  final double trackingConsistency;
  final double goalConsistency;

  final double calorieAdherence;
  final int calorieTargetDays;

  final double proteinAdherence;
  final int proteinTargetDays;

  final double carbsAdherence;
  final int carbsTargetDays;

  final double fatAdherence;
  final int fatTargetDays;

  final double hydrationAdherence;
  final int hydrationTargetDays;

  final double activityScore;
  final int activeDays;

  const WeeklyComparisonBasis({
    required this.trackingConsistency,
    required this.goalConsistency,
    required this.calorieAdherence,
    required this.calorieTargetDays,
    required this.proteinAdherence,
    required this.proteinTargetDays,
    required this.carbsAdherence,
    required this.carbsTargetDays,
    required this.fatAdherence,
    required this.fatTargetDays,
    required this.hydrationAdherence,
    required this.hydrationTargetDays,
    required this.activityScore,
    required this.activeDays,
  });
}