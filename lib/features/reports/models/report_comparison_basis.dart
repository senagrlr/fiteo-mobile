class ReportComparisonBasis {
  final int score;

  final double trackingConsistency;
  final double goalConsistency;

  final double calorieAdherence;
  final int calorieTargetDays;

  final double proteinAdherence;
  final int proteinTargetDays;

  final double carbsAdherence;
  final int carbsTargetDays;

  final double fatAdherence;
  final int fatTargetDays;

  final double hydrationAdherence;
  final int hydrationTargetDays;

  final double activityScore;
  final int activeDays;

  const ReportComparisonBasis({
    required this.score,
    required this.trackingConsistency,
    required this.goalConsistency,
    required this.calorieAdherence,
    required this.calorieTargetDays,
    required this.proteinAdherence,
    required this.proteinTargetDays,
    required this.carbsAdherence,
    required this.carbsTargetDays,
    required this.fatAdherence,
    required this.fatTargetDays,
    required this.hydrationAdherence,
    required this.hydrationTargetDays,
    required this.activityScore,
    required this.activeDays,
  });
}