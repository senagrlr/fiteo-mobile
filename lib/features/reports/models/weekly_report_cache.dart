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

  final List<String> reviewParagraphs;
  final WeeklyNextWeekCache nextWeek;

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
    required this.reviewParagraphs,
    required this.nextWeek,
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