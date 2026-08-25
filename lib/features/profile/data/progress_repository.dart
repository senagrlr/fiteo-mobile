import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/features/profile/data/progress_cache_service.dart';
import 'package:fiteo_myapp/features/profile/data/progress_date_utils.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_day_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_month_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_snapshot.dart';

class ProgressRepository {
  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  late final ProgressCacheService
  _cacheService =
  ProgressCacheService(
    firestore: _firestore,
  );

  Future<ProgressSnapshot>
  loadProgress() async {
    final user =
        _auth.currentUser;

    if (user == null) {
      throw Exception(
        'User not logged in',
      );
    }

    final today = progressDateOnly(DateTime.now(),);
    final yesterday = today.subtract(const Duration(days: 1));
    final creationTime = user.metadata.creationTime;

    final trackingStartDate = creationTime == null
        ? today
        : progressDateOnly(creationTime);

    final userRef =
    _firestore
        .collection('users')
        .doc(user.uid);

    final cacheRef =
    userRef
        .collection('progressCache')
        .doc('current');

    final todayRef =
    userRef
        .collection('dailySummaries')
        .doc(
      progressDateKey(today),
    );

    // Cache ve bugün aynı anda okunur.
    final results =
    await Future.wait([
      cacheRef.get(),
      todayRef.get(),
    ]);

    final cacheDoc =
    results[0]
    as DocumentSnapshot<
        Map<String, dynamic>>;

    final todayDoc =
    results[1]
    as DocumentSnapshot<
        Map<String, dynamic>>;

    Map<String, dynamic> cache =
    Map<String, dynamic>.from(
      cacheDoc.data() ?? {},
    );

    var shouldWriteCache = false;

    if (cache['schemaVersion'] !=
        ProgressCacheService
            .schemaVersion ||
        cache['latestCachedDate'] ==
            null) {
      cache =
      await _cacheService
          .bootstrapCache(
        uid: user.uid,
        today: today,
        yesterday: yesterday,
      );

      shouldWriteCache = true;
    } else {
      final result =
      await _cacheService
          .catchUpCache(
        uid: user.uid,
        cache: cache,
        today: today,
        yesterday: yesterday,
      );

      cache = result.cache;

      shouldWriteCache =
          result.changed;
    }

    if (shouldWriteCache) {
      await cacheRef.set({
        ...cache,

        'schemaVersion':
        ProgressCacheService
            .schemaVersion,

        'updatedAt':
        FieldValue
            .serverTimestamp(),
      });
    }

    final days = _cacheService.readDays(cache);
    final months = _cacheService.readMonths(cache);

    // Bugün cache'e yazılmaz.
    // Canlı dailySummary kullanılır.
    final todayData = ProgressDayData.fromSummary(
      progressDateKey(today),
      todayDoc.data() ?? {},
    );

    days[progressDateKey(today)] = todayData;

    // Bugünü yalnız RAM'deki
    // güncel ay aggregate'ına ekliyoruz.
    final currentMonthKey = progressMonthKey(today);
    final currentMonth = months[currentMonthKey] ?? ProgressMonthData();

    currentMonth.addDay(todayData,);

    months[currentMonthKey] = currentMonth;

    return ProgressSnapshot(
      days: days,
      months: months,
      trackingStartDate: trackingStartDate,
    );
  }
}