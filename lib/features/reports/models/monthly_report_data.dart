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

  final List<MonthlyPatternData> patterns;

  final List<String> reviewParagraphs;

  final MonthlyPlanData plan;

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
    required this.patterns,
    required this.reviewParagraphs,
    required this.plan,
  });
}

// ============================================================
// WHAT CHANGED THIS MONTH
// ============================================================

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

// ============================================================
// METRICS
// ============================================================

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

// ============================================================
// STRONGEST / WEAKEST AREA
// ============================================================

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

// ============================================================
// CONSISTENCY
// ============================================================

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

// ============================================================
// WEIGHT & PLAN
// ============================================================

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

// ============================================================
// PATTERNS
// ============================================================

class MonthlyPatternData {
  final String title;
  final String description;

  const MonthlyPatternData({
    required this.title,
    required this.description,
  });
}

// ============================================================
// MONTHLY PLAN
// ============================================================

class MonthlyPlanData {
  final String title;

  final String mainFocus;

  final String keepDoing;

  final String improve;

  final String watch;

  const MonthlyPlanData({
    required this.title,
    required this.mainFocus,
    required this.keepDoing,
    required this.improve,
    required this.watch,
  });
}