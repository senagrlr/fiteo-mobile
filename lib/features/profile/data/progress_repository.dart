import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/features/profile/data/progress_cache_service.dart';
import 'package:fiteo_myapp/features/profile/data/progress_date_utils.dart';
import 'package:fiteo_myapp/features/profile/data/weight_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_day_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_month_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_snapshot.dart';

class ProgressRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final WeightRepository _weightRepository =
  WeightRepository();

  late final ProgressCacheService _cacheService =
  ProgressCacheService(
    firestore: _firestore,
  );

  Future<ProgressSnapshot> loadProgress({
    required bool isPremium,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return isPremium
        ? _loadPremiumProgress(user)
        : _loadFreeProgress(user);
  }

  Future<ProgressSnapshot> _loadFreeProgress(
      User user,
      ) async {
    final today = progressDateOnly(DateTime.now());
    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final creationTime = user.metadata.creationTime;

    final trackingStartDate = creationTime == null
        ? today
        : progressDateOnly(creationTime);

    final userRef = _firestore
        .collection('users')
        .doc(user.uid);

    final cacheRef = userRef
        .collection('progressCache')
        .doc('current');

    final todayRef = userRef
        .collection('dailySummaries')
        .doc(progressDateKey(today));

    final results = await Future.wait([
      cacheRef.get(),
      todayRef.get(),
    ]);

    final cacheDoc = results[0]
    as DocumentSnapshot<Map<String, dynamic>>;

    final todayDoc = results[1]
    as DocumentSnapshot<Map<String, dynamic>>;

    Map<String, dynamic> cache =
    Map<String, dynamic>.from(
      cacheDoc.data() ?? {},
    );

    var shouldWriteCache = false;

    if (cache['schemaVersion'] !=
        ProgressCacheService.schemaVersion ||
        cache['latestCachedDate'] == null) {
      cache = await _cacheService.bootstrapFreeCache(
        uid: user.uid,
        today: today,
        yesterday: yesterday,
      );

      shouldWriteCache = true;
    } else {
      final result =
      await _cacheService.catchUpFreeCache(
        uid: user.uid,
        cache: cache,
        today: today,
        yesterday: yesterday,
      );

      cache = result.cache;
      shouldWriteCache = result.changed;
    }

    if (shouldWriteCache) {
      await cacheRef.set({
        ...cache,
        'schemaVersion':
        ProgressCacheService.schemaVersion,
        'updatedAt':
        FieldValue.serverTimestamp(),
      });
    }

    final days = _cacheService.readDays(cache);

    final todayData = ProgressDayData.fromSummary(
      progressDateKey(today),
      todayDoc.data() ?? {},
    );

    days[progressDateKey(today)] = todayData;

    return ProgressSnapshot(
      days: days,
      months: const {},
      trackingStartDate: trackingStartDate,
      weightEntries: const [],
      targetWeightKg: null,
      weightUnit: 'kg',
    );
  }

  Future<ProgressSnapshot> _loadPremiumProgress(
      User user,
      ) async {
    final today = progressDateOnly(DateTime.now());
    final yesterday = today.subtract(
      const Duration(days: 1),
    );

    final creationTime = user.metadata.creationTime;

    final weightStartDate = today.subtract(
      const Duration(days: 364),
    );

    final trackingStartDate = creationTime == null
        ? today
        : progressDateOnly(creationTime);

    final userRef = _firestore
        .collection('users')
        .doc(user.uid);

    final cacheRef = userRef
        .collection('progressCache')
        .doc('current');

    final todayRef = userRef
        .collection('dailySummaries')
        .doc(progressDateKey(today));

    final results = await Future.wait([
      cacheRef.get(),
      todayRef.get(),
      userRef.get(),
      _weightRepository.getEntries(
        start: weightStartDate,
        end: today,
      ),
    ]);

    final cacheDoc = results[0]
    as DocumentSnapshot<Map<String, dynamic>>;

    final todayDoc = results[1]
    as DocumentSnapshot<Map<String, dynamic>>;

    final userDoc = results[2]
    as DocumentSnapshot<Map<String, dynamic>>;

    final weightEntries =
    results[3] as List<WeightEntry>;

    final userData =
        userDoc.data() ?? <String, dynamic>{};

    final preferences =
        userData['userPreferences']
        as Map<String, dynamic>? ??
            <String, dynamic>{};

    final targetWeightKg =
    (preferences['targetWeight'] as num?)
        ?.toDouble();

    final weightUnit =
    (preferences['weightUnit'] ?? 'kg')
        .toString()
        .toLowerCase();

    Map<String, dynamic> cache =
    Map<String, dynamic>.from(
      cacheDoc.data() ?? {},
    );

    var shouldWriteCache = false;

    final isFreeCache =
    _cacheService.isFreeCache(cache);

    if (cache['schemaVersion'] !=
        ProgressCacheService.schemaVersion ||
        cache['latestCachedDate'] == null ||
        isFreeCache) {
      cache =
      await _cacheService.bootstrapPremiumCache(
        uid: user.uid,
        today: today,
        yesterday: yesterday,
      );

      shouldWriteCache = true;
    } else {
      final result =
      await _cacheService.catchUpPremiumCache(
        uid: user.uid,
        cache: cache,
        today: today,
        yesterday: yesterday,
      );

      cache = result.cache;
      shouldWriteCache = result.changed;
    }

    if (shouldWriteCache) {
      await cacheRef.set({
        ...cache,
        'schemaVersion':
        ProgressCacheService.schemaVersion,
        'updatedAt':
        FieldValue.serverTimestamp(),
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

    // Bugün yalnız RAM'deki güncel
    // ay aggregate'ına eklenir.
    final currentMonthKey =
    progressMonthKey(today);

    final currentMonth =
        months[currentMonthKey] ??
            ProgressMonthData();

    currentMonth.addDay(todayData);
    months[currentMonthKey] = currentMonth;

    return ProgressSnapshot(
      days: days,
      months: months,
      trackingStartDate: trackingStartDate,
      weightEntries: weightEntries,
      targetWeightKg: targetWeightKg,
      weightUnit: weightUnit,
    );
  }
}