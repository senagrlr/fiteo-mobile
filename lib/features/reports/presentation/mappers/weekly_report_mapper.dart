import 'package:flutter/material.dart';

import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_data.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_calculation.dart';

class WeeklyReportMapper {
  const WeeklyReportMapper();

  WeeklyReportData toPresentation({
    required BuildContext context,
    required WeeklyReportCache cache,
  }) {
    return WeeklyReportData(
      dateRange: _dateRange(context, cache.periodStart, cache.periodEnd),
      score: cache.score,
      scoreChange: cache.scoreChange ?? 0,
      scoreLabel: _weeklyScoreLabel(context, cache.scoreLevel),
      overview: WeeklyOverviewData(
        caloriesStatus: _statusLabel(context, cache.overview.calories),
        proteinStatus: _statusLabel(context, cache.overview.protein),
        carbsStatus: _statusLabel(context, cache.overview.carbs),
        fatStatus: _statusLabel(context, cache.overview.fat),
        hydrationStatus: _statusLabel(context, cache.overview.hydration),
        activityStatus: _statusLabel(context, cache.overview.activity),
      ),
      metrics: WeeklyMetricsData(
        caloriesAverage: '${cache.metrics.caloriesAverage.round()} kcal',
        caloriesTargetDays: context.l10n.reportTargetDays(
          cache.metrics.calorieTargetDays,
          cache.metrics.calorieEvaluatedDays,
        ),
        activeDays: cache.metrics.activeDays.toString(),
        workoutTime: context.l10n.reportWorkoutTime(
          cache.metrics.totalWorkoutMinutes,
        ),
        proteinAverage: '${_formatNumber(cache.metrics.proteinAverage)} g',
        proteinTargetDays: context.l10n.reportTargetDays(
          cache.metrics.proteinTargetDays,
          cache.metrics.proteinEvaluatedDays,
        ),
      ),
      bestDay: _day(context, cache.bestDay),
      worstDay: _day(context, cache.worstDay),
      weightPlan: WeeklyWeightPlanData(
        startWeight: cache.weightPlan.startWeightKg,
        currentWeight: cache.weightPlan.currentWeightKg,
        statusLabel: cache.weightPlan.planStatus,
        statusDescription: cache.weightPlan.planStatusDescription,
      ),
      reviewParagraphs: cache.reviewParagraphs,
      nextWeek: WeeklyNextWeekData(
        focusTitle: cache.nextWeek.focusTitle,
        focusDescription: cache.nextWeek.focusDescription,
        tips: cache.nextWeek.tips,
      ),
    );
  }

  WeeklyDayData _day(
      BuildContext context,
      WeeklyDayCalculation? day,
      ) {
    if (day == null) {
      return const WeeklyDayData(
        dayLabel: '-',
        caloriesAligned: null,
        activityAligned: null,
        waterAligned: null,
        proteinAligned: null,
        alignmentPercent: 0,
      );
    }

    return WeeklyDayData(
      dayLabel: MaterialLocalizations.of(context).formatFullDate(day.date),
      caloriesAligned: day.caloriesAligned,
      activityAligned: day.activityAligned,
      waterAligned: day.waterAligned,
      proteinAligned: day.proteinAligned,
      alignmentPercent: day.alignmentPercent,
    );
  }

  String _statusLabel(
      BuildContext context,
      ReportPerformanceLevel level,
      ) {
    switch (level) {
      case ReportPerformanceLevel.strong:
        return context.l10n.reportStatusStrong;
      case ReportPerformanceLevel.good:
        return context.l10n.reportStatusGood;
      case ReportPerformanceLevel.needsFocus:
        return context.l10n.reportStatusNeedsFocus;
      case ReportPerformanceLevel.needsImprovement:
        return context.l10n.reportStatusNeedsImprovement;
    }
  }

  String _weeklyScoreLabel(
      BuildContext context,
      ReportPerformanceLevel level,
      ) {
    switch (level) {
      case ReportPerformanceLevel.strong:
        return context.l10n.weeklyScoreStrong;
      case ReportPerformanceLevel.good:
        return context.l10n.weeklyScoreGood;
      case ReportPerformanceLevel.needsFocus:
        return context.l10n.weeklyScoreNeedsFocus;
      case ReportPerformanceLevel.needsImprovement:
        return context.l10n.weeklyScoreNeedsImprovement;
    }
  }

  String _dateRange(
      BuildContext context,
      DateTime start,
      DateTime end,
      ) {
    final localizations = MaterialLocalizations.of(context);

    return '${localizations.formatShortDate(start)} - '
        '${localizations.formatShortDate(end)}';
  }

  String _formatNumber(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }

    return value.toStringAsFixed(1);
  }
}