import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:fiteo_myapp/features/reports/data/monthly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/data/report_cache_serializer.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generator.dart';

import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

void main() {
  const serializer = ReportCacheSerializer();

  group('ReportCacheSerializer round trip', () {
    test(
      'weekly cache survives map round trip',
          () {
        const generator = WeeklyReportGenerator();

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
            'date': '2026-08-30',
            'hydrationMl': 2500,
            'workoutMinutes': 35,
            'workoutCount': 1,
            'waterGoalMl': 2500,
          },
        ];

        final original = generator.generate(
          days: summaries,
          period: period,
          generatedAt: DateTime(2026, 8, 31, 2),
          availableFrom: DateTime(2026, 8, 31, 10),
          reviewParagraphs: const [
            'Weekly review.',
          ],
          nextWeek: const WeeklyNextWeekCache(
            focusTitle: 'Consistency',
            focusDescription: 'Keep tracking regularly.',
            tips: [
              'Drink enough water.',
              'Stay active.',
            ],
          ),
          previousScore: 75,
        );

        final map = serializer.weeklyToMap(original);

        expect(map['periodStart'], isA<Timestamp>());
        expect(map['periodEnd'], isA<Timestamp>());
        expect(map['generatedAt'], isA<Timestamp>());
        expect(map['availableFrom'], isA<Timestamp>());

        final restored = serializer.weeklyFromMap(map);

        expect(restored.schemaVersion, original.schemaVersion);
        expect(restored.periodStart, original.periodStart);
        expect(restored.periodEnd, original.periodEnd);
        expect(restored.generatedAt, original.generatedAt);
        expect(restored.availableFrom, original.availableFrom);

        expect(restored.isAvailable, original.isAvailable);
        expect(restored.dismissed, original.dismissed);
        expect(restored.dismissedAt, original.dismissedAt);
        expect(restored.emailSentAt, original.emailSentAt);

        expect(restored.score, original.score);
        expect(restored.previousScore, original.previousScore);
        expect(restored.scoreChange, original.scoreChange);
        expect(restored.scoreLevel, original.scoreLevel);

        expect(
          restored.metrics.calorieTargetDays,
          original.metrics.calorieTargetDays,
        );

        expect(
          restored.metrics.calorieEvaluatedDays,
          original.metrics.calorieEvaluatedDays,
        );

        expect(
          restored.metrics.proteinTargetDays,
          original.metrics.proteinTargetDays,
        );

        expect(
          restored.metrics.activeDays,
          original.metrics.activeDays,
        );

        expect(
          restored.metrics.totalWorkoutMinutes,
          original.metrics.totalWorkoutMinutes,
        );

        expect(
          restored.reviewParagraphs,
          original.reviewParagraphs,
        );

        expect(
          restored.nextWeek.focusTitle,
          original.nextWeek.focusTitle,
        );

        expect(
          restored.nextWeek.tips,
          original.nextWeek.tips,
        );
      },
    );

    test(
      'monthly cache survives map round trip',
          () {
        const generator = MonthlyReportGenerator();

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
            'workoutMinutes':
            day % 3 == 0 ? 35 : 0,
            'workoutCount':
            day % 3 == 0 ? 1 : 0,
          });
        }

        final original = generator.generate(
          period: period,
          summaries: summaries,
          generatedAt: DateTime(2026, 9, 1, 2),
          availableFrom: DateTime(2026, 9, 1, 10),
          currentPlanActivatedAt:
          DateTime(2026, 8, 16),
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
            'Monthly review.',
          ],
          nextMonth: const MonthlyNextMonthCache(
            title: 'September Plan',
            mainFocus: 'Keep your routine stable.',
            tips: const [
              'Keep your current activity consistency.',
              'Focus more on protein consistency.',
              'Continue monitoring hydration.',
            ],
          ),
        );

        final map = serializer.monthlyToMap(original);

        expect(map['periodStart'], isA<Timestamp>());
        expect(map['periodEnd'], isA<Timestamp>());
        expect(map['generatedAt'], isA<Timestamp>());
        expect(map['availableFrom'], isA<Timestamp>());

        final restored = serializer.monthlyFromMap(map);

        expect(restored.schemaVersion, original.schemaVersion);
        expect(restored.periodStart, original.periodStart);
        expect(restored.periodEnd, original.periodEnd);
        expect(restored.generatedAt, original.generatedAt);
        expect(restored.availableFrom, original.availableFrom);

        expect(restored.isAvailable, original.isAvailable);
        expect(restored.dismissed, original.dismissed);
        expect(restored.dismissedAt, original.dismissedAt);
        expect(restored.emailSentAt, original.emailSentAt);

        expect(restored.score, original.score);
        expect(restored.previousScore, original.previousScore);
        expect(restored.scoreChange, original.scoreChange);
        expect(restored.scoreLevel, original.scoreLevel);

        expect(
          restored.consistency.trackingConsistency,
          closeTo(
            original.consistency.trackingConsistency,
            0.0001,
          ),
        );

        expect(
          restored.consistency.goalConsistency,
          closeTo(
            original.consistency.goalConsistency,
            0.0001,
          ),
        );

        expect(
          restored.changes.length,
          original.changes.length,
        );

        for (var i = 0; i < original.changes.length; i++) {
          expect(
            restored.changes[i].type,
            original.changes[i].type,
          );

          expect(
            restored.changes[i].difference,
            original.changes[i].difference,
          );

          expect(
            restored.changes[i].direction,
            original.changes[i].direction,
          );
        }

        expect(
          restored.weightPlan.startWeightKg,
          original.weightPlan.startWeightKg,
        );

        expect(
          restored.weightPlan.currentWeightKg,
          original.weightPlan.currentWeightKg,
        );

        expect(
          restored.weightPlan.monthlyTargetChangeKg,
          closeTo(
            original.weightPlan.monthlyTargetChangeKg!,
            0.0001,
          ),
        );

        expect(
          restored.weightPlan.progressAchievedPercent,
          original.weightPlan.progressAchievedPercent,
        );

        expect(
          restored.reviewParagraphs,
          original.reviewParagraphs,
        );

        expect(
          restored.nextMonth.title,
          original.nextMonth.title,
        );

        expect(
          restored.nextMonth.mainFocus,
          original.nextMonth.mainFocus,
        );

        expect(
          restored.comparisonBasis.trackingConsistency,
          closeTo(
            original.comparisonBasis.trackingConsistency,
            0.0001,
          ),
        );

        expect(
          restored.comparisonBasis.goalConsistency,
          closeTo(
            original.comparisonBasis.goalConsistency,
            0.0001,
          ),
        );

        expect(
          restored.comparisonBasis.calorieTargetDays,
          original.comparisonBasis.calorieTargetDays,
        );

        expect(
          restored.comparisonBasis.proteinTargetDays,
          original.comparisonBasis.proteinTargetDays,
        );

        expect(
          restored.comparisonBasis.hydrationTargetDays,
          original.comparisonBasis.hydrationTargetDays,
        );

        expect(
          restored.comparisonBasis.activeDays,
          original.comparisonBasis.activeDays,
        );
      },
    );
  });
}