import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/reports/data/report_period_aggregator.dart';

void main() {
  const aggregator = ReportPeriodAggregator();

  test(
    'tracking uses all eligible days while nutrition uses evaluated days',
        () {
      final summaries = [
        {
          'date': '2026-08-26',
          'netCalories': 2000,
          'protein': 120,
          'carbs': 200,
          'fat': 70,
          'hydrationMl': 2500,
          'workoutMinutes': 40,
          'workoutCount': 1,
          'calorieGoal': 2000,
          'proteinGoal': 120,
          'carbsGoal': 200,
          'fatGoal': 70,
          'waterGoalMl': 2500,
        },
        {
          'date': '2026-08-27',
          'netCalories': 1800,
          'protein': 100,
          'carbs': 180,
          'fat': 65,
          'calorieGoal': 2000,
          'proteinGoal': 120,
          'carbsGoal': 200,
          'fatGoal': 70,
        },
        {
          'date': '2026-08-29',
          'hydrationMl': 2500,
          'waterGoalMl': 2500,
        },
        {
          'date': '2026-08-30',
          'workoutMinutes': 35,
          'workoutCount': 1,
        },
      ];

      final stats = aggregator.calculate(
        startDate: DateTime(2026, 8, 26),
        endDate: DateTime(2026, 8, 30),
        summaries: summaries,
      );

      expect(
        stats.eligibleDays,
        5,
      );

      expect(
        stats.trackedDays,
        4,
      );

      expect(
        stats.trackingConsistency,
        closeTo(80, 0.001),
      );

      expect(
        stats.nutritionTrackedDays,
        2,
      );

      expect(
        stats.calorieEvaluatedDays,
        2,
      );

      expect(
        stats.proteinEvaluatedDays,
        2,
      );

      expect(
        stats.waterEvaluatedDays,
        2,
      );

      expect(
        stats.activeDays,
        2,
      );
    },
  );
}