import 'dart:math' as math;

import 'package:fl_chart/fl_chart.dart';

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_day_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_models.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_snapshot.dart';

class ProgressDataBuilder {
  final BuildContext context;
  final ProgressSnapshot snapshot;
  final DateTime today;

  ProgressDataBuilder({
    required this.context,
    required this.snapshot,
    DateTime? today,
  }) : today = DateTime(
    (today ?? DateTime.now()).year,
    (today ?? DateTime.now()).month,
    (today ?? DateTime.now()).day,
  );

  ProgressChartData buildChart({
    required ProgressMetric metric,
    required ProgressRange range,
    required ProgressNutritionMetric nutritionMetric,
  }) {
    switch (metric) {
      case ProgressMetric.nutrition:
        return _buildNutritionChart(range, nutritionMetric);
      case ProgressMetric.water:
        return _buildWaterChart(range);
      case ProgressMetric.workout:
        return _buildWorkoutChart(range);
      case ProgressMetric.weight:
        return _emptyWeightChart();
    }
  }

  ProgressSummaryValues buildSummary({
    required ProgressMetric metric,
    required ProgressRange range,
    required ProgressNutritionMetric nutritionMetric,
  }) {
    if (range == ProgressRange.days365) {
      switch (metric) {
        case ProgressMetric.nutrition:
          return _yearlyNutritionSummary(nutritionMetric);
        case ProgressMetric.water:
          return _yearlyWaterSummary();
        case ProgressMetric.workout:
          return _yearlyWorkoutSummary();
        case ProgressMetric.weight:
          return const ProgressSummaryValues(
            primary: '—',
            left: '—',
            right: '—',
          );
      }
    }

    final dates = _datesForRange(range);

    switch (metric) {
      case ProgressMetric.nutrition:
        return _nutritionSummary(dates, nutritionMetric);
      case ProgressMetric.water:
        return _waterSummary(dates);
      case ProgressMetric.workout:
        return _workoutSummary(dates);
      case ProgressMetric.weight:
        return const ProgressSummaryValues(
          primary: '—',
          left: '—',
          right: '—',
        );
    }
  }

  String dateRangeLabel(ProgressRange range) {
    if (range == ProgressRange.days365) {
      final start = _effectiveStartDate(range);
      return '${_formatDate(start)} - ${_formatDate(today)}';
    }

    final dates = _datesForRange(range);
    if (dates.isEmpty) return '';

    return '${_formatDate(dates.first)} - ${_formatDate(dates.last)}';
  }

  ProgressChartData _buildNutritionChart(
      ProgressRange range,
      ProgressNutritionMetric metric,
      ) {
    if (range == ProgressRange.days365) {
      return _buildYearlyNutritionChart(metric);
    }

    final buckets = _buildBuckets(range);
    final values = <double>[];
    final goals = <double>[];

    for (final bucket in buckets) {
      values.add(
        _averageDailyValue(
          bucket.dates,
              (day) => _nutritionValue(day, metric),
        ),
      );

      final goal = _averageAvailableGoal(
        bucket.dates,
            (day) => _nutritionGoal(day, metric),
      );

      if (goal != null) {
        goals.add(goal);
      }
    }

    final target = goals.isEmpty ? null : _average(goals);

    final scale = _nutritionScale(metric);

    final bounds = _chartBounds(
      values,
      target: target,
      startsAtZero: true,
      minimumMax: scale.max,
      preferredInterval: scale.interval,
    );

    return ProgressChartData(
      lineColor: AppColors.planTrackingProteinBadge,
      spots: _spots(values),
      bottomLabels: buckets.map((e) => e.label).toList(),
      minY: bounds.min,
      maxY: bounds.max,
      interval: bounds.interval,
      targetY: target,
      tooltipUnit: _nutritionUnit(metric),
    );
  }

  ProgressSummaryValues _nutritionSummary(
      List<DateTime> dates,
      ProgressNutritionMetric metric,
      ) {
    final average = _averageDailyValue(
      dates,
          (day) => _nutritionValue(day, metric),
    );

    final target = _averageAvailableGoal(
      dates,
          (day) => _nutritionGoal(day, metric),
    );

    var targetDays = 0;

    for (final date in dates) {
      final day = snapshot.day(date);
      if (day == null) continue;

      final goal = _nutritionGoal(day, metric);
      if (goal == null || goal <= 0) continue;

      if (_nutritionValue(day, metric) >= goal) {
        targetDays++;
      }
    }

    return ProgressSummaryValues(
      primary: _formatMetric(average, metric),
      left: target == null ? '—' : _formatMetric(target, metric),
      right: '$targetDays/${dates.length}',
    );
  }

