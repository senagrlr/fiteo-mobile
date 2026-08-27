import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/reports/data/monthly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';

void main() {
  const generator = MonthlyReportGenerator();

  test(
    'generates monthly cache with comparison accumulator and progress',
        () {
      final period = ReportPeriod(
        calendarStart: DateTime(2026, 8, 1),
        calendarEnd: DateTime(2026, 8, 31),
        effectiveStart: DateTime(2026, 8, 1),
        effectiveEnd: DateTime(2026, 8, 31),
      );

      final summaries = <Map<String, dynamic>>[];

      for (var day = 1; day <= 31; day++) {
        if (day == 7 ||
            day == 14 ||
            day == 21 ||
            day == 28) {
          continue;
        }

        summaries.add({
          'date':
          '2026-08-${day.toString().padLeft(2, '0')}',
          'netCalories': 2000,
          'protein': 120,
          'carbs': 200,
          'fat': 70,
          'hydrationMl': 2500,
          'calorieGoal': 2000,
          'proteinGoal': 120,
          'carbsGoal': 200,
          'fatGoal': 70,
          'waterGoalMl': 2500,
          'workoutMinutes': day % 3 == 0 ? 35 : 0,
          'workoutCount': day % 3 == 0 ? 1 : 0,
        });
      }

      final cache = generator.generate(
        period: period,
        summaries: summaries,
        generatedAt: DateTime(2026, 9, 1, 2),
        availableFrom: DateTime(2026, 9, 1, 10),
        currentPlanActivatedAt: DateTime(2026, 8, 16),
        currentExpectedWeeklyWeightChangeKg: -0.3,
        accumulator: MonthlyTargetAccumulator(
          monthKey: '2026-08',
          accruedExpectedChangeKg: -1.0,
          accruedThrough: DateTime(2026, 8, 15),
        ),
        startWeightKg: 80,
        currentWeightKg: 78.5,
        planStatus: 'onTrack',
        planStatusDescription: 'On track',
        previousScore: 70,
        previousComparisonBasis:
        const ReportComparisonBasis(
          trackingConsistency: 70,
          goalConsistency: 75,
          calorieTargetDays: 20,
          proteinTargetDays: 18,
          hydrationTargetDays: 19,
          activeDays: 8,
        ),
        reviewParagraphs: const [
          'Sample review paragraph.',
        ],
        nextMonth: const MonthlyNextMonthCache(
          title: 'September Plan',
          mainFocus: 'Keep your routine stable.',
          keepDoing: 'Continue consistent tracking.',
          improve: 'Increase activity.',
          watch: 'Stay hydrated.',
        ),
      );

      expect(
        cache.periodStart,
        DateTime(2026, 8, 1),
      );

      expect(
        cache.periodEnd,
        DateTime(2026, 8, 31),
      );

      expect(
        cache.previousScore,
        70,
      );

      expect(
        cache.scoreChange,
        cache.score - 70,
      );

      expect(
        cache.changes.length,
        lessThanOrEqualTo(5),
      );

      expect(
        cache.weightPlan.monthlyTargetChangeKg,
        closeTo(
          -1.6857142857,
          0.0001,
        ),
      );

      expect(
        cache.weightPlan.startWeightKg,
        80,
      );

      expect(
        cache.weightPlan.currentWeightKg,
        78.5,
      );

      expect(
        cache.weightPlan.progressAchievedPercent,
        isNotNull,
      );

      expect(
        cache.reviewParagraphs,
        isNotEmpty,
      );

      expect(
        cache.nextMonth.title,
        'September Plan',
      );

      expect(
        cache.emailSentAt,
        null,
      );
    },
  );
}