import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class WeightDataSource {
  Future<WeightTrackingState> getTrackingState();

  Future<List<WeightEntry>> getEntries({
    required DateTime start,
    required DateTime end,
  });
}

class WeightRepository implements WeightDataSource {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  WeightRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<WeightCheckInState> getCheckInState({
    DateTime? now,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final currentTime = now ?? DateTime.now();
    final today = _dateOnly(currentTime);
    final weekStart = _weekStart(today);

    final userRef =
    _firestore.collection('users').doc(user.uid);

    final trackingRef =
    userRef.collection('weightTracking').doc('current');

    final results = await Future.wait([
      userRef.get(),
      trackingRef.get(),
    ]);

    final userData = results[0].data() ?? <String, dynamic>{};
    final trackingData =
        results[1].data() ?? <String, dynamic>{};

    final preferences =
        userData['userPreferences']
        as Map<String, dynamic>? ??
            <String, dynamic>{};

    final currentWeightKg =
        (trackingData['latestWeightKg'] as num?)
            ?.toDouble() ??
            (preferences['weight'] as num?)?.toDouble();

    final weightUnit =
    (preferences['weightUnit'] ?? 'kg')
        .toString()
        .toUpperCase();

    final lastPromptDate =
    _parseDate(trackingData['lastPromptDate']);

    final lastEntryWeekStart =
    _parseDate(trackingData['lastEntryWeekStart']);

    final alreadyEnteredThisWeek =
        lastEntryWeekStart != null &&
            _isSameDate(
              lastEntryWeekStart,
              weekStart,
            );

    final alreadyPromptedToday =
        lastPromptDate != null &&
            _isSameDate(
              lastPromptDate,
              today,
            );

    final afterCheckInTime =
        currentTime.hour >= 10;

    final shouldShow =
        afterCheckInTime &&
            !alreadyEnteredThisWeek &&
            !alreadyPromptedToday &&
            currentWeightKg != null &&
            currentWeightKg > 0;

    return WeightCheckInState(
      shouldShow: shouldShow,
      currentWeightKg: currentWeightKg,
      weightUnit: weightUnit,
      alreadyEnteredThisWeek:
      alreadyEnteredThisWeek,
      alreadyPromptedToday:
      alreadyPromptedToday,
      weekStart: weekStart,
    );
  }

  Future<void> markPromptShown({
    DateTime? now,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final currentTime = now ?? DateTime.now();
    final today = _dateOnly(currentTime);

    final trackingRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('weightTracking')
        .doc('current');

    await trackingRef.set({
      'lastPromptDate': _dateKey(today),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> saveWeight({
    required double weightKg,
    DateTime? now,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    if (weightKg <= 0) {
      throw ArgumentError('Weight must be greater than zero');
    }

    final currentTime = now ?? DateTime.now();
    final today = _dateOnly(currentTime);
    final weekStart = _weekStart(today);

    final roundedWeight =
    double.parse(weightKg.toStringAsFixed(1));

    final userRef =
    _firestore.collection('users').doc(user.uid);

    final entryRef =
    userRef
        .collection('weightEntries')
        .doc(_dateKey(today));

    final trackingRef =
    userRef
        .collection('weightTracking')
        .doc('current');

    final batch = _firestore.batch();

    batch.set(
      entryRef,
      {
        'weightKg': roundedWeight,
        'date': _dateKey(today),
        'weekStart': _dateKey(weekStart),
        'recordedAt':
        FieldValue.serverTimestamp(),
        'source': 'weeklyCheckIn',
      },
      SetOptions(merge: true),
    );

    batch.set(
      trackingRef,
      {
        'latestWeightKg': roundedWeight,
        'latestWeightDate': _dateKey(today),
        'lastEntryWeekStart':
        _dateKey(weekStart),
        'lastPromptDate': _dateKey(today),
        'updatedAt':
        FieldValue.serverTimestamp(),
      },
      SetOptions(merge: true),
    );

    batch.update(
      userRef,
      {
        'userPreferences.weight':
        roundedWeight,
        'updatedAt':
        FieldValue.serverTimestamp(),
      },
    );

    await batch.commit();
  }

  Future<WeightTrackingState> getTrackingState() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final trackingDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('weightTracking')
        .doc('current')
        .get();

    final data =
        trackingDoc.data() ?? <String, dynamic>{};

    return WeightTrackingState(
      latestWeightKg:
      (data['latestWeightKg'] as num?)
          ?.toDouble(),
      latestWeightDate: _parseDate(
        data['latestWeightDate'],
      ),
    );
  }

  Future<List<WeightEntry>> getEntries({
    required DateTime start,
    required DateTime end,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final startDate = _dateOnly(start);
    final endDate = _dateOnly(end);

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('weightEntries')
        .where(
      'date',
      isGreaterThanOrEqualTo:
      _dateKey(startDate),
    )
        .where(
      'date',
      isLessThanOrEqualTo:
      _dateKey(endDate),
    )
        .orderBy('date')
        .get();

    return snapshot.docs
        .map(
          (doc) => WeightEntry.fromMap(
        doc.data(),
      ),
    )
        .toList();
  }

  DateTime _weekStart(DateTime date) {
    final day = _dateOnly(date);

    return day.subtract(
      Duration(
        days: day.weekday - DateTime.monday,
      ),
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

  DateTime? _parseDate(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is Timestamp) {
      return _dateOnly(value.toDate());
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  bool _isSameDate(
      DateTime first,
      DateTime second,
      ) {
    return first.year == second.year &&
        first.month == second.month &&
        first.day == second.day;
  }
}

class WeightTrackingState {
  final double? latestWeightKg;
  final DateTime? latestWeightDate;

  const WeightTrackingState({
    required this.latestWeightKg,
    required this.latestWeightDate,
  });
}

class WeightCheckInState {
  final bool shouldShow;

  final double? currentWeightKg;
  final String weightUnit;

  final bool alreadyEnteredThisWeek;
  final bool alreadyPromptedToday;

  final DateTime weekStart;

  const WeightCheckInState({
    required this.shouldShow,
    required this.currentWeightKg,
    required this.weightUnit,
    required this.alreadyEnteredThisWeek,
    required this.alreadyPromptedToday,
    required this.weekStart,
  });
}

class WeightEntry {
  final double weightKg;
  final DateTime date;
  final DateTime weekStart;

  const WeightEntry({
    required this.weightKg,
    required this.date,
    required this.weekStart,
  });

  factory WeightEntry.fromMap(
      Map<String, dynamic> data,
      ) {
    final date =
    DateTime.parse(data['date'] as String);

    final weekStart =
    DateTime.parse(
      data['weekStart'] as String,
    );

    return WeightEntry(
      weightKg:
      (data['weightKg'] as num).toDouble(),
      date: date,
      weekStart: weekStart,
    );
  }
}