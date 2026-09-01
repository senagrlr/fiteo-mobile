import 'package:fiteo_myapp/features/reports/models/report_daily_result.dart';
import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';
import 'package:fiteo_myapp/features/reports/models/report_period_stats.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_calculation.dart';

class WeeklyReportCalculator {
  const WeeklyReportCalculator();

  static const ReportPerformanceLevelCalculator _levelCalculator =
  ReportPerformanceLevelCalculator();

  WeeklyReportCalculation calculate({
    required ReportPeriodStats stats,
  }) {
    final bestDay = _findBestDay(stats.dailyResults);
    final worstDay = _findWorstDay(stats.dailyResults);

    return WeeklyReportCalculation(
      score: stats.fiteoScore,
      scoreLevel: _levelCalculator.fromScore(stats.fiteoScore.toDouble()),
      overview: WeeklyOverviewCalculation(
        calories: _levelCalculator.fromScore(stats.calorieAdherence),
        protein: _levelCalculator.fromScore(stats.proteinAdherence),
        carbs: _levelCalculator.fromScore(stats.carbsAdherence),
        fat: _levelCalculator.fromScore(stats.fatAdherence),
        hydration: _levelCalculator.fromScore(stats.waterAdherence),
        activity: _levelCalculator.fromScore(stats.workoutActivityScore),
      ),
      metrics: WeeklyMetricsCalculation(
        caloriesAverage: stats.calorieAverage,
        calorieTargetDays: stats.calorieTargetDays,
        calorieEvaluatedDays: stats.calorieEvaluatedDays,
        activeDays: stats.activeDays,
        totalWorkoutMinutes: stats.totalWorkoutMinutes,
        proteinAverage: stats.proteinAverage,
        proteinTargetDays: stats.proteinTargetDays,
        proteinEvaluatedDays: stats.proteinEvaluatedDays,
      ),
      bestDay: bestDay == null ? null : _mapDay(bestDay),
      worstDay: worstDay == null ? null : _mapDay(worstDay),
    );
  }

  ReportDailyResult? _findBestDay(List<ReportDailyResult> days) {
    final comparableDays = days
        .where(
          (day) => day.isComparable && day.dailyAlignment != null,
    )
        .toList();

    if (comparableDays.isEmpty) {
      return null;
    }

    comparableDays.sort(
          (a, b) => b.dailyAlignment!.compareTo(a.dailyAlignment!),
    );

    return comparableDays.first;
  }

  ReportDailyResult? _findWorstDay(List<ReportDailyResult> days) {
    final comparableDays = days
        .where(
          (day) => day.isComparable && day.dailyAlignment != null,
    )
        .toList();

    if (comparableDays.isEmpty) {
      return null;
    }

    comparableDays.sort(
          (a, b) => a.dailyAlignment!.compareTo(b.dailyAlignment!),
    );

    return comparableDays.first;
  }

  WeeklyDayCalculation _mapDay(ReportDailyResult day) {
    return WeeklyDayCalculation(
      date: day.date,
      alignmentPercent: day.dailyAlignment!.round().clamp(0, 100),
      caloriesAligned: _isAligned(day.calorieAdherence),
      activityAligned: _activityAligned(day),
      waterAligned: _isAligned(day.waterAdherence),
      proteinAligned: _isAligned(day.proteinAdherence),
    );
  }

  bool? _isAligned(double? adherence) {
    if (adherence == null) {
      return null;
    }

    return adherence >= 85;
  }

  bool? _activityAligned(ReportDailyResult day) {
    if (!day.hasWorkoutTracking) {
      return null;
    }

    return day.activityTargetHit;
  }
}