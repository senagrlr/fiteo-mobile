import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:fiteo_myapp/firebase_options.dart';

import 'package:fiteo_myapp/features/reports/data/monthly_report_generator.dart';
import 'package:fiteo_myapp/features/reports/data/report_period_resolver.dart';
import 'package:fiteo_myapp/features/reports/data/report_repository.dart';
import 'package:fiteo_myapp/features/reports/data/weekly_report_generator.dart';

import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late FirebaseAuth auth;
  late FirebaseFirestore firestore;
  late ReportRepository repository;

  setUpAll(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;

    await auth.useAuthEmulator(
      '10.0.2.2',
      9099,
    );

    firestore.useFirestoreEmulator(
      '10.0.2.2',
      8080,
    );

    await auth.signOut();

    const testEmail = 'report-integration-test@fiteo.test';
    const testPassword = 'Test123456!';

    try {
      await auth.createUserWithEmailAndPassword(
        email: testEmail,
        password: testPassword,
      );
    } on FirebaseAuthException catch (error) {
      if (error.code == 'email-already-in-use') {
        await auth.signInWithEmailAndPassword(
          email: testEmail,
          password: testPassword,
        );
      } else {
        rethrow;
      }
    }

    repository = ReportRepository(
      auth: auth,
      firestore: firestore,
    );
  });

  testWidgets(
    'weekly report can be written to and read from Firestore emulator',
        (tester) async {
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
        weightPlan: const WeeklyWeightPlanCache(
          startWeightKg: 80,
          currentWeightKg: 79.5,
          planStatus: 'onTrack',
          planStatusDescription: 'On track',
        ),
        reviewParagraphs: const [
          'Weekly integration review.',
        ],
        nextWeek: const WeeklyNextWeekCache(
          focusTitle: 'Consistency',
          focusDescription: 'Keep tracking.',
          tips: [
            'Stay hydrated.',
            'Stay active.',
          ],
        ),
        previousScore: 75,
      );

      await repository.saveWeeklyReport(original);

      final restored =
      await repository.getWeeklyReport();

      expect(restored, isNotNull);

      final restoredCache = restored!;

      expect(
        restoredCache.score,
        original.score,
      );

      expect(
        restoredCache.previousScore,
        original.previousScore,
      );

      expect(
        restoredCache.scoreChange,
        original.scoreChange,
      );

      expect(
        restoredCache.periodStart,
        original.periodStart,
      );

      expect(
        restoredCache.periodEnd,
        original.periodEnd,
      );

      expect(
        restoredCache.weightPlan.startWeightKg,
        80,
      );

      expect(
        restoredCache.weightPlan.currentWeightKg,
        79.5,
      );
    },
  );

  testWidgets(
    'monthly report can be written to and read from Firestore emulator',
        (tester) async {
      const generator = MonthlyReportGenerator();

      final period = ReportPeriod(
        calendarStart: DateTime(2026, 8, 1),
        calendarEnd: DateTime(2026, 8, 31),
        effectiveStart: DateTime(2026, 8, 1),
        effectiveEnd: DateTime(2026, 8, 31),
      );

      final summaries =
      <Map<String, dynamic>>[];

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
        availableFrom:
        DateTime(2026, 9, 1, 10),
        currentPlanActivatedAt:
        DateTime(2026, 8, 16),
        currentExpectedWeeklyWeightChangeKg:
        -0.3,
        accumulator: MonthlyTargetAccumulator(
          monthKey: '2026-08',
          accruedExpectedChangeKg: -1.0,
          accruedThrough:
          DateTime(2026, 8, 15),
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
          'Monthly integration review.',
        ],
        nextMonth:
        const MonthlyNextMonthCache(
          title: 'September Plan',
          mainFocus:
          'Keep your routine stable.',
          keepDoing:
          'Continue consistent tracking.',
          improve: 'Increase activity.',
          watch: 'Stay hydrated.',
        ),
      );

      await repository.saveMonthlyReport(
        original,
      );

      final restored =
      await repository.getMonthlyReport();

      expect(restored, isNotNull);

      final restoredCache = restored!;

      expect(
        restoredCache.score,
        original.score,
      );

      expect(
        restoredCache.previousScore,
        original.previousScore,
      );

      expect(
        restoredCache.scoreChange,
        original.scoreChange,
      );

      expect(
        restoredCache.weightPlan.monthlyTargetChangeKg,
        closeTo(
          original.weightPlan.monthlyTargetChangeKg!,
          0.0001,
        ),
      );

      expect(
        restoredCache.weightPlan.progressAchievedPercent,
        original.weightPlan.progressAchievedPercent,
      );

      expect(
        restoredCache.changes.length,
        original.changes.length,
      );

      expect(
        restoredCache.nextMonth.title,
        'September Plan',
      );
    },
  );
}