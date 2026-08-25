import 'package:flutter/material.dart';

import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_calculation.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';
import 'package:fiteo_myapp/features/reports/models/report_performance_level.dart';

class MonthlyReportMapper {
  const MonthlyReportMapper();

  MonthlyReportData toPresentation({
    required BuildContext context,
    required MonthlyReportCache cache,
  }) {
    return MonthlyReportData(
      dateRange: _dateRange(context, cache.periodStart, cache.periodEnd),
      score: cache.score,
      scoreChange: cache.scoreChange ?? 0,
      scoreLabel: _monthlyScoreLabel(context, cache.scoreLevel),
      overview: MonthlyOverviewData(
        changes: cache.changes
            .map((change) => _change(context, change))
            .toList(),
      ),
      metrics: MonthlyMetricsData(
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
      strongestArea: _area(
        context,
        cache.strongestArea,
        isStrongest: true,
      ),
      weakestArea: _area(
        context,
        cache.weakestArea,
        isStrongest: false,
      ),
      consistency: MonthlyConsistencyData(
        trackingConsistency: cache.consistency.trackingConsistency.round(),
        trackedDays: cache.consistency.trackedDays,
        totalDays: cache.consistency.eligibleDays,
        goalConsistency: cache.consistency.goalConsistency.round(),
        goalConsistencyNote: context.l10n.reportGoalConsistencyPeriod,
        longestStreakDays: cache.consistency.longestTrackingStreak,
        perfectDays: cache.consistency.perfectDays,
      ),
      weightPlan: MonthlyWeightPlanData(
        startWeight: cache.weightPlan.startWeightKg,
        currentWeight: cache.weightPlan.currentWeightKg,
        monthlyTargetChange: cache.weightPlan.monthlyTargetChangeKg,
        progressAchievedPercent: cache.weightPlan.progressAchievedPercent,
        statusLabel: cache.weightPlan.planStatus,
        statusDescription: cache.weightPlan.planStatusDescription,
      ),
      patterns: cache.patterns
          .map(
            (pattern) => MonthlyPatternData(
          title: pattern.title,
          description: pattern.description,
        ),
      )
          .toList(),
      reviewParagraphs: cache.reviewParagraphs,
      plan: MonthlyPlanData(
        title: cache.nextMonth.title,
        mainFocus: cache.nextMonth.mainFocus,
        keepDoing: cache.nextMonth.keepDoing,
        improve: cache.nextMonth.improve,
        watch: cache.nextMonth.watch,
      ),
    );
  }

  MonthlyChangeItem _change(
      BuildContext context,
      MonthlyChangeCalculation change,
      ) {
    return MonthlyChangeItem(
      label: _changeLabel(context, change.type),
      value: _formatChangeValue(change),
      direction: _changeDirection(change.direction),
    );
  }

  MonthlyAreaData _area(
      BuildContext context,
      MonthlyAreaCalculation? area, {
        required bool isStrongest,
      }) {
    if (area == null) {
      return const MonthlyAreaData(
        title: '-',
        primaryText: '-',
        secondaryText: '',
        badgeText: '-',
      );
    }

    if (area.type == MonthlyAreaType.weekends) {
      return MonthlyAreaData(
        title: _areaLabel(context, area.type),
        primaryText: context.l10n.reportWeakAreaScore(
          area.weekendAverage?.round() ?? 0,
        ),
        secondaryText: context.l10n.reportWeekendDifference(
          area.weekendDifference?.round() ?? 0,
        ),
        badgeText: context.l10n.weakestArea,
      );
    }

    final targetText =
    area.targetDays != null && area.evaluatedDays != null
        ? context.l10n.reportStrongAreaTargetDays(
      area.targetDays!,
      area.evaluatedDays!,
    )
        : context.l10n.reportWeakAreaScore(area.score.round());

    return MonthlyAreaData(
      title: _areaLabel(context, area.type),
      primaryText: targetText,
      secondaryText: context.l10n.reportWeakAreaScore(area.score.round()),
      badgeText: isStrongest
          ? context.l10n.strongestArea
          : context.l10n.weakestArea,
    );
  }

  String _areaLabel(
      BuildContext context,
      MonthlyAreaType type,
      ) {
    switch (type) {
      case MonthlyAreaType.calories:
        return context.l10n.reportAreaCalories;
      case MonthlyAreaType.protein:
        return context.l10n.reportAreaProtein;
      case MonthlyAreaType.carbs:
        return context.l10n.reportAreaCarbs;
      case MonthlyAreaType.fat:
        return context.l10n.reportAreaFat;
      case MonthlyAreaType.hydration:
        return context.l10n.reportAreaHydration;
      case MonthlyAreaType.activity:
        return context.l10n.reportAreaActivity;
      case MonthlyAreaType.tracking:
        return context.l10n.reportAreaTracking;
      case MonthlyAreaType.weekends:
        return context.l10n.reportAreaWeekends;
    }
  }

  String _changeLabel(
      BuildContext context,
      MonthlyChangeType type,
      ) {
    switch (type) {
      case MonthlyChangeType.trackingConsistency:
        return context.l10n.monthlyChangeTrackingConsistency;
      case MonthlyChangeType.goalConsistency:
        return context.l10n.monthlyChangeGoalConsistency;
      case MonthlyChangeType.calorieTargetDays:
        return context.l10n.monthlyChangeCalories;
      case MonthlyChangeType.proteinTargetDays:
        return context.l10n.monthlyChangeProtein;
      case MonthlyChangeType.hydrationTargetDays:
        return context.l10n.monthlyChangeHydration;
      case MonthlyChangeType.activeDays:
        return context.l10n.monthlyChangeActivity;
    }
  }

  String _formatChangeValue(MonthlyChangeCalculation change) {
    final absolute = change.difference.abs();

    switch (change.type) {
      case MonthlyChangeType.trackingConsistency:
      case MonthlyChangeType.goalConsistency:
        return '${absolute.round()}%';

      case MonthlyChangeType.calorieTargetDays:
      case MonthlyChangeType.proteinTargetDays:
      case MonthlyChangeType.hydrationTargetDays:
      case MonthlyChangeType.activeDays:
        return absolute.round().toString();
    }
  }

  MonthlyChangeDirection _changeDirection(
      MonthlyCalculationChangeDirection direction,
      ) {
    switch (direction) {
      case MonthlyCalculationChangeDirection.up:
        return MonthlyChangeDirection.up;

      case MonthlyCalculationChangeDirection.down:
        return MonthlyChangeDirection.down;

      case MonthlyCalculationChangeDirection.same:
        return MonthlyChangeDirection.same;
    }
  }

  String _monthlyScoreLabel(
      BuildContext context,
      ReportPerformanceLevel level,
      ) {
    switch (level) {
      case ReportPerformanceLevel.strong:
        return context.l10n.monthlyScoreStrong;
      case ReportPerformanceLevel.good:
        return context.l10n.monthlyScoreGood;
      case ReportPerformanceLevel.needsFocus:
        return context.l10n.monthlyScoreNeedsFocus;
      case ReportPerformanceLevel.needsImprovement:
        return context.l10n.monthlyScoreNeedsImprovement;
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