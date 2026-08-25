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
    int? previousScore,
  }) {
    return MonthlyReportCache(
      schemaVersion: 1,
      periodStart: stats.startDate,
      periodEnd: stats.endDate,
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
        score: stats.fiteoScore,
        trackingConsistency: stats.trackingConsistency,
        goalConsistency: stats.goalConsistency,
        calorieAdherence: stats.calorieAdherence,
        calorieTargetDays: stats.calorieTargetDays,
        proteinAdherence: stats.proteinAdherence,
        proteinTargetDays: stats.proteinTargetDays,
        carbsAdherence: stats.carbsAdherence,
        carbsTargetDays: stats.carbsTargetDays,
        fatAdherence: stats.fatAdherence,
        fatTargetDays: stats.fatTargetDays,
        hydrationAdherence: stats.waterAdherence,
        hydrationTargetDays: stats.waterTargetDays,
        activityScore: stats.workoutActivityScore,
        activeDays: stats.activeDays,
      ),
    );
  }
}