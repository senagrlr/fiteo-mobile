import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/features/profile/data/fiteo_score_calculator.dart';
import 'package:fiteo_myapp/features/profile/data/overview_day_processor.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';

class OverviewRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final OverviewDayProcessor _processor =
  const OverviewDayProcessor();

  final FiteoScoreCalculator _scoreCalculator =
  const FiteoScoreCalculator();

  Future<OverviewStats> loadOverview() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = _dateOnly(DateTime.now());
    final yesterday =
    today.subtract(const Duration(days: 1));

    final todayKey = _dateKey(today);

    final userRef =
    _firestore.collection('users').doc(user.uid);

    final statsRef =
    userRef.collection('overviewStats').doc('current');

    final statsDoc = await statsRef.get();

    final stats = OverviewStats.fromMap(
      statsDoc.data() ?? {},
    );

    final creationTime =
        user.metadata.creationTime;

    final accountStart = creationTime == null
        ? today
        : _dateOnly(creationTime);

    final firstProcessDate =
    stats.lastProcessedDate == null
        ? accountStart
        : DateTime.parse(stats.lastProcessedDate!)
        .add(const Duration(days: 1));

    var stateChanged = false;

    if (!firstProcessDate.isAfter(yesterday)) {
      final snapshot = await userRef
          .collection('dailySummaries')
          .where(
        'date',
        isGreaterThanOrEqualTo:
        _dateKey(firstProcessDate),
      )
          .where(
        'date',
        isLessThanOrEqualTo:
        _dateKey(yesterday),
      )
          .orderBy('date')
          .get();

      final summariesByDate = {
        for (final doc in snapshot.docs)
          doc.id: doc.data(),
      };

      var day = firstProcessDate;

      while (!day.isAfter(yesterday)) {
        final key = _dateKey(day);

        _processor.processDay(
          stats: stats,
          date: key,
          data: summariesByDate[key] ?? {},
        );

        day = day.add(const Duration(days: 1));
      }

      stateChanged = true;
    }

    if (stats.fiteoScoreDate != todayKey) {
      final scoreDays = await _loadLast30DaysForScore(
        userRef: userRef,
        today: today,
        accountStart: accountStart,
      );

      stats.fiteoScore =
          _scoreCalculator.calculate(
            days: scoreDays.days,
            effectiveDays: scoreDays.effectiveDays,
          );

      stats.fiteoScoreDate = todayKey;
      stateChanged = true;
    }

    if (stateChanged) {
      await statsRef.set({
        ...stats.toMap(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    }

    return stats;
  }

  Future<void> saveAiNote({
    required String note,
    required String date,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('overviewStats')
        .doc('current')
        .set({
      'aiNote': note,
      'aiNoteDate': date,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<_OverviewScoreDays> _loadLast30DaysForScore({
    required DocumentReference<Map<String, dynamic>> userRef,
    required DateTime today,
    required DateTime accountStart,
  }) async {
    final requestedStart =
    today.subtract(const Duration(days: 30));

    final start =
    accountStart.isAfter(requestedStart)
        ? accountStart
        : requestedStart;

    final yesterday =
    today.subtract(const Duration(days: 1));

    if (start.isAfter(yesterday)) {
      return const _OverviewScoreDays(
        days: [],
        effectiveDays: 0,
      );
    }

    final snapshot = await userRef
        .collection('dailySummaries')
        .where(
      'date',
      isGreaterThanOrEqualTo: _dateKey(start),
    )
        .where(
      'date',
      isLessThanOrEqualTo: _dateKey(yesterday),
    )
        .orderBy('date')
        .get();

    final summariesByDate = {
      for (final doc in snapshot.docs)
        doc.id: doc.data(),
    };

    final days = <Map<String, dynamic>>[];

    var day = start;

    while (!day.isAfter(yesterday)) {
      final key = _dateKey(day);

      days.add(
        summariesByDate[key] ?? <String, dynamic>{},
      );

      day = day.add(const Duration(days: 1));
    }

    return _OverviewScoreDays(
      days: days,
      effectiveDays: days.length,
    );
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
}

class _OverviewScoreDays {
  final List<Map<String, dynamic>> days;
  final int effectiveDays;

  const _OverviewScoreDays({
    required this.days,
    required this.effectiveDays,
  });
}