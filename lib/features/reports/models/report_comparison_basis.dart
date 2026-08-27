class ReportComparisonBasis {
  final double trackingConsistency;
  final double goalConsistency;

  final int calorieTargetDays;
  final int proteinTargetDays;
  final int hydrationTargetDays;
  final int activeDays;

  const ReportComparisonBasis({
    required this.trackingConsistency,
    required this.goalConsistency,
    required this.calorieTargetDays,
    required this.proteinTargetDays,
    required this.hydrationTargetDays,
    required this.activeDays,
  });
}