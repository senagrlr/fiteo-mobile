import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

void main() {
  const generator = WeeklyReportGenerator();

  test(
    'generates weekly cache with calendar dates and calculated metrics',
        () {
      final period = ReportPeriod(
        calendarStart: DateTime(2026, 8, 24),
        calendarEnd: DateTime(2026, 8, 30),
        effectiveStart: DateTime(2026, 8, 26),
        effectiveEnd: DateTime(2026, 8, 30),
      );

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
          'netCalories': 1900,
          'protein': 115,
          'carbs': 195,
          'fat': 68,
          'hydrationMl': 2400,
          'calorieGoal': 2000,
          'proteinGoal': 120,
          'carbsGoal': 200,
          'fatGoal': 70,
          'waterGoalMl': 2500,
        },
        {
          'date': '2026-08-28',
          'netCalories': 2100,
          'protein': 125,
          'carbs': 205,
          'fat': 72,
          'calorieGoal': 2000,
          'proteinGoal': 120,
          'carbsGoal': 200,
          'fatGoal': 70,
        },
        {
          'date': '2026-08-30',
          'hydrationMl': 2500,
          'workoutMinutes': 35,
          'workoutCount': 1,
          'waterGoalMl': 2500,
        },
      ];

      final cache = generator.generate(
        days: summaries,
        period: period,
        generatedAt: DateTime(2026, 8, 31, 2),
        availableFrom: DateTime(2026, 8, 31, 10),
        weightPlan: const WeeklyWeightPlanCache(
          startWeightKg: null,
          currentWeightKg: null,
          planStatus: 'notEnoughData',
          planStatusDescription: null,
        ),
        reviewParagraphs: const [],
        nextWeek: const WeeklyNextWeekCache(
          focusTitle: '',
          focusDescription: '',
          tips: [],
        ),
        previousScore: 75,
      );

      expect(
        cache.periodStart,
        DateTime(2026, 8, 24),
      );

      expect(
        cache.periodEnd,
        DateTime(2026, 8, 30),
      );

      expect(
        cache.isAvailable,
        false,
      );

      expect(
        cache.dismissed,
        false,
      );

      expect(
        cache.emailSentAt,
        null,
      );

      expect(
        cache.previousScore,
        75,
      );

      expect(
        cache.scoreChange,
        cache.score - 75,
      );

      expect(
        cache.metrics.calorieEvaluatedDays,
        3,
      );

      expect(
        cache.metrics.proteinEvaluatedDays,
        3,
      );

      expect(
        cache.metrics.activeDays,
        2,
      );

      expect(
        cache.metrics.totalWorkoutMinutes,
        75,
      );
    },
  );
}