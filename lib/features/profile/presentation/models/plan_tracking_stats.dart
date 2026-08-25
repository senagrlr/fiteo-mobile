import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';

class PlanTrackingStats {
  final DateTime planActivatedAt;
  final DateTime? lastProcessedDate;

  final double planStartWeight;
  final double targetWeight;
  final String weightUnit;
  final double expectedWeeklyWeightChangeKg;

  final int planEligibleDays;
  final int calorieTrackedDays;
  final double calorieAdherenceSum;

  final int weightEntryCount;
  final double? latestWeight;
  final DateTime? latestWeightDate;
  final double? actualWeeklyWeightChangeKg;

  final double? progressRatio;

  final DateTime? estimatedGoalDate;
  final int? projectionDifferenceDays;

  final PlanStatus planStatus;

  final String? aiNote;
  final DateTime? aiNoteDate;

  const PlanTrackingStats({
    required this.planActivatedAt,
    required this.lastProcessedDate,
    required this.planStartWeight,
    required this.targetWeight,
    required this.weightUnit,
    required this.expectedWeeklyWeightChangeKg,
    required this.planEligibleDays,
    required this.calorieTrackedDays,
    required this.calorieAdherenceSum,
    required this.weightEntryCount,
    required this.latestWeight,
    required this.latestWeightDate,
    required this.actualWeeklyWeightChangeKg,
    required this.progressRatio,
    required this.estimatedGoalDate,
    required this.projectionDifferenceDays,
    required this.planStatus,
    required this.aiNote,
    required this.aiNoteDate,
  });

  double get trackingConsistency {
    if (planEligibleDays <= 0) return 0;

    return (calorieTrackedDays / planEligibleDays * 100)
        .clamp(0, 100)
        .toDouble();
  }

  double get calorieAdherence {
    if (calorieTrackedDays <= 0) return 0;

    return (calorieAdherenceSum / calorieTrackedDays)
        .clamp(0, 100)
        .toDouble();
  }

  PlanTrackingStats copyWith({
    DateTime? planActivatedAt,
    DateTime? lastProcessedDate,
    double? planStartWeight,
    double? targetWeight,
    String? weightUnit,
    double? expectedWeeklyWeightChangeKg,
    int? planEligibleDays,
    int? calorieTrackedDays,
    double? calorieAdherenceSum,
    int? weightEntryCount,
    double? latestWeight,
    DateTime? latestWeightDate,
    double? actualWeeklyWeightChangeKg,
    double? progressRatio,
    DateTime? estimatedGoalDate,
    int? projectionDifferenceDays,
    PlanStatus? planStatus,
    String? aiNote,
    DateTime? aiNoteDate,
  }) {
    return PlanTrackingStats(
      planActivatedAt: planActivatedAt ?? this.planActivatedAt,
      lastProcessedDate: lastProcessedDate ?? this.lastProcessedDate,
      planStartWeight: planStartWeight ?? this.planStartWeight,
      targetWeight: targetWeight ?? this.targetWeight,
      weightUnit: weightUnit ?? this.weightUnit,
      expectedWeeklyWeightChangeKg:
      expectedWeeklyWeightChangeKg ?? this.expectedWeeklyWeightChangeKg,
      planEligibleDays: planEligibleDays ?? this.planEligibleDays,
      calorieTrackedDays: calorieTrackedDays ?? this.calorieTrackedDays,
      calorieAdherenceSum: calorieAdherenceSum ?? this.calorieAdherenceSum,
      weightEntryCount: weightEntryCount ?? this.weightEntryCount,
      latestWeight: latestWeight ?? this.latestWeight,
      latestWeightDate: latestWeightDate ?? this.latestWeightDate,
      actualWeeklyWeightChangeKg:
      actualWeeklyWeightChangeKg ?? this.actualWeeklyWeightChangeKg,
      progressRatio: progressRatio ?? this.progressRatio,
      estimatedGoalDate: estimatedGoalDate ?? this.estimatedGoalDate,
      projectionDifferenceDays:
      projectionDifferenceDays ?? this.projectionDifferenceDays,
      planStatus: planStatus ?? this.planStatus,
      aiNote: aiNote ?? this.aiNote,
      aiNoteDate: aiNoteDate ?? this.aiNoteDate,
    );
  }
}