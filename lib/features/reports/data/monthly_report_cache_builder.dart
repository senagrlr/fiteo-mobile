import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/report_period_stats.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';

class MonthlyReportCacheBuilder {
  const MonthlyReportCacheBuilder();

  MonthlyReportCache build({
    required ReportPeriodStats stats,
    required MonthlyReportCalculation calculation,
    required DateTime generatedAt,
    required DateTime availableFrom,
    required MonthlyWeightPlanCache weightPlan,
    required List<String> reviewParagraphs,
    required List<MonthlyPatternCache> patterns,
    required MonthlyNextMonthCache nextMonth,
    required DateTime calendarStart,
    required DateTime calendarEnd,
    int? previousScore,
  }) {
    return MonthlyReportCache(
      schemaVersion: 1,
      periodStart: calendarStart,
      periodEnd: calendarEnd,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      isAvailable: false,
      dismissed: false,
      dismissedAt: null,
      emailSentAt: null,
      score: calculation.score,
      previousScore: previousScore,
      scoreChange: previousScore == null
          ? null
          : calculation.score - previousScore,
      scoreLevel: calculation.scoreLevel,
      metrics: calculation.metrics,
      consistency: calculation.consistency,
      strongestArea: calculation.strongestArea,
      weakestArea: calculation.weakestArea,
      changes: calculation.changes,
      weightPlan: weightPlan,
      reviewParagraphs: reviewParagraphs,
      patterns: patterns,
      nextMonth: nextMonth,
      comparisonBasis: ReportComparisonBasis(
        trackingConsistency: stats.trackingConsistency,
        goalConsistency: stats.goalConsistency,
        calorieTargetDays: stats.calorieTargetDays,
        proteinTargetDays: stats.proteinTargetDays,
        hydrationTargetDays: stats.waterTargetDays,
        activeDays: stats.activeDays,
      ),
    );
  }
}