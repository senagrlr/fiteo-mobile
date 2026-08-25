import 'package:fiteo_myapp/features/reports/data/monthly_report_cache_builder.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_report_calculator.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_target_accumulator_repository.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_weight_plan_builder.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_aggregator.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';

class MonthlyReportGenerator {
  const MonthlyReportGenerator();

  static const ReportPeriodAggregator _aggregator =
  ReportPeriodAggregator();

  static const MonthlyReportCalculator _calculator =
  MonthlyReportCalculator();

  static const MonthlyReportCacheBuilder _cacheBuilder =
  MonthlyReportCacheBuilder();

  static const MonthlyWeightPlanBuilder _weightPlanBuilder =
  MonthlyWeightPlanBuilder();

  Future<MonthlyReportCache> generate({
    required DateTime periodStart,
    required DateTime periodEnd,
    required List<Map<String, dynamic>> summaries,
    required DateTime generatedAt,
    required DateTime availableFrom,

    required DateTime currentPlanActivatedAt,
    required double? currentExpectedWeeklyWeightChangeKg,

    required double? startWeightKg,
    required double? currentWeightKg,

    required String planStatus,
    required String? planStatusDescription,

    ReportComparisonBasis? previousComparisonBasis,
    int? previousScore,

    required List<String> reviewParagraphs,
    required List<MonthlyPatternCache> patterns,
    required MonthlyNextMonthCache nextMonth,
  }) async {
    final stats = _aggregator.calculate(
      startDate: periodStart,
      endDate: periodEnd,
      summaries: summaries,
    );

    final calculation = _calculator.calculate(
      stats: stats,
      previous: previousComparisonBasis,
    );

    final accumulator =
    await MonthlyTargetAccumulatorRepository().loadCurrentMonth();

    final weightPlan = _weightPlanBuilder.build(
      periodStart: periodStart,
      periodEnd: periodEnd,
      currentPlanActivatedAt: currentPlanActivatedAt,
      currentExpectedWeeklyWeightChangeKg:
      currentExpectedWeeklyWeightChangeKg,
      accumulator: _accumulatorForPeriod(
        accumulator,
        periodStart,
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
      patterns: patterns,
      nextMonth: nextMonth,
      previousScore: previousScore,
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