import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';

class PlanTrackingWeightPoint {
  final DateTime date;
  final double weightKg;

  const PlanTrackingWeightPoint({
    required this.date,
    required this.weightKg,
  });
}

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
  final List<PlanTrackingWeightPoint> weightPoints;

  final double? progressRatio;

  final DateTime? expectedGoalDate;
  final DateTime? estimatedGoalDate;
  final int? projectionDifferenceDays;

  final PlanStatus planStatus;

  final String? aiNote;
  final DateTime? aiNoteDate;
  final String? aiNoteStatus;
  final String? aiNoteWeightSignature;

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
    required this.weightPoints,
    required this.progressRatio,
    required this.expectedGoalDate,
    required this.estimatedGoalDate,
    required this.projectionDifferenceDays,
    required this.planStatus,
    required this.aiNote,
    required this.aiNoteDate,
    required this.aiNoteStatus,
    required this.aiNoteWeightSignature,
  });

  String get aiWeightSignature {
    final latestDate = latestWeightDate == null
        ? ''
        : '${latestWeightDate!.year}-'
        '${latestWeightDate!.month.toString().padLeft(2, '0')}-'
        '${latestWeightDate!.day.toString().padLeft(2, '0')}';

    final latestValue =
        latestWeight?.toStringAsFixed(3) ?? '';

    final actualRate =
        actualWeeklyWeightChangeKg?.toStringAsFixed(4) ?? '';

    final ratio =
        progressRatio?.toStringAsFixed(4) ?? '';

    return '$weightEntryCount|'
        '$latestDate|'
        '$latestValue|'
        '$actualRate|'
        '$ratio';
  }

  bool get needsAiNoteRefresh {
    if (aiNote == null || aiNote!.trim().isEmpty) {
      return true;
    }

    if (aiNoteStatus != planStatus.name) {
      return true;
    }

    return aiNoteWeightSignature !=
        aiWeightSignature;
  }

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
    List<PlanTrackingWeightPoint>? weightPoints,
    double? progressRatio,
    DateTime? expectedGoalDate,
    DateTime? estimatedGoalDate,
    int? projectionDifferenceDays,
    PlanStatus? planStatus,
    String? aiNote,
    DateTime? aiNoteDate,
    String? aiNoteStatus,
    String? aiNoteWeightSignature,
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
      weightPoints: weightPoints ?? this.weightPoints,
      progressRatio: progressRatio ?? this.progressRatio,
      expectedGoalDate: expectedGoalDate ?? this.expectedGoalDate,
      estimatedGoalDate: estimatedGoalDate ?? this.estimatedGoalDate,
      projectionDifferenceDays:
      projectionDifferenceDays ?? this.projectionDifferenceDays,
      planStatus: planStatus ?? this.planStatus,
      aiNote: aiNote ?? this.aiNote,
      aiNoteDate: aiNoteDate ?? this.aiNoteDate,
      aiNoteStatus: aiNoteStatus ?? this.aiNoteStatus,
      aiNoteWeightSignature: aiNoteWeightSignature ?? this.aiNoteWeightSignature,
    );
  }
}