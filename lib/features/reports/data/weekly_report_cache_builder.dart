import 'package:fiteo_myapp/features/reports/models/report_period_stats.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';

class WeeklyReportCacheBuilder {
  const WeeklyReportCacheBuilder();

  WeeklyReportCache build({
    required ReportPeriodStats stats,
    required WeeklyReportCalculation calculation,
    required DateTime generatedAt,
    required DateTime availableFrom,
    required WeeklyWeightPlanCache weightPlan,
    required List<String> reviewParagraphs,
    required WeeklyNextWeekCache nextWeek,
    int? previousScore,
  }) {
    return WeeklyReportCache(
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
      overview: calculation.overview,
      metrics: calculation.metrics,
      bestDay: calculation.bestDay,
      worstDay: calculation.worstDay,
      weightPlan: weightPlan,
      reviewParagraphs: reviewParagraphs,
      nextWeek: nextWeek,
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