  ProgressChartData _buildYearlyNutritionChart(
      ProgressNutritionMetric metric,
      ) {
    final months = _last12Months();
    final values = <double>[];
    final goals = <double>[];

    for (final monthDate in months) {
      final month = snapshot.month(monthDate);

      if (month == null) {
        values.add(0);
        continue;
      }

      final coveredDays = _coveredDaysInMonth(monthDate);

      switch (metric) {
        case ProgressNutritionMetric.calories:
          values.add(month.caloriesSum / coveredDays);

          if (month.calorieGoalCount > 0) {
            goals.add(month.calorieGoalSum / month.calorieGoalCount);
          }
          break;

        case ProgressNutritionMetric.protein:
          values.add(month.proteinSum / coveredDays);

          if (month.proteinGoalCount > 0) {
            goals.add(month.proteinGoalSum / month.proteinGoalCount);
          }
          break;

        case ProgressNutritionMetric.carbs:
          values.add(month.carbsSum / coveredDays);

          if (month.carbsGoalCount > 0) {
            goals.add(month.carbsGoalSum / month.carbsGoalCount);
          }
          break;

        case ProgressNutritionMetric.fat:
          values.add(month.fatSum / coveredDays);

          if (month.fatGoalCount > 0) {
            goals.add(month.fatGoalSum / month.fatGoalCount);
          }
          break;
      }
    }

    final target = goals.isEmpty ? null : _average(goals);

    final scale = _nutritionScale(metric);

    final bounds = _chartBounds(
      values,
      target: target,
      startsAtZero: true,
      minimumMax: scale.max,
      preferredInterval: scale.interval,
    );

    return ProgressChartData(
      lineColor: AppColors.planTrackingProteinBadge,
      spots: _spots(values),
      bottomLabels: months.map(_monthLabel).toList(),
      minY: bounds.min,
      maxY: bounds.max,
      interval: bounds.interval,
      targetY: target,
      tooltipUnit: _nutritionUnit(metric),
    );
  }

  ProgressSummaryValues _yearlyNutritionSummary(
      ProgressNutritionMetric metric,
      ) {
    final months = _last12Months();

    double total = 0;
    int totalDays = 0;

    double goalTotal = 0;
    int goalCount = 0;

    var targetDays = 0;

    for (final monthDate in months) {
      totalDays += _coveredDaysInMonth(monthDate);

      final month = snapshot.month(monthDate);
      if (month == null) continue;

      switch (metric) {
        case ProgressNutritionMetric.calories:
          total += month.caloriesSum;
          goalTotal += month.calorieGoalSum;
          goalCount += month.calorieGoalCount;
          targetDays += month.calorieTargetDays;
          break;

        case ProgressNutritionMetric.protein:
          total += month.proteinSum;
          goalTotal += month.proteinGoalSum;
          goalCount += month.proteinGoalCount;
          targetDays += month.proteinTargetDays;
          break;

        case ProgressNutritionMetric.carbs:
          total += month.carbsSum;
          goalTotal += month.carbsGoalSum;
          goalCount += month.carbsGoalCount;
          targetDays += month.carbsTargetDays;
          break;

        case ProgressNutritionMetric.fat:
          total += month.fatSum;
          goalTotal += month.fatGoalSum;
          goalCount += month.fatGoalCount;
          targetDays += month.fatTargetDays;
          break;
      }
    }

    final average = totalDays == 0 ? 0.0 : total / totalDays;
    final target = goalCount == 0 ? null : goalTotal / goalCount;

    return ProgressSummaryValues(
      primary: _formatMetric(average, metric),
      left: target == null ? '—' : _formatMetric(target, metric),
      right: '$targetDays/$totalDays',
    );
  }

