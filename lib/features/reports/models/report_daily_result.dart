class ReportDailyResult {
  final DateTime date;

  final bool hasNutritionTracking;
  final bool hasWaterTracking;
  final bool hasWorkoutTracking;
  final bool isTracked;

  final bool isComparable;

  final double? calorieAdherence;
  final double? proteinAdherence;
  final double? carbsAdherence;
  final double? fatAdherence;

  final double? waterAdherence;
  final double? activityScore;

  final bool? calorieTargetHit;
  final bool? proteinTargetHit;
  final bool? carbsTargetHit;
  final bool? fatTargetHit;
  final bool? waterTargetHit;
  final bool? activityTargetHit;

  final double? dailyAlignment;

  const ReportDailyResult({
    required this.date,
    required this.hasNutritionTracking,
    required this.hasWaterTracking,
    required this.hasWorkoutTracking,
    required this.isTracked,
    required this.isComparable,
    required this.calorieAdherence,
    required this.proteinAdherence,
    required this.carbsAdherence,
    required this.fatAdherence,
    required this.waterAdherence,
    required this.activityScore,
    required this.calorieTargetHit,
    required this.proteinTargetHit,
    required this.carbsTargetHit,
    required this.fatTargetHit,
    required this.waterTargetHit,
    required this.activityTargetHit,
    required this.dailyAlignment,
  });
}