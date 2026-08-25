import 'package:fiteo_myapp/features/reports/models/monthly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';
import 'package:fiteo_myapp/features/reports/models/report_daily_result.dart';
import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';
import 'package:fiteo_myapp/features/reports/models/report_period_stats.dart';

class MonthlyReportCalculator {
  const MonthlyReportCalculator();

  static const ReportPerformanceLevelCalculator _levelCalculator =
  ReportPerformanceLevelCalculator();

  static const double weekendGapThreshold = 15;
  static const double weakWeekendThreshold = 75;

  MonthlyReportCalculation calculate({
    required ReportPeriodStats stats,
    ReportComparisonBasis? previous,
  }) {
    return MonthlyReportCalculation(
      score: stats.fiteoScore,
      scoreLevel: _levelCalculator.fromScore(stats.fiteoScore.toDouble()),
      metrics: MonthlyMetricsCalculation(
        caloriesAverage: stats.calorieAverage,
        calorieTargetDays: stats.calorieTargetDays,
        calorieEvaluatedDays: stats.calorieEvaluatedDays,
        activeDays: stats.activeDays,
        totalWorkoutMinutes: stats.totalWorkoutMinutes,
        proteinAverage: stats.proteinAverage,
        proteinTargetDays: stats.proteinTargetDays,
        proteinEvaluatedDays: stats.proteinEvaluatedDays,
      ),
      consistency: MonthlyConsistencyCalculation(
        trackingConsistency: stats.trackingConsistency,
        trackedDays: stats.trackedDays,
        eligibleDays: stats.eligibleDays,
        goalConsistency: stats.goalConsistency,
        longestTrackingStreak: stats.longestTrackingStreak,
        perfectDays: stats.balancedDays,
      ),
      strongestArea: _findStrongestArea(stats),
      weakestArea: _findWeakestArea(stats),
      changes: _calculateChanges(
        stats: stats,
        previous: previous,
      ),
    );
  }

  MonthlyAreaCalculation? _findStrongestArea(ReportPeriodStats stats) {
    final candidates = _coreAreaCandidates(stats);

    if (candidates.isEmpty) {
      return null;
    }

    candidates.sort((a, b) => b.score.compareTo(a.score));
    return candidates.first;
  }

  MonthlyAreaCalculation? _findWeakestArea(ReportPeriodStats stats) {
    final candidates = _coreAreaCandidates(stats);

    if (candidates.isEmpty) {
      return null;
    }

    candidates.sort((a, b) => a.score.compareTo(b.score));
    final weakestCore = candidates.first;

    final weekendPattern = _weekendPattern(stats.dailyResults);

    if (weekendPattern != null) {
      return weekendPattern;
    }

    return weakestCore;
  }

  List<MonthlyAreaCalculation> _coreAreaCandidates(ReportPeriodStats stats) {
    final candidates = <MonthlyAreaCalculation>[];

    if (stats.calorieEvaluatedDays > 0) {
      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.calories,
          score: stats.calorieAdherence,
          targetDays: stats.calorieTargetDays,
          evaluatedDays: stats.calorieEvaluatedDays,
        ),
      );
    }

    if (stats.proteinEvaluatedDays > 0) {
      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.protein,
          score: stats.proteinAdherence,
          targetDays: stats.proteinTargetDays,
          evaluatedDays: stats.proteinEvaluatedDays,
        ),
      );
    }

    if (stats.carbsEvaluatedDays > 0) {
      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.carbs,
          score: stats.carbsAdherence,
          targetDays: stats.carbsTargetDays,
          evaluatedDays: stats.carbsEvaluatedDays,
        ),
      );
    }

    if (stats.fatEvaluatedDays > 0) {
      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.fat,
          score: stats.fatAdherence,
          targetDays: stats.fatTargetDays,
          evaluatedDays: stats.fatEvaluatedDays,
        ),
      );
    }

    if (stats.waterEvaluatedDays > 0) {
      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.hydration,
          score: stats.waterAdherence,
          targetDays: stats.waterTargetDays,
          evaluatedDays: stats.waterEvaluatedDays,
        ),
      );
    }

    if (stats.eligibleDays > 0) {
      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.activity,
          score: stats.workoutActivityScore,
          targetDays: stats.activeDays,
          evaluatedDays: stats.eligibleDays,
        ),
      );

      candidates.add(
        MonthlyAreaCalculation(
          type: MonthlyAreaType.tracking,
          score: stats.trackingConsistency,
          targetDays: stats.trackedDays,
          evaluatedDays: stats.eligibleDays,
        ),
      );
    }

    return candidates;
  }

  MonthlyAreaCalculation? _weekendPattern(List<ReportDailyResult> days) {
    final weekdayValues = <double>[];
    final weekendValues = <double>[];

    for (final day in days) {
      if (!day.isComparable || day.dailyAlignment == null) {
        continue;
      }

      final isWeekend =
          day.date.weekday == DateTime.saturday ||
              day.date.weekday == DateTime.sunday;

      if (isWeekend) {
        weekendValues.add(day.dailyAlignment!);
      } else {
        weekdayValues.add(day.dailyAlignment!);
      }
    }

    if (weekdayValues.length < 3 || weekendValues.length < 2) {
      return null;
    }

    final weekdayAverage = _averageList(weekdayValues);
    final weekendAverage = _averageList(weekendValues);
    final difference = weekdayAverage - weekendAverage;

    final isMeaningfulWeakness =
        difference >= weekendGapThreshold &&
            weekendAverage < weakWeekendThreshold;

    if (!isMeaningfulWeakness) {
      return null;
    }

    return MonthlyAreaCalculation(
      type: MonthlyAreaType.weekends,
      score: weekendAverage,
      weekdayAverage: weekdayAverage,
      weekendAverage: weekendAverage,
      weekendDifference: difference,
    );
  }

  List<MonthlyChangeCalculation> _calculateChanges({
    required ReportPeriodStats stats,
    required ReportComparisonBasis? previous,
  }) {
    if (previous == null) {
      return const [];
    }

    return [
      _change(
        type: MonthlyChangeType.trackingConsistency,
        difference: stats.trackingConsistency - previous.trackingConsistency,
      ),
      _change(
        type: MonthlyChangeType.goalConsistency,
        difference: stats.goalConsistency - previous.goalConsistency,
      ),
      _change(
        type: MonthlyChangeType.calorieTargetDays,
        difference: (stats.calorieTargetDays - previous.calorieTargetDays).toDouble(),
      ),
      _change(
        type: MonthlyChangeType.proteinTargetDays,
        difference: (stats.proteinTargetDays - previous.proteinTargetDays).toDouble(),
      ),
      _change(
        type: MonthlyChangeType.hydrationTargetDays,
        difference: (stats.waterTargetDays - previous.hydrationTargetDays).toDouble(),
      ),
      _change(
        type: MonthlyChangeType.activeDays,
        difference: (stats.activeDays - previous.activeDays).toDouble(),
      ),
    ];
  }

  MonthlyChangeCalculation _change({
    required MonthlyChangeType type,
    required double difference,
  }) {
    final direction = difference > 0
        ? MonthlyCalculationChangeDirection.up
        : difference < 0
        ? MonthlyCalculationChangeDirection.down
        : MonthlyCalculationChangeDirection.same;

    return MonthlyChangeCalculation(
      type: type,
      difference: difference,
      direction: direction,
    );
  }

  double _averageList(List<double> values) {
    if (values.isEmpty) {
      return 0;
    }

    return values.reduce((a, b) => a + b) / values.length;
  }
}