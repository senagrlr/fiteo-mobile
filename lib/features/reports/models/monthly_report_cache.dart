import 'package:fiteo_myapp/features/reports/models/monthly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';

class MonthlyReportCache {
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

  final MonthlyMetricsCalculation metrics;
  final MonthlyConsistencyCalculation consistency;

  final MonthlyAreaCalculation? strongestArea;
  final MonthlyAreaCalculation? weakestArea;

  final List<MonthlyChangeCalculation> changes;

  final MonthlyWeightPlanCache weightPlan;

  final List<String> reviewParagraphs;
  final List<MonthlyPatternCache> patterns;
  final MonthlyNextMonthCache nextMonth;

  final MonthlyComparisonBasis comparisonBasis;

  const MonthlyReportCache({
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
    required this.metrics,
    required this.consistency,
    required this.strongestArea,
    required this.weakestArea,
    required this.changes,
    required this.weightPlan,
    required this.reviewParagraphs,
    required this.patterns,
    required this.nextMonth,
    required this.comparisonBasis,
  });
}

class MonthlyWeightPlanCache {
  final double? startWeightKg;
  final double? currentWeightKg;

  final double? monthlyTargetChangeKg;
  final int? progressAchievedPercent;

  final String planStatus;
  final String? planStatusDescription;

  const MonthlyWeightPlanCache({
    required this.startWeightKg,
    required this.currentWeightKg,
    required this.monthlyTargetChangeKg,
    required this.progressAchievedPercent,
    required this.planStatus,
    required this.planStatusDescription,
  });
}

class MonthlyPatternCache {
  final String title;
  final String description;

  const MonthlyPatternCache({
    required this.title,
    required this.description,
  });
}

class MonthlyNextMonthCache {
  final String title;
  final String mainFocus;
  final String keepDoing;
  final String improve;
  final String watch;

  const MonthlyNextMonthCache({
    required this.title,
    required this.mainFocus,
    required this.keepDoing,
    required this.improve,
    required this.watch,
  });
}

class MonthlyComparisonBasis {
  final int score;

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

  const MonthlyComparisonBasis({
    required this.score,
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