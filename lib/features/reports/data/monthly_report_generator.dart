import 'package:fiteo_myapp/features/reports/data/monthly_report_cache_builder.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_report_calculator.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_weight_plan_builder.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_aggregator.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';

class MonthlyReportGenerator {
  const MonthlyReportGenerator({
    ReportPeriodAggregator aggregator = const ReportPeriodAggregator(),
    MonthlyReportCalculator calculator = const MonthlyReportCalculator(),
    MonthlyReportCacheBuilder cacheBuilder =
    const MonthlyReportCacheBuilder(),
    MonthlyWeightPlanBuilder weightPlanBuilder =
    const MonthlyWeightPlanBuilder(),
  })  : _aggregator = aggregator,
        _calculator = calculator,
        _cacheBuilder = cacheBuilder,
        _weightPlanBuilder = weightPlanBuilder;

  final ReportPeriodAggregator _aggregator;
  final MonthlyReportCalculator _calculator;
  final MonthlyReportCacheBuilder _cacheBuilder;
  final MonthlyWeightPlanBuilder _weightPlanBuilder;

  MonthlyReportCache generate({
    required ReportPeriod period,
    required List<Map<String, dynamic>> summaries,
    required DateTime generatedAt,
    required DateTime availableFrom,

    required DateTime currentPlanActivatedAt,
    required double? currentExpectedWeeklyWeightChangeKg,

    required double? startWeightKg,
    required double? currentWeightKg,

    required String planStatus,
    required String? planStatusDescription,

    required MonthlyTargetAccumulator? accumulator,

    ReportComparisonBasis? previousComparisonBasis,
    int? previousScore,

    required List<String> reviewParagraphs,
    required MonthlyNextMonthCache nextMonth,
  }) {
    final stats = _aggregator.calculate(
      startDate: period.effectiveStart,
      endDate: period.effectiveEnd,
      summaries: summaries,
    );

    final calculation = _calculator.calculate(
      stats: stats,
      previous: previousComparisonBasis,
    );

    final weightPlan = _weightPlanBuilder.build(
      periodStart: period.calendarStart,
      periodEnd: period.calendarEnd,
      currentPlanActivatedAt: currentPlanActivatedAt,
      currentExpectedWeeklyWeightChangeKg:
      currentExpectedWeeklyWeightChangeKg,
      accumulator: _accumulatorForPeriod(
        accumulator,
        period.calendarStart,
      ),
      startWeightKg: startWeightKg,
      currentWeightKg: currentWeightKg,
      planStatus: planStatus,
      planStatusDescription: planStatusDescription,
    );

    return _cacheBuilder.build(
      stats: stats,
      calculation: calculation,
      generatedAt: generatedAt,
      availableFrom: availableFrom,
      weightPlan: weightPlan,
      reviewParagraphs: reviewParagraphs,
      nextMonth: nextMonth,
      previousScore: previousScore,
      calendarStart: period.calendarStart,
      calendarEnd: period.calendarEnd,
    );
  }

  MonthlyTargetAccumulator? _accumulatorForPeriod(
      MonthlyTargetAccumulator? accumulator,
      DateTime periodStart,
      ) {
    if (accumulator == null) {
      return null;
    }

    final expectedMonthKey =
        '${periodStart.year}-'
        '${periodStart.month.toString().padLeft(2, '0')}';

    if (accumulator.monthKey != expectedMonthKey) {
      return null;
    }

    return accumulator;
  }
}