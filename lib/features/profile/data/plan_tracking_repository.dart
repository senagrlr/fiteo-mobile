import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/features/profile/data/plan_tracking_calculator.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_tracking_stats.dart';
import 'package:fiteo_myapp/features/profile/data/adherence_calculator.dart';
import 'package:fiteo_myapp/features/reports/data/monthly_target_accumulator_repository.dart';

class PlanTrackingRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final PlanTrackingCalculator _calculator =
  const PlanTrackingCalculator();

  final AdherenceCalculator _adherenceCalculator =
  const AdherenceCalculator();

  final MonthlyTargetAccumulatorRepository _monthlyTargetAccumulatorRepository =
  MonthlyTargetAccumulatorRepository();

  static const int schemaVersion = 1;

  Future<void> initializeNewPlan({
    required double expectedWeeklyWeightChangeKg,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = _dateOnly(DateTime.now());

    await _monthlyTargetAccumulatorRepository
        .closeCurrentPlanSegment(
      newPlanActivatedAt: today,
    );

    final userRef = _firestore.collection('users').doc(user.uid);
    final trackingRef = userRef.collection('planTracking').doc('current');

    final userDoc = await userRef.get();
    final userData = userDoc.data() ?? <String, dynamic>{};

    final userPreferences =
        userData['userPreferences'] as Map<String, dynamic>? ?? {};

    final currentWeight =
    (userPreferences['weight'] as num?)?.toDouble();

    final targetWeight =
    (userPreferences['targetWeight'] as num?)?.toDouble();

    if (currentWeight == null || currentWeight <= 0) {
      throw Exception('Missing current weight');
    }

    if (targetWeight == null || targetWeight <= 0) {
      throw Exception('Missing target weight');
    }

    final cache = _createInitialCache(
      userData: userData,
      currentWeight: currentWeight,
      targetWeight: targetWeight,
      expectedWeeklyWeightChangeKg: expectedWeeklyWeightChangeKg,
      today: today,
    );

    await trackingRef.set({
      ...cache,
      'schemaVersion': schemaVersion,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<PlanTrackingStats> loadPlanTracking() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = _dateOnly(DateTime.now());
    final yesterday = today.subtract(const Duration(days: 1));

    final userRef = _firestore.collection('users').doc(user.uid);

    final trackingRef = userRef.collection('planTracking').doc('current');

    final results = await Future.wait([
      userRef.get(),
      trackingRef.get(),
    ]);

    final userDoc = results[0];
    final trackingDoc = results[1];

    final userData = userDoc.data() ?? <String, dynamic>{};
    final trackingData = trackingDoc.data() ?? <String, dynamic>{};

    final userPreferences =
        userData['userPreferences'] as Map<String, dynamic>? ?? {};

    final currentWeight =
    (userPreferences['weight'] as num?)?.toDouble();

    final targetWeight =
    (userPreferences['targetWeight'] as num?)?.toDouble();

    final weightUnit =
    (userPreferences['weightUnit'] ?? 'kg').toString().toLowerCase();

    if (currentWeight == null || currentWeight <= 0) {
      throw Exception('Missing current weight');
    }

    if (targetWeight == null || targetWeight <= 0) {
      throw Exception('Missing target weight');
    }

    Map<String, dynamic> cache;

    final needsBootstrap =
        trackingData['schemaVersion'] != schemaVersion ||
            trackingData['planActivatedAt'] == null;

    if (needsBootstrap) {
      cache = _createInitialCache(
        userData: userData,
        currentWeight: currentWeight,
        targetWeight: targetWeight,
        expectedWeeklyWeightChangeKg: 0,
        today: today,
      );

      await trackingRef.set({
        ...cache,
        'schemaVersion': schemaVersion,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } else {
      cache = Map<String, dynamic>.from(trackingData);

      final changed = await _catchUpDailyTracking(
        uid: user.uid,
        cache: cache,
        yesterday: yesterday,
      );

      if (changed) {
        await trackingRef.set({
          ...cache,
          'schemaVersion': schemaVersion,
          'updatedAt': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));
      }
    }

    return _statsFromCache(
      cache,
      targetWeight,
      weightUnit,
    );
  }

  Map<String, dynamic> _createInitialCache({
    required Map<String, dynamic> userData,
    required double currentWeight,
    required double targetWeight,
    required double expectedWeeklyWeightChangeKg,
    required DateTime today,
  }) {
    final nutritionPlan =
        userData['nutritionPlan'] as Map<String, dynamic>? ?? {};

    final createdAt = nutritionPlan['createdAt'];

    final planActivatedAt = createdAt is Timestamp
        ? _dateOnly(createdAt.toDate())
        : today;

    final initialEstimatedGoalDate =
    _calculator.calculateInitialEstimatedGoalDate(
      planStartWeight: currentWeight,
      targetWeight: targetWeight,
      expectedWeeklyWeightChangeKg: expectedWeeklyWeightChangeKg,
      planActivatedAt: planActivatedAt,
    );

    return {
      'schemaVersion': schemaVersion,

      'planActivatedAt': _dateKey(planActivatedAt),
      'lastProcessedDate': null,

      'planStartWeight': currentWeight,
      'expectedWeeklyWeightChangeKg':
      expectedWeeklyWeightChangeKg,

      'planEligibleDays': 0,
      'calorieTrackedDays': 0,
      'calorieAdherenceSum': 0.0,

      'weightEntryCount': 0,
      'latestWeight': null,
      'latestWeightDate': null,
      'actualWeeklyWeightChangeKg': null,

      'progressRatio': null,

      'estimatedGoalDate': initialEstimatedGoalDate == null
          ? null
          : _dateKey(initialEstimatedGoalDate),

      'projectionDifferenceDays': null,

      'planStatus': PlanStatus.notEnoughData.name,

      'aiNote': null,
      'aiNoteDate': null,
    };
  }

  Future<bool> _catchUpDailyTracking({
    required String uid,
    required Map<String, dynamic> cache,
    required DateTime yesterday,
  }) async {
    final planActivatedAt =
    _parseDate(cache['planActivatedAt'] as String?);

    if (planActivatedAt == null) return false;

    final lastProcessedDate =
    _parseDate(cache['lastProcessedDate'] as String?);

    var nextDate = lastProcessedDate == null
        ? planActivatedAt
        : lastProcessedDate.add(const Duration(days: 1));

    if (nextDate.isAfter(yesterday)) {
      return false;
    }

    final snapshot = await _firestore
        .collection('users')
        .doc(uid)
        .collection('dailySummaries')
        .where(
      'date',
      isGreaterThanOrEqualTo: _dateKey(nextDate),
    )
        .where(
      'date',
      isLessThanOrEqualTo: _dateKey(yesterday),
    )
        .get();

    final summaries = <String, Map<String, dynamic>>{};

    for (final doc in snapshot.docs) {
      final data = doc.data();
      final date = data['date'] as String?;

      if (date != null) {
        summaries[date] = data;
      }
    }

    var planEligibleDays =
        (cache['planEligibleDays'] as num?)?.round() ?? 0;

    var calorieTrackedDays =
        (cache['calorieTrackedDays'] as num?)?.round() ?? 0;

    var calorieAdherenceSum =
        (cache['calorieAdherenceSum'] as num?)?.toDouble() ?? 0;

    while (!nextDate.isAfter(yesterday)) {
      planEligibleDays++;

      final summary = summaries[_dateKey(nextDate)];

      if (summary != null) {
        final netCalories =
            (summary['netCalories'] as num?)?.toDouble() ?? 0;

        final protein =
            (summary['protein'] as num?)?.toDouble() ?? 0;

        final carbs =
            (summary['carbs'] as num?)?.toDouble() ?? 0;

        final fat =
            (summary['fats'] as num?)?.toDouble() ?? 0;

        final hasNutritionTracking =
            netCalories != 0 ||
                protein > 0 ||
                carbs > 0 ||
                fat > 0;

        if (hasNutritionTracking) {
          final dailyAdherence =
          _adherenceCalculator.calorieAdherence(
            netCalories: netCalories,
            calorieGoal:
            (summary['calorieGoal'] as num?)?.toDouble(),
          );

          if (dailyAdherence != null) {
            calorieTrackedDays++;
            calorieAdherenceSum += dailyAdherence;
          }
        }
      }

      cache['lastProcessedDate'] = _dateKey(nextDate);

      nextDate = nextDate.add(
        const Duration(days: 1),
      );
    }

    cache['planEligibleDays'] = planEligibleDays;
    cache['calorieTrackedDays'] = calorieTrackedDays;
    cache['calorieAdherenceSum'] = calorieAdherenceSum;

    final trackingConsistency = planEligibleDays <= 0
        ? 0.0
        : calorieTrackedDays / planEligibleDays * 100;

    final calorieAdherence = calorieTrackedDays <= 0
        ? 0.0
        : calorieAdherenceSum / calorieTrackedDays;

    final status = _calculator.calculateStatus(
      weightEntryCount:
      (cache['weightEntryCount'] as num?)?.round() ?? 0,
      observationDays: planEligibleDays,
      calorieAdherence: calorieAdherence,
      trackingConsistency: trackingConsistency,
      progressRatio:
      (cache['progressRatio'] as num?)?.toDouble(),
      actualWeeklyWeightChangeKg:
      (cache['actualWeeklyWeightChangeKg'] as num?)
          ?.toDouble(),
      expectedWeeklyWeightChangeKg:
      (cache['expectedWeeklyWeightChangeKg'] as num?)
          ?.toDouble() ??
          0,
    );

    cache['planStatus'] = status.name;

    return true;
  }

  PlanTrackingStats _statsFromCache(
      Map<String, dynamic> cache,
      double targetWeight,
      String weightUnit,
      ) {
    final activatedAt =
    _parseDate(cache['planActivatedAt'] as String?);

    if (activatedAt == null) {
      throw Exception('Missing plan activation date');
    }

    return PlanTrackingStats(
      planActivatedAt: activatedAt,
      lastProcessedDate:
      _parseDate(cache['lastProcessedDate'] as String?),
      planStartWeight:
      (cache['planStartWeight'] as num?)?.toDouble() ?? 0,
      targetWeight: targetWeight,
      weightUnit: weightUnit,
      expectedWeeklyWeightChangeKg:
      (cache['expectedWeeklyWeightChangeKg'] as num?)
          ?.toDouble() ??
          0,
      planEligibleDays:
      (cache['planEligibleDays'] as num?)?.round() ?? 0,
      calorieTrackedDays:
      (cache['calorieTrackedDays'] as num?)?.round() ?? 0,
      calorieAdherenceSum:
      (cache['calorieAdherenceSum'] as num?)?.toDouble() ??
          0,
      weightEntryCount:
      (cache['weightEntryCount'] as num?)?.round() ?? 0,
      latestWeight:
      (cache['latestWeight'] as num?)?.toDouble(),
      latestWeightDate:
      _parseDate(cache['latestWeightDate'] as String?),
      actualWeeklyWeightChangeKg:
      (cache['actualWeeklyWeightChangeKg'] as num?)
          ?.toDouble(),
      progressRatio:
      (cache['progressRatio'] as num?)?.toDouble(),
      estimatedGoalDate:
      _parseDate(cache['estimatedGoalDate'] as String?),
      projectionDifferenceDays:
      (cache['projectionDifferenceDays'] as num?)?.round(),
      planStatus: _parsePlanStatus(
        cache['planStatus'] as String?,
      ),
      aiNote: cache['aiNote'] as String?,
      aiNoteDate:
      _parseDate(cache['aiNoteDate'] as String?),
    );
  }

  PlanStatus _parsePlanStatus(String? value) {
    for (final status in PlanStatus.values) {
      if (status.name == value) {
        return status;
      }
    }

    return PlanStatus.notEnoughData;
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(
      date.year,
      date.month,
      date.day,
    );
  }

  String _dateKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}-'
        '${date.day.toString().padLeft(2, '0')}';
  }

  DateTime? _parseDate(String? value) {
    if (value == null) return null;

    return DateTime.tryParse(value);
  }
}