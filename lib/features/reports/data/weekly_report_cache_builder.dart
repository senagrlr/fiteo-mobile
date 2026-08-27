import 'package:fiteo_myapp/features/reports/models/report_period_stats.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_calculation.dart';

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
    required DateTime calendarStart,
    required DateTime calendarEnd,
    int? previousScore,
  }) {
    return WeeklyReportCache(
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
      overview: calculation.overview,
      metrics: calculation.metrics,
      bestDay: calculation.bestDay,
      worstDay: calculation.worstDay,
      weightPlan: weightPlan,
      reviewParagraphs: reviewParagraphs,
      nextWeek: nextWeek,
    );
  }
}