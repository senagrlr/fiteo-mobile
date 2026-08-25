import 'package:fiteo_myapp/features/reports/data/report_period_aggregator.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_cache_builder.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_calculator.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

class WeeklyReportGenerator {
  const WeeklyReportGenerator({
    ReportPeriodAggregator aggregator = const ReportPeriodAggregator(),
    WeeklyReportCalculator calculator = const WeeklyReportCalculator(),
    WeeklyReportCacheBuilder cacheBuilder = const WeeklyReportCacheBuilder(),
  })  : _aggregator = aggregator,
        _calculator = calculator,
        _cacheBuilder = cacheBuilder;

  final ReportPeriodAggregator _aggregator;
  final WeeklyReportCalculator _calculator;
  final WeeklyReportCacheBuilder _cacheBuilder;

  WeeklyReportCache generate({
    required List<Map<String, dynamic>> days,
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime generatedAt,
    required DateTime availableFrom,
    required WeeklyWeightPlanCache weightPlan,
    required List<String> reviewParagraphs,
    required WeeklyNextWeekCache nextWeek,
    int? previousScore,
  }) {
    final stats = _aggregator.calculate(
      startDate: periodStart,
      endDate: periodEnd,
      summaries: days,
    );

    final calculation = _calculator.calculate(
      stats: stats,
    );

    return _cacheBuilder.build(
      stats: stats,
      calculation: calculation,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      weightPlan: weightPlan,
      reviewParagraphs: reviewParagraphs,
      nextWeek: nextWeek,
      previousScore: previousScore,
    );
  }
}