  double _nutritionValue(
      ProgressDayData day,
      ProgressNutritionMetric metric,
      ) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return day.calories;
      case ProgressNutritionMetric.protein:
        return day.protein;
      case ProgressNutritionMetric.carbs:
        return day.carbs;
      case ProgressNutritionMetric.fat:
        return day.fat;
    }
  }

  double? _nutritionGoal(
      ProgressDayData day,
      ProgressNutritionMetric metric,
      ) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return day.calorieGoal;
      case ProgressNutritionMetric.protein:
        return day.proteinGoal;
      case ProgressNutritionMetric.carbs:
        return day.carbsGoal;
      case ProgressNutritionMetric.fat:
        return day.fatGoal;
    }
  }

  _MetricScale _nutritionScale(ProgressNutritionMetric metric) {
    switch (metric) {
      case ProgressNutritionMetric.calories:
        return const _MetricScale(
          max: 2500,
          interval: 500,
        );

      case ProgressNutritionMetric.protein:
        return const _MetricScale(
          max: 150,
          interval: 30,
        );

      case ProgressNutritionMetric.carbs:
        return const _MetricScale(
          max: 300,
          interval: 50,
        );

      case ProgressNutritionMetric.fat:
        return const _MetricScale(
          max: 100,
          interval: 20,
        );
    }
  }

  String _nutritionUnit(ProgressNutritionMetric metric) {
    return metric == ProgressNutritionMetric.calories ? 'kcal' : 'g';
  }

  String _formatMetric(
      double value,
      ProgressNutritionMetric metric,
      ) {
    if (metric == ProgressNutritionMetric.calories) {
      return value.round().toString();
    }

    return '${_formatDouble(value)} g';
  }

  ProgressChartData _buildWaterChart(ProgressRange range) {
    if (range == ProgressRange.days365) {
      return _buildYearlyWaterChart();
    }

    final buckets = _buildBuckets(range);
    final values = <double>[];
    final goals = <double>[];

    for (final bucket in buckets) {
      values.add(
        _averageDailyValue(
          bucket.dates,
              (day) => day.hydrationMl.toDouble(),
        ) /
            1000,
      );

      final goal = _averageAvailableGoal(
        bucket.dates,
            (day) => day.waterGoalMl?.toDouble(),
      );

      if (goal != null) {
        goals.add(goal / 1000);
      }
    }

    final target = goals.isEmpty ? null : _average(goals);

    final bounds = _chartBounds(
      values,
      target: target,
      startsAtZero: true,
      minimumMax: 2.5,
      preferredInterval: 0.5,
    );

    return ProgressChartData(
      lineColor: AppColors.planTrackingActiveDayBadge,
      spots: _spots(values),
      bottomLabels: buckets.map((e) => e.label).toList(),
      minY: bounds.min,
      maxY: bounds.max,
      interval: bounds.interval,
      targetY: target,
      tooltipUnit: 'L',
    );
  }

  ProgressSummaryValues _waterSummary(List<DateTime> dates) {
    final averageMl = _averageDailyValue(
      dates,
          (day) => day.hydrationMl.toDouble(),
    );

    final targetMl = _averageAvailableGoal(
      dates,
          (day) => day.waterGoalMl?.toDouble(),
    );

    var targetDays = 0;

    for (final date in dates) {
      final day = snapshot.day(date);

      if (day == null || day.waterGoalMl == null || day.waterGoalMl! <= 0) {
        continue;
      }

      if (day.hydrationMl >= day.waterGoalMl!) {
        targetDays++;
      }
    }

    return ProgressSummaryValues(
      primary: '${_formatDouble(averageMl / 1000)} L',
      left: targetMl == null ? '—' : '${_formatDouble(targetMl / 1000)} L',
      right: '$targetDays/${dates.length}',
    );
  }

  ProgressChartData _buildYearlyWaterChart() {
    final months = _last12Months();
    final values = <double>[];
    final goals = <double>[];

    for (final monthDate in months) {
      final month = snapshot.month(monthDate);

      if (month == null) {
        values.add(0);
        continue;
      }

      final coveredDays = _coveredDaysInMonth(monthDate);
      values.add((month.hydrationSum / coveredDays) / 1000);

      if (month.waterGoalCount > 0) {
        goals.add((month.waterGoalSum / month.waterGoalCount) / 1000);
      }
    }

    final target = goals.isEmpty ? null : _average(goals);

    final bounds = _chartBounds(
      values,
      target: target,
      startsAtZero: true,
      minimumMax: 2.5,
      preferredInterval: 0.5,
    );

    return ProgressChartData(
      lineColor: AppColors.planTrackingActiveDayBadge,
      spots: _spots(values),
      bottomLabels: months.map(_monthLabel).toList(),
      minY: bounds.min,
      maxY: bounds.max,
      interval: bounds.interval,
      targetY: target,
      tooltipUnit: 'L',
    );
  }

  ProgressSummaryValues _yearlyWaterSummary() {
    final months = _last12Months();

    var hydrationTotal = 0;
    var totalDays = 0;
    var goalTotal = 0;
    var goalCount = 0;
    var targetDays = 0;

    for (final monthDate in months) {
      totalDays += _coveredDaysInMonth(monthDate);

      final month = snapshot.month(monthDate);
      if (month == null) continue;

      hydrationTotal += month.hydrationSum;
      goalTotal += month.waterGoalSum;
      goalCount += month.waterGoalCount;
      targetDays += month.waterTargetDays;
    }

    final average = totalDays == 0 ? 0.0 : hydrationTotal / totalDays;
    final target = goalCount == 0 ? null : goalTotal / goalCount;

    return ProgressSummaryValues(
      primary: '${_formatDouble(average / 1000)} L',
      left: target == null ? '—' : '${_formatDouble(target / 1000)} L',
      right: '$targetDays/$totalDays',
    );
  }

  ProgressChartData _buildWorkoutChart(ProgressRange range) {
    if (range == ProgressRange.days365) {
      return _buildYearlyWorkoutChart();
    }

    final buckets = _buildBuckets(range);

    final values = buckets.map((bucket) {
      return _averageDailyValue(
        bucket.dates,
            (day) => day.workoutMinutes.toDouble(),
      );
    }).toList();

    final bounds = _chartBounds(
      values,
      startsAtZero: true,
      minimumMax: 60,
      preferredInterval: 10,
    );

    return ProgressChartData(
      lineColor: AppColors.planTrackingStreakBadge,
      spots: _spots(values),
      bottomLabels: buckets.map((e) => e.label).toList(),
      minY: bounds.min,
      maxY: bounds.max,
      interval: bounds.interval,
      targetY: null,
      tooltipUnit: context.l10n.minuteUnitShort,
    );
  }

  ProgressSummaryValues _workoutSummary(List<DateTime> dates) {
    var totalWorkoutCount = 0;
    var activeDays = 0;
    var totalMinutes = 0;

    for (final date in dates) {
      final day = snapshot.day(date);
      if (day == null) continue;

      totalWorkoutCount += day.workoutCount;
      totalMinutes += day.workoutMinutes;

      if (day.isActiveDay) activeDays++;
    }

    final averageDuration =
    dates.isEmpty ? 0.0 : totalMinutes / dates.length;

    return ProgressSummaryValues(
      primary: totalWorkoutCount.toString(),
      left: activeDays.toString(),
      right: '${_formatDouble(averageDuration)} ${context.l10n.minuteUnitShort}',
    );
  }

  ProgressChartData _buildYearlyWorkoutChart() {
    final months = _last12Months();

    final values = months.map((monthDate) {
      final month = snapshot.month(monthDate);

      if (month == null) {
        return 0.0;
      }

      final coveredDays = _coveredDaysInMonth(monthDate);
      return month.workoutMinutesSum / coveredDays;
    }).toList();

    final bounds = _chartBounds(
      values,
      startsAtZero: true,
      minimumMax: 60,
      preferredInterval: 10,
    );

    return ProgressChartData(
      lineColor: AppColors.planTrackingStreakBadge,
      spots: _spots(values),
      bottomLabels: months.map(_monthLabel).toList(),
      minY: bounds.min,
      maxY: bounds.max,
      interval: bounds.interval,
      targetY: null,
      tooltipUnit: context.l10n.minuteUnitShort,
    );
  }

  ProgressSummaryValues _yearlyWorkoutSummary() {
    final months = _last12Months();

    var totalWorkoutCount = 0;
    var activeDays = 0;
    var totalMinutes = 0;
    var totalDays = 0;

    for (final monthDate in months) {
      totalDays += _coveredDaysInMonth(monthDate);

      final month = snapshot.month(monthDate);
      if (month == null) continue;

      totalWorkoutCount += month.workoutCount;
      activeDays += month.activeDays;
      totalMinutes += month.workoutMinutesSum;
    }

    final averageDuration =
    totalDays == 0 ? 0.0 : totalMinutes / totalDays;

    return ProgressSummaryValues(
      primary: totalWorkoutCount.toString(),
      left: activeDays.toString(),
      right: '${_formatDouble(averageDuration)} ${context.l10n.minuteUnitShort}',
    );
  }

  DateTime _effectiveStartDate(ProgressRange range) {
    late final DateTime requestedStart;

    switch (range) {
      case ProgressRange.days7:
        requestedStart = today.subtract(const Duration(days: 6));
        break;

      case ProgressRange.days30:
        requestedStart = today.subtract(const Duration(days: 29));
        break;

      case ProgressRange.days90:
        requestedStart = today.subtract(const Duration(days: 89));
        break;

      case ProgressRange.days365:
        requestedStart = DateTime(today.year, today.month - 11, 1);
        break;
    }

    final trackingStart = DateTime(
      snapshot.trackingStartDate.year,
      snapshot.trackingStartDate.month,
      snapshot.trackingStartDate.day,
    );

    return trackingStart.isAfter(requestedStart)
        ? trackingStart
        : requestedStart;
  }

  List<DateTime> _datesForRange(ProgressRange range) {
    if (range == ProgressRange.days365) {
      return [];
    }

    final start = _effectiveStartDate(range);
    return _datesBetween(start, today);
  }

  List<_ProgressBucket> _buildBuckets(ProgressRange range) {
    switch (range) {
      case ProgressRange.days7:
        return _dailyBuckets(_datesForRange(range));

      case ProgressRange.days30:
      case ProgressRange.days90:
        return _weeklyBuckets(_datesForRange(range));

      case ProgressRange.days365:
        return [];
    }
  }

  List<_ProgressBucket> _dailyBuckets(List<DateTime> dates) {
    return dates.map((date) {
      return _ProgressBucket(
        dates: [date],
        label: _weekdayLabel(date),
      );
    }).toList();
  }

  List<_ProgressBucket> _weeklyBuckets(List<DateTime> dates) {
    if (dates.isEmpty) return [];

    final buckets = <List<DateTime>>[];
    var current = <DateTime>[];

    for (final date in dates) {
      if (current.isNotEmpty && date.weekday == DateTime.monday) {
        buckets.add(current);
        current = [];
      }

      current.add(date);
    }

    if (current.isNotEmpty) {
      buckets.add(current);
    }

    return List.generate(
      buckets.length,
          (index) => _ProgressBucket(
        dates: buckets[index],
            label: '${context.l10n.weekShort}${index + 1}',
      ),
    );
  }

  List<DateTime> _last12Months() {
    final start = _effectiveStartDate(ProgressRange.days365);
    final months = <DateTime>[];

    var month = DateTime(start.year, start.month, 1);
    final currentMonth = DateTime(today.year, today.month, 1);

    while (!month.isAfter(currentMonth)) {
      months.add(month);
      month = DateTime(month.year, month.month + 1, 1);
    }

    return months;
  }

  int _coveredDaysInMonth(DateTime month) {
    final rangeStart = _effectiveStartDate(ProgressRange.days365);

    final monthStart = DateTime(month.year, month.month, 1);
    final monthEnd = DateTime(month.year, month.month + 1, 0);

    var start = monthStart;
    var end = monthEnd;

    if (rangeStart.year == month.year &&
        rangeStart.month == month.month &&
        rangeStart.isAfter(monthStart)) {
      start = rangeStart;
    }

    if (today.year == month.year &&
        today.month == month.month &&
        today.isBefore(monthEnd)) {
      end = today;
    }

    return end.difference(start).inDays + 1;
  }

  List<DateTime> _datesBetween(
      DateTime start,
      DateTime end,
      ) {
    final dates = <DateTime>[];
    var date = start;

    while (!date.isAfter(end)) {
      dates.add(date);
      date = date.add(const Duration(days: 1));
    }

    return dates;
  }

  double _averageDailyValue(
      List<DateTime> dates,
      double Function(ProgressDayData day) selector,
      ) {
    if (dates.isEmpty) return 0;

    var total = 0.0;

    for (final date in dates) {
      final day = snapshot.day(date);
      if (day != null) total += selector(day);
    }

    return total / dates.length;
  }

  double? _averageAvailableGoal(
      List<DateTime> dates,
      double? Function(ProgressDayData day) selector,
      ) {
    var total = 0.0;
    var count = 0;

    for (final date in dates) {
      final day = snapshot.day(date);
      if (day == null) continue;

      final value = selector(day);

      if (value != null) {
        total += value;
        count++;
      }
    }

    return count == 0 ? null : total / count;
  }

  List<FlSpot> _spots(List<double> values) {
    return List.generate(
      values.length,
          (index) => FlSpot(index.toDouble(), values[index]),
    );
  }

  _ChartBounds _chartBounds(
      List<double> values, {
        double? target,
        bool startsAtZero = false,
        double? minimumMax,
        double? preferredInterval,
      }) {
    final candidates = [
      ...values,
      if (target != null) target,
    ];

    final rawMax = candidates.isEmpty ? 0.0 : candidates.reduce(math.max);
    final rawMin = candidates.isEmpty ? 0.0 : candidates.reduce(math.min);

    final min = startsAtZero ? 0.0 : math.max(0.0, rawMin * 0.85);

    final paddedMax = rawMax <= 0 ? 0.0 : rawMax * 1.15;

    final requiredMax = math.max(
      minimumMax ?? 0.0,
      paddedMax,
    );

    final interval = preferredInterval ?? _niceInterval(requiredMax - min);

    final max = requiredMax <= 0
        ? interval
        : ((requiredMax / interval).ceil() * interval).toDouble();

    return _ChartBounds(
      min: min,
      max: max <= min ? min + interval : max,
      interval: interval,
    );
  }

  double _niceInterval(double range) {
    if (range <= 0.25) return 0.05;
    if (range <= 0.5) return 0.1;
    if (range <= 1) return 0.2;
    if (range <= 3) return 0.5;
    if (range <= 10) return 2;
    if (range <= 30) return 5;
    if (range <= 80) return 10;
    if (range <= 150) return 25;
    if (range <= 400) return 50;
    if (range <= 800) return 100;
    if (range <= 1600) return 200;
    if (range <= 3000) return 500;
    return 1000;
  }

  double _average(List<double> values) {
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  String _formatDouble(double value) {
    return value == value.roundToDouble()
        ? value.round().toString()
        : value.toStringAsFixed(1);
  }

  String _formatDate(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}.'
        '${date.month.toString().padLeft(2, '0')}.'
        '${date.year}';
  }

  String _weekdayLabel(DateTime date) {
    final labels = [
      context.l10n.mondayShort,
      context.l10n.tuesdayShort,
      context.l10n.wednesdayShort,
      context.l10n.thursdayShort,
      context.l10n.fridayShort,
      context.l10n.saturdayShort,
      context.l10n.sundayShort,
    ];

    return labels[date.weekday - 1];
  }

  String _monthLabel(DateTime date) {
    final labels = [
      context.l10n.januaryShort,
      context.l10n.februaryShort,
      context.l10n.marchShort,
      context.l10n.aprilShort,
      context.l10n.mayShort,
      context.l10n.juneShort,
      context.l10n.julyShort,
      context.l10n.augustShort,
      context.l10n.septemberShort,
      context.l10n.octoberShort,
      context.l10n.novemberShort,
      context.l10n.decemberShort,
    ];

    return labels[date.month - 1];
  }

  ProgressChartData _emptyWeightChart() {
    return const ProgressChartData(
      lineColor: AppColors.homeBrown,
      spots: [FlSpot(0, 0)],
      bottomLabels: [''],
      minY: 0,
      maxY: 10,
      interval: 2,
      targetY: null,
      tooltipUnit: 'kg',
    );
  }
}

class ProgressSummaryValues {
  final String primary;
  final String left;
  final String right;

  const ProgressSummaryValues({
    required this.primary,
    required this.left,
    required this.right,
  });
}

class _ProgressBucket {
  final List<DateTime> dates;
  final String label;

  const _ProgressBucket({
    required this.dates,
    required this.label,
  });
}

class _ChartBounds {
  final double min;
  final double max;
  final double interval;

  const _ChartBounds({
    required this.min,
    required this.max,
    required this.interval,
  });
}

class _MetricScale {
  final double max;
  final double interval;

  const _MetricScale({
    required this.max,
    required this.interval,
  });
}