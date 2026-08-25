import 'dart:math' as math;

import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';

class PlanTrackingCalculator {
  const PlanTrackingCalculator();

  static const double minPlanAdherence = 80;
  static const double minTrackingConsistency = 80;

  static const double minOnTrackRatio = 0.75;
  static const double maxOnTrackRatio = 1.25;

  static const int minWeightEntries = 3;
  static const int minObservationDays = 14;

  static const int projectionToleranceDays = 3;

  double calculateExpectedWeeklyWeightChange({
    required double calorieGoal,
    required double tdee,
  }) {
    if (tdee <= 0 || calorieGoal <= 0) return 0;

    final dailyEnergyDifference = calorieGoal - tdee;

    return dailyEnergyDifference * 7 / 7700;
  }

  double? calculateProgressRatio({
    required double expectedWeeklyWeightChangeKg,
    required double? actualWeeklyWeightChangeKg,
  }) {
    if (actualWeeklyWeightChangeKg == null) return null;

    if (expectedWeeklyWeightChangeKg.abs() < 0.01) {
      return null;
    }

    return actualWeeklyWeightChangeKg / expectedWeeklyWeightChangeKg;
  }

  PlanStatus calculateStatus({
    required int weightEntryCount,
    required int observationDays,
    required double calorieAdherence,
    required double trackingConsistency,
    required double? progressRatio,
    required double? actualWeeklyWeightChangeKg,
    required double expectedWeeklyWeightChangeKg,
  }) {
    final hasEnoughWeightData =
        weightEntryCount >= minWeightEntries &&
            observationDays >= minObservationDays &&
            actualWeeklyWeightChangeKg != null;

    if (!hasEnoughWeightData) {
      return PlanStatus.notEnoughData;
    }

    if (expectedWeeklyWeightChangeKg.abs() < 0.01) {
      final maintainingWeight = actualWeeklyWeightChangeKg.abs() <= 0.25;

      if (maintainingWeight) {
        return PlanStatus.onTrack;
      }

      final followsPlan =
          calorieAdherence >= minPlanAdherence &&
              trackingConsistency >= minTrackingConsistency;

      return followsPlan
          ? PlanStatus.reviewRecommended
          : PlanStatus.improveConsistencyFirst;
    }

    if (progressRatio != null &&
        progressRatio >= minOnTrackRatio &&
        progressRatio <= maxOnTrackRatio) {
      return PlanStatus.onTrack;
    }

    final followsPlan =
        calorieAdherence >= minPlanAdherence &&
            trackingConsistency >= minTrackingConsistency;

    return followsPlan
        ? PlanStatus.reviewRecommended
        : PlanStatus.improveConsistencyFirst;
  }

  DateTime? calculateEstimatedGoalDate({
    required double latestWeight,
    required double targetWeight,
    required double actualWeeklyWeightChangeKg,
    required DateTime latestWeightDate,
  }) {
    final remainingWeight = targetWeight - latestWeight;

    if (remainingWeight.abs() < 0.05) {
      return latestWeightDate;
    }

    if (actualWeeklyWeightChangeKg.abs() < 0.01) {
      return null;
    }

    final movingTowardGoal =
        remainingWeight.sign == actualWeeklyWeightChangeKg.sign;

    if (!movingTowardGoal) {
      return null;
    }

    final remainingWeeks =
        remainingWeight.abs() / actualWeeklyWeightChangeKg.abs();

    if (!remainingWeeks.isFinite || remainingWeeks < 0) {
      return null;
    }

    final remainingDays = (remainingWeeks * 7).round();

    return latestWeightDate.add(
      Duration(days: remainingDays),
    );
  }

  DateTime? calculateInitialEstimatedGoalDate({
    required double planStartWeight,
    required double targetWeight,
    required double expectedWeeklyWeightChangeKg,
    required DateTime planActivatedAt,
  }) {
    final remainingWeight = targetWeight - planStartWeight;

    if (remainingWeight.abs() < 0.05) {
      return planActivatedAt;
    }

    if (expectedWeeklyWeightChangeKg.abs() < 0.01) {
      return null;
    }

    final movingTowardGoal =
        remainingWeight.sign == expectedWeeklyWeightChangeKg.sign;

    if (!movingTowardGoal) {
      return null;
    }

    final weeks =
        remainingWeight.abs() / expectedWeeklyWeightChangeKg.abs();

    if (!weeks.isFinite || weeks < 0) {
      return null;
    }

    return planActivatedAt.add(
      Duration(days: (weeks * 7).round()),
    );
  }

  int? calculateProjectionDifferenceDays({
    required DateTime? previousEstimate,
    required DateTime? newEstimate,
  }) {
    if (previousEstimate == null || newEstimate == null) {
      return null;
    }

    return newEstimate.difference(previousEstimate).inDays;
  }

  bool isProjectionBetter(int? differenceDays) {
    if (differenceDays == null) return false;

    return differenceDays <= -projectionToleranceDays;
  }

  bool isProjectionWorse(int? differenceDays) {
    if (differenceDays == null) return false;

    return differenceDays >= projectionToleranceDays;
  }

  double calculateReviewAdjustmentKcal({
    required double expectedWeeklyWeightChangeKg,
    required double actualWeeklyWeightChangeKg,
  }) {
    final rateGap =
    (expectedWeeklyWeightChangeKg - actualWeeklyWeightChangeKg).abs();

    final rawDailyAdjustment = rateGap * 7700 / 7;

    final conservativeAdjustment = rawDailyAdjustment * 0.5;

    final clamped = conservativeAdjustment.clamp(100, 200).toDouble();

    return (clamped / 25).round() * 25.0;
  }

  double calculateLinearRegressionWeeklyRate(
      List<PlanWeightPoint> points,
      ) {
    if (points.length < 2) return 0;

    final sorted = [...points]
      ..sort((a, b) => a.date.compareTo(b.date));

    final startDate = sorted.first.date;

    final xValues = sorted
        .map((point) => point.date.difference(startDate).inDays.toDouble())
        .toList();

    final yValues = sorted.map((point) => point.weightKg).toList();

    final xMean = xValues.reduce((a, b) => a + b) / xValues.length;
    final yMean = yValues.reduce((a, b) => a + b) / yValues.length;

    var numerator = 0.0;
    var denominator = 0.0;

    for (var i = 0; i < xValues.length; i++) {
      final xDifference = xValues[i] - xMean;
      final yDifference = yValues[i] - yMean;

      numerator += xDifference * yDifference;
      denominator += math.pow(xDifference, 2).toDouble();
    }

    if (denominator == 0) return 0;

    final dailySlope = numerator / denominator;

    return dailySlope * 7;
  }
}

class PlanWeightPoint {
  final DateTime date;
  final double weightKg;

  const PlanWeightPoint({
    required this.date,
    required this.weightKg,
  });
}