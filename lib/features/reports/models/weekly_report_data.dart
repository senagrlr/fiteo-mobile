class WeeklyReportData {
  final String dateRange;

  final int score;
  final int scoreChange;
  final String scoreLabel;

  final WeeklyOverviewData overview;
  final WeeklyMetricsData metrics;

  final WeeklyDayData bestDay;
  final WeeklyDayData worstDay;

  final WeeklyWeightPlanData weightPlan;

  final List<String> reviewParagraphs;

  final WeeklyNextWeekData nextWeek;

  const WeeklyReportData({
    required this.dateRange,
    required this.score,
    required this.scoreChange,
    required this.scoreLabel,
    required this.overview,
    required this.metrics,
    required this.bestDay,
    required this.worstDay,
    required this.weightPlan,
    required this.reviewParagraphs,
    required this.nextWeek,
  });
}

// ============================================================
// OVERVIEW
// ============================================================

class WeeklyOverviewData {
  final String caloriesStatus;
  final String proteinStatus;
  final String carbsStatus;
  final String fatStatus;
  final String hydrationStatus;
  final String activityStatus;

  const WeeklyOverviewData({
    required this.caloriesStatus,
    required this.proteinStatus,
    required this.carbsStatus,
    required this.fatStatus,
    required this.hydrationStatus,
    required this.activityStatus,
  });
}

// ============================================================
// METRICS
// ============================================================

class WeeklyMetricsData {
  final String caloriesAverage;
  final String caloriesTargetDays;

  final String activeDays;
  final String workoutTime;

  final String proteinAverage;
  final String proteinTargetDays;

  const WeeklyMetricsData({
    required this.caloriesAverage,
    required this.caloriesTargetDays,
    required this.activeDays,
    required this.workoutTime,
    required this.proteinAverage,
    required this.proteinTargetDays,
  });
}

// ============================================================
// BEST / WORST DAY
// ============================================================

class WeeklyDayData {
  final String dayLabel;

  final bool? caloriesAligned;
  final bool? activityAligned;
  final bool? waterAligned;
  final bool? proteinAligned;

  final int alignmentPercent;

  const WeeklyDayData({
    required this.dayLabel,
    required this.caloriesAligned,
    required this.activityAligned,
    required this.waterAligned,
    required this.proteinAligned,
    required this.alignmentPercent,
  });
}

// ============================================================
// WEIGHT & PLAN
// ============================================================

class WeeklyWeightPlanData {
  final double? startWeight;
  final double? currentWeight;

  final String statusLabel;
  final String? statusDescription;

  const WeeklyWeightPlanData({
    required this.startWeight,
    required this.currentWeight,
    required this.statusLabel,
    required this.statusDescription,
  });
}

// ============================================================
// NEXT WEEK
// ============================================================

class WeeklyNextWeekData {
  final String focusTitle;
  final String focusDescription;
  final List<String> tips;

  const WeeklyNextWeekData({
    required this.focusTitle,
    required this.focusDescription,
    required this.tips,
  });
}