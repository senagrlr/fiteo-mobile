import 'package:fiteo_myapp/features/reports/data/monthly_target_accumulator_calculator.dart';
import 'package:fiteo_myapp/features/reports/data/report_weight_calculator.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';

class MonthlyWeightPlanBuilder {
  const MonthlyWeightPlanBuilder();

  static const MonthlyTargetAccumulatorCalculator _targetCalculator =
  MonthlyTargetAccumulatorCalculator();

  static const ReportWeightCalculator _weightCalculator =
  ReportWeightCalculator();

  MonthlyWeightPlanCache build({
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime currentPlanActivatedAt,
    required double? currentExpectedWeeklyWeightChangeKg,
    required MonthlyTargetAccumulator? accumulator,
    required double? startWeightKg,
    required double? currentWeightKg,
    required String planStatus,
    required String? planStatusDescription,
  }) {
    final monthlyTargetChangeKg = _calculateMonthlyTarget(
      periodStart: periodStart,
      periodEnd: periodEnd,
      currentPlanActivatedAt: currentPlanActivatedAt,
      currentExpectedWeeklyWeightChangeKg:
      currentExpectedWeeklyWeightChangeKg,
      accumulator: accumulator,
    );

    final progressAchievedPercent =
    _weightCalculator.calculateProgressAchievedPercent(
      startWeightKg: startWeightKg,
      currentWeightKg: currentWeightKg,
      targetChangeKg: monthlyTargetChangeKg,
    );

    return MonthlyWeightPlanCache(
      startWeightKg: startWeightKg,
      currentWeightKg: currentWeightKg,
      monthlyTargetChangeKg: monthlyTargetChangeKg,
      progressAchievedPercent: progressAchievedPercent,
      planStatus: planStatus,
      planStatusDescription: planStatusDescription,
    );
  }

  double? _calculateMonthlyTarget({
    required DateTime periodStart,
    required DateTime periodEnd,
    required DateTime currentPlanActivatedAt,
    required double? currentExpectedWeeklyWeightChangeKg,
    required MonthlyTargetAccumulator? accumulator,
  }) {
    if (currentExpectedWeeklyWeightChangeKg == null) {
      return null;
    }

    final accruedExpectedChangeKg =
        accumulator?.accruedExpectedChangeKg ?? 0;

    return _targetCalculator.calculateFinalMonthlyTarget(
      accruedExpectedChangeKg: accruedExpectedChangeKg,
      currentExpectedWeeklyWeightChangeKg:
      currentExpectedWeeklyWeightChangeKg,
      currentPlanActivatedAt: currentPlanActivatedAt,
      periodStart: periodStart,
      periodEnd: periodEnd,
      accruedThrough: accumulator?.accruedThrough,
    );
  }
}
