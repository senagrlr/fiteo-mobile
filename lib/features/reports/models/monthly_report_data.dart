class MonthlyReportData {
  final String dateRange;

  final int score;
  final int scoreChange;
  final String scoreLabel;

  final MonthlyOverviewData overview;
  final MonthlyMetricsData metrics;

  final MonthlyAreaData strongestArea;
  final MonthlyAreaData weakestArea;

  final MonthlyConsistencyData consistency;

  final MonthlyWeightPlanData weightPlan;

  final List<String> reviewParagraphs;

  final MonthlyNextMonthData nextMonth;

  const MonthlyReportData({
    required this.dateRange,
    required this.score,
    required this.scoreChange,
    required this.scoreLabel,
    required this.overview,
    required this.metrics,
    required this.strongestArea,
    required this.weakestArea,
    required this.consistency,
    required this.weightPlan,
    required this.reviewParagraphs,
    required this.nextMonth,
  });
}

enum MonthlyChangeDirection {
  up,
  down,
  same,
}

class MonthlyChangeItem {
  final String label;
  final String value;
  final MonthlyChangeDirection direction;

  const MonthlyChangeItem({
    required this.label,
    required this.value,
    required this.direction,
  });
}

class MonthlyOverviewData {
  final List<MonthlyChangeItem> changes;

  const MonthlyOverviewData({
    required this.changes,
  });
}

class MonthlyMetricsData {
  final String caloriesAverage;
  final String caloriesTargetDays;

  final String activeDays;
  final String workoutTime;

  final String proteinAverage;
  final String proteinTargetDays;

  const MonthlyMetricsData({
    required this.caloriesAverage,
    required this.caloriesTargetDays,
    required this.activeDays,
    required this.workoutTime,
    required this.proteinAverage,
    required this.proteinTargetDays,
  });
}

class MonthlyAreaData {
  final String title;
  final String primaryText;
  final String secondaryText;
  final String badgeText;

  const MonthlyAreaData({
    required this.title,
    required this.primaryText,
    required this.secondaryText,
    required this.badgeText,
  });
}

class MonthlyConsistencyData {
  final int trackingConsistency;
  final int trackedDays;
  final int totalDays;

  final int goalConsistency;
  final String goalConsistencyNote;

  final int longestStreakDays;
  final int perfectDays;

  const MonthlyConsistencyData({
    required this.trackingConsistency,
    required this.trackedDays,
    required this.totalDays,
    required this.goalConsistency,
    required this.goalConsistencyNote,
    required this.longestStreakDays,
    required this.perfectDays,
  });
}

class MonthlyWeightPlanData {
  final double? startWeight;
  final double? currentWeight;

  final double? monthlyTargetChange;
  final int? progressAchievedPercent;

  final String statusLabel;
  final String? statusDescription;

  const MonthlyWeightPlanData({
    required this.startWeight,
    required this.currentWeight,
    required this.monthlyTargetChange,
    required this.progressAchievedPercent,
    required this.statusLabel,
    required this.statusDescription,
  });
}

class MonthlyNextMonthData {
  final String title;
  final String mainFocus;
  final List<String> tips;

  const MonthlyNextMonthData({
    required this.title,
    required this.mainFocus,
    required this.tips,
  });
}