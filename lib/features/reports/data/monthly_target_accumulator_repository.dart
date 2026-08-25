import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/features/reports/data/monthly_target_accumulator_calculator.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_target_accumulator.dart';

class MonthlyTargetAccumulatorRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static const MonthlyTargetAccumulatorCalculator _calculator =
  MonthlyTargetAccumulatorCalculator();

  Future<void> closeCurrentPlanSegment({
    required DateTime newPlanActivatedAt,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final activationDate = _dateOnly(newPlanActivatedAt);

    final userRef = _firestore.collection('users').doc(user.uid);

    final trackingRef = userRef
        .collection('planTracking')
        .doc('current');

    final accumulatorRef = userRef
        .collection('reportState')
        .doc('monthlyTarget');

    final results = await Future.wait([
      trackingRef.get(),
      accumulatorRef.get(),
    ]);

    final trackingDoc = results[0];
    final accumulatorDoc = results[1];

    if (!trackingDoc.exists) {
      return;
    }

    final trackingData =
        trackingDoc.data() ?? <String, dynamic>{};

    final oldExpectedRate =
    (trackingData['expectedWeeklyWeightChangeKg'] as num?)
        ?.toDouble();

    final oldPlanActivatedAt =
    _parseDate(trackingData['planActivatedAt'] as String?);

    if (oldExpectedRate == null ||
        oldPlanActivatedAt == null) {
      return;
    }

    final monthStart = DateTime(
      activationDate.year,
      activationDate.month,
      1,
    );

    final expectedMonthKey = _monthKey(activationDate);

    final accumulatorData =
        accumulatorDoc.data() ?? <String, dynamic>{};

    final storedMonthKey =
    accumulatorData['monthKey'] as String?;

    final sameMonth =
        storedMonthKey == expectedMonthKey;

    final previousAccrued = sameMonth
        ? (accumulatorData['accruedExpectedChangeKg'] as num?)
        ?.toDouble() ??
        0
        : 0.0;

    final previousAccruedThrough = sameMonth
        ? _parseDate(
      accumulatorData['accruedThrough'] as String?,
    )
        : null;

    final oldSegmentEnd = activationDate.subtract(
      const Duration(days: 1),
    );

    final oldSegmentStart = _calculator.segmentStart(
      monthStart: monthStart,
      planActivatedAt: oldPlanActivatedAt,
      accruedThrough: previousAccruedThrough,
    );

    final contribution =
    _calculator.calculateSegmentContribution(
      expectedWeeklyWeightChangeKg: oldExpectedRate,
      segmentStart: oldSegmentStart,
      segmentEnd: oldSegmentEnd,
    );

    if (contribution == 0 &&
        oldSegmentEnd.isBefore(oldSegmentStart)) {
      return;
    }

    await accumulatorRef.set({
      'monthKey': expectedMonthKey,
      'accruedExpectedChangeKg':
      previousAccrued + contribution,
      'accruedThrough': _dateKey(oldSegmentEnd),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  Future<MonthlyTargetAccumulator?> loadCurrentMonth() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = _dateOnly(DateTime.now());

    final ref = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('reportState')
        .doc('monthlyTarget');

    final doc = await ref.get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data() ?? <String, dynamic>{};

    final monthKey = data['monthKey'] as String?;

    if (monthKey == null ||
        monthKey != _monthKey(today)) {
      return null;
    }

    return MonthlyTargetAccumulator(
      monthKey: monthKey,
      accruedExpectedChangeKg:
      (data['accruedExpectedChangeKg'] as num?)
          ?.toDouble() ??
          0,
      accruedThrough:
      _parseDate(data['accruedThrough'] as String?),
    );
  }

  DateTime _dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  String _monthKey(DateTime date) {
    return '${date.year}-'
        '${date.month.toString().padLeft(2, '0')}';
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