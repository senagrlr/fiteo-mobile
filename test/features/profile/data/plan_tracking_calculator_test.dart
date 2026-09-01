import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/profile/data/plan_tracking_calculator.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';

void main() {
  const calculator = PlanTrackingCalculator();

  group('PlanTrackingCalculator', () {
    test('calculates expected weekly weight change from calorie deficit', () {
      final result = calculator.calculateExpectedWeeklyWeightChange(
        calorieGoal: 2000,
        tdee: 2550,
      );

      expect(result, closeTo(-0.5, 0.0001));
    });

    test('linear regression respects real irregular date spacing', () {
      final points = [
        PlanWeightPoint(
          date: DateTime(2026, 8, 1),
          weightKg: 80,
        ),
        PlanWeightPoint(
          date: DateTime(2026, 8, 5),
          weightKg: 79.6,
        ),
        PlanWeightPoint(
          date: DateTime(2026, 8, 12),
          weightKg: 78.9,
        ),
        PlanWeightPoint(
          date: DateTime(2026, 8, 20),
          weightKg: 78.1,
        ),
      ];

      final result =
      calculator.calculateLinearRegressionWeeklyRate(points);

      expect(result, closeTo(-0.7, 0.05));
    });

    test('initial goal date uses expected plan rate', () {
      final result = calculator.calculateInitialEstimatedGoalDate(
        planStartWeight: 80,
        targetWeight: 75,
        expectedWeeklyWeightChangeKg: -0.5,
        planActivatedAt: DateTime(2026, 8, 1),
      );

      expect(result, DateTime(2026, 10, 10));
    });

    test('actual estimated goal date uses latest real weight and actual rate', () {
      final result = calculator.calculateEstimatedGoalDate(
        latestWeight: 78,
        targetWeight: 75,
        actualWeeklyWeightChangeKg: -1,
        latestWeightDate: DateTime(2026, 8, 22),
      );

      expect(result, DateTime(2026, 9, 12));
    });

    test('estimated goal date is null when trend moves away from goal', () {
      final result = calculator.calculateEstimatedGoalDate(
        latestWeight: 78,
        targetWeight: 75,
        actualWeeklyWeightChangeKg: 0.5,
        latestWeightDate: DateTime(2026, 8, 22),
      );

      expect(result, isNull);
    });

    test('projection difference compares actual projection with expected date', () {
      final result = calculator.calculateProjectionDifferenceDays(
        previousEstimate: DateTime(2026, 10, 10),
        newEstimate: DateTime(2026, 10, 3),
      );

      expect(result, -7);
      expect(calculator.isProjectionBetter(result), isTrue);
      expect(calculator.isProjectionWorse(result), isFalse);
    });

    test('status stays notEnoughData before minimum observation days', () {
      final result = calculator.calculateStatus(
        weightEntryCount: 3,
        observationDays: 13,
        calorieAdherence: 95,
        trackingConsistency: 95,
        progressRatio: 1,
        actualWeeklyWeightChangeKg: -0.5,
        expectedWeeklyWeightChangeKg: -0.5,
      );

      expect(result, PlanStatus.notEnoughData);
    });

    test('status stays notEnoughData with fewer than three weight entries', () {
      final result = calculator.calculateStatus(
        weightEntryCount: 2,
        observationDays: 30,
        calorieAdherence: 95,
        trackingConsistency: 95,
        progressRatio: 1,
        actualWeeklyWeightChangeKg: -0.5,
        expectedWeeklyWeightChangeKg: -0.5,
      );

      expect(result, PlanStatus.notEnoughData);
    });

    test('status is onTrack when actual progress is within expected range', () {
      final result = calculator.calculateStatus(
        weightEntryCount: 3,
        observationDays: 14,
        calorieAdherence: 90,
        trackingConsistency: 90,
        progressRatio: 1,
        actualWeeklyWeightChangeKg: -0.5,
        expectedWeeklyWeightChangeKg: -0.5,
      );

      expect(result, PlanStatus.onTrack);
    });

    test('status recommends review when progress is off but plan is followed', () {
      final result = calculator.calculateStatus(
        weightEntryCount: 3,
        observationDays: 14,
        calorieAdherence: 90,
        trackingConsistency: 90,
        progressRatio: 0.5,
        actualWeeklyWeightChangeKg: -0.25,
        expectedWeeklyWeightChangeKg: -0.5,
      );

      expect(result, PlanStatus.reviewRecommended);
    });

    test('status asks for consistency first when plan adherence is insufficient', () {
      final result = calculator.calculateStatus(
        weightEntryCount: 3,
        observationDays: 14,
        calorieAdherence: 70,
        trackingConsistency: 70,
        progressRatio: 0.5,
        actualWeeklyWeightChangeKg: -0.25,
        expectedWeeklyWeightChangeKg: -0.5,
      );

      expect(result, PlanStatus.improveConsistencyFirst);
    });
  });

  group('plan review adjustment', () {
    test('uses 50 percent conservative adjustment and rounds to nearest 5', () {
      final result = calculator.calculateReviewAdjustmentKcal(
        expectedWeeklyWeightChangeKg: -0.5,
        actualWeeklyWeightChangeKg: -0.2,
      );

      expect(result, 165);
    });

    test('clamps small review adjustment to minimum 100 kcal', () {
      final result = calculator.calculateReviewAdjustmentKcal(
        expectedWeeklyWeightChangeKg: -0.5,
        actualWeeklyWeightChangeKg: -0.45,
      );

      expect(result, 100);
    });

    test('clamps large review adjustment to maximum 200 kcal', () {
      final result = calculator.calculateReviewAdjustmentKcal(
        expectedWeeklyWeightChangeKg: -0.5,
        actualWeeklyWeightChangeKg: 0.2,
      );

      expect(result, 200);
    });

    test('reduces calories when weight loss is slower than expected', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: -0.5,
        actualWeeklyWeightChangeKg: -0.2,
      );

      expect(result, -165);
    });

    test('increases calories when weight loss is faster than expected', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: -0.5,
        actualWeeklyWeightChangeKg: -0.8,
      );

      expect(result, 165);
    });

    test('increases calories when weight gain is slower than expected', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: 0.3,
        actualWeeklyWeightChangeKg: 0.1,
      );

      expect(result, 110);
    });

    test('reduces calories when weight gain is faster than expected', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: 0.3,
        actualWeeklyWeightChangeKg: 0.6,
      );

      expect(result, -165);
    });

    test('reduces calories when maintain goal is gaining weight', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: 0,
        actualWeeklyWeightChangeKg: 0.3,
      );

      expect(result, -165);
    });

    test('increases calories when maintain goal is losing weight', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: 0,
        actualWeeklyWeightChangeKg: -0.3,
      );

      expect(result, 165);
    });

    test('returns zero delta when actual and expected rates are effectively equal', () {
      final result = calculator.calculateReviewCalorieDeltaKcal(
        expectedWeeklyWeightChangeKg: -0.5,
        actualWeeklyWeightChangeKg: -0.505,
      );

      expect(result, 0);
    });
  });
}