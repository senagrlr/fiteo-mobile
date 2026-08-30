import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:fiteo_myapp/features/profile/data/progress_date_utils.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_day_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/progress_month_data.dart';

class ProgressCacheService {
  static const int schemaVersion = 2;

  static const String freeCacheMode = 'free';
  static const String premiumCacheMode = 'premium';

  final FirebaseFirestore firestore;

  const ProgressCacheService({
    required this.firestore,
  });

  bool isFreeCache(Map<String, dynamic> cache) {
    return cache['cacheMode'] == freeCacheMode;
  }

  Future<Map<String, dynamic>> bootstrapFreeCache({
    required String uid,
    required DateTime today,
    required DateTime yesterday,
  }) async {
    final start = today.subtract(
      const Duration(days: 6),
    );

    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('dailySummaries')
        .where(
      'date',
      isGreaterThanOrEqualTo: progressDateKey(start),
    )
        .where(
      'date',
      isLessThanOrEqualTo: progressDateKey(yesterday),
    )
        .orderBy('date')
        .get();

    final days = <String, ProgressDayData>{};

    for (final doc in snapshot.docs) {
      days[doc.id] = ProgressDayData.fromSummary(
        doc.id,
        doc.data(),
      );
    }

    return {
      'cacheMode': freeCacheMode,
      'latestCachedDate': progressDateKey(yesterday),
      'daily': {
        for (final entry in days.entries)
          entry.key: entry.value.toMap(),
      },
      'monthly': <String, dynamic>{},
    };
  }

  Future<Map<String, dynamic>> bootstrapPremiumCache({
    required String uid,
    required DateTime today,
    required DateTime yesterday,
  }) async {
    final oldestMonth = DateTime(
      today.year,
      today.month - 11,
      1,
    );

    final snapshot = await firestore
        .collection('users')
        .doc(uid)
        .collection('dailySummaries')
        .where(
      'date',
      isGreaterThanOrEqualTo: progressDateKey(oldestMonth),
    )
        .where(
      'date',
      isLessThanOrEqualTo: progressDateKey(yesterday),
    )
        .orderBy('date')
        .get();

    final days = <String, ProgressDayData>{};
    final months = <String, ProgressMonthData>{};

    final dailyCutoff = today.subtract(
      const Duration(days: 90),
    );

    for (final doc in snapshot.docs) {
      final date = DateTime.parse(doc.id);

      final day = ProgressDayData.fromSummary(
        doc.id,
        doc.data(),
      );

      if (!date.isBefore(dailyCutoff)) {
        days[doc.id] = day;
      }

      _addDayToMonth(
        months,
        date,
        day,
      );
    }

    return {
      'cacheMode': premiumCacheMode,
      'latestCachedDate': progressDateKey(yesterday),
      'daily': {
        for (final entry in days.entries)
          entry.key: entry.value.toMap(),
      },
      'monthly': {
        for (final entry in months.entries)
          entry.key: entry.value.toMap(),
      },
    };
  }

  Future<ProgressCacheUpdateResult> catchUpFreeCache({
    required String uid,
    required Map<String, dynamic> cache,
    required DateTime today,
    required DateTime yesterday,
  }) async {
    final latest = DateTime.parse(
      cache['latestCachedDate'] as String,
    );

    final freeStart = today.subtract(
      const Duration(days: 6),
    );

    var changed = false;
    final days = readDays(cache);

    if (latest.isBefore(yesterday)) {
      if (latest.isBefore(freeStart)) {
        final snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('dailySummaries')
            .where(
          'date',
          isGreaterThanOrEqualTo:
          progressDateKey(freeStart),
        )
            .where(
          'date',
          isLessThanOrEqualTo:
          progressDateKey(yesterday),
        )
            .orderBy('date')
            .get();

        days.clear();

        for (final doc in snapshot.docs) {
          days[doc.id] = ProgressDayData.fromSummary(
            doc.id,
            doc.data(),
          );
        }
      } else {
        final start = latest.add(
          const Duration(days: 1),
        );

        final snapshot = await firestore
            .collection('users')
            .doc(uid)
            .collection('dailySummaries')
            .where(
          'date',
          isGreaterThanOrEqualTo:
          progressDateKey(start),
        )
            .where(
          'date',
          isLessThanOrEqualTo:
          progressDateKey(yesterday),
        )
            .orderBy('date')
            .get();

        for (final doc in snapshot.docs) {
          days[doc.id] = ProgressDayData.fromSummary(
            doc.id,
            doc.data(),
          );
        }
      }

      cache['latestCachedDate'] =
          progressDateKey(yesterday);

      changed = true;
    }

    if (_pruneFreeDays(days, today)) {
      changed = true;
    }

    final rawMonthly =
    cache['monthly'] as Map<String, dynamic>?;

    if (rawMonthly != null && rawMonthly.isNotEmpty) {
      changed = true;
    }

    if (cache['cacheMode'] != freeCacheMode) {
      changed = true;
    }

    cache['cacheMode'] = freeCacheMode;

    cache['daily'] = {
      for (final entry in days.entries)
        entry.key: entry.value.toMap(),
    };

    cache['monthly'] = <String, dynamic>{};

    return ProgressCacheUpdateResult(
      cache: cache,
      changed: changed,
    );
  }

  Future<ProgressCacheUpdateResult> catchUpPremiumCache({
    required String uid,
    required Map<String, dynamic> cache,
    required DateTime today,
    required DateTime yesterday,
  }) async {
    final latest = DateTime.parse(
      cache['latestCachedDate'] as String,
    );

    var changed = false;

    final days = readDays(cache);
    final months = readMonths(cache);

    if (latest.isBefore(yesterday)) {
      final oldestMonth = DateTime(
        today.year,
        today.month - 11,
        1,
      );

      var start = latest.add(
        const Duration(days: 1),
      );

      if (start.isBefore(oldestMonth)) {
        start = oldestMonth;
      }

      final snapshot = await firestore
          .collection('users')
          .doc(uid)
          .collection('dailySummaries')
          .where(
        'date',
        isGreaterThanOrEqualTo:
        progressDateKey(start),
      )
          .where(
        'date',
        isLessThanOrEqualTo:
        progressDateKey(yesterday),
      )
          .orderBy('date')
          .get();

      final dailyCutoff = today.subtract(
        const Duration(days: 90),
      );

      for (final doc in snapshot.docs) {
        final date = DateTime.parse(doc.id);

        final day = ProgressDayData.fromSummary(
          doc.id,
          doc.data(),
        );

        if (!date.isBefore(dailyCutoff)) {
          days[doc.id] = day;
        }

        _addDayToMonth(
          months,
          date,
          day,
        );
      }

      cache['latestCachedDate'] =
          progressDateKey(yesterday);

      changed = true;
    }

    if (_prunePremiumDays(days, today)) {
      changed = true;
    }

    if (_pruneMonths(months, today)) {
      changed = true;
    }

    if (cache['cacheMode'] != premiumCacheMode) {
      cache['cacheMode'] = premiumCacheMode;
      changed = true;
    }

    cache['daily'] = {
      for (final entry in days.entries)
        entry.key: entry.value.toMap(),
    };

    cache['monthly'] = {
      for (final entry in months.entries)
        entry.key: entry.value.toMap(),
    };

    return ProgressCacheUpdateResult(
      cache: cache,
      changed: changed,
    );
  }

  Map<String, ProgressDayData> readDays(
      Map<String, dynamic> cache,
      ) {
    final raw =
    cache['daily'] as Map<String, dynamic>?;

    if (raw == null) {
      return {};
    }

    return {
      for (final entry in raw.entries)
        entry.key: ProgressDayData.fromMap(
          entry.key,
          Map<String, dynamic>.from(
            entry.value as Map,
          ),
        ),
    };
  }

  Map<String, ProgressMonthData> readMonths(
      Map<String, dynamic> cache,
      ) {
    final raw =
    cache['monthly'] as Map<String, dynamic>?;

    if (raw == null) {
      return {};
    }

    return {
      for (final entry in raw.entries)
        entry.key: ProgressMonthData.fromMap(
          Map<String, dynamic>.from(
            entry.value as Map,
          ),
        ),
    };
  }

  void _addDayToMonth(
      Map<String, ProgressMonthData> months,
      DateTime date,
      ProgressDayData day,
      ) {
    final key = progressMonthKey(date);

    final month =
        months[key] ?? ProgressMonthData();

    month.addDay(day);
    months[key] = month;
  }

  bool _pruneFreeDays(
      Map<String, ProgressDayData> days,
      DateTime today,
      ) {
    final cutoff = today.subtract(
      const Duration(days: 6),
    );

    final oldKeys = days.keys.where((key) {
      return DateTime.parse(key).isBefore(cutoff);
    }).toList();

    for (final key in oldKeys) {
      days.remove(key);
    }

    return oldKeys.isNotEmpty;
  }

  bool _prunePremiumDays(
      Map<String, ProgressDayData> days,
      DateTime today,
      ) {
    final cutoff = today.subtract(
      const Duration(days: 90),
    );

    final oldKeys = days.keys.where((key) {
      return DateTime.parse(key).isBefore(cutoff);
    }).toList();

    for (final key in oldKeys) {
      days.remove(key);
    }

    return oldKeys.isNotEmpty;
  }

  bool _pruneMonths(
      Map<String, ProgressMonthData> months,
      DateTime today,
      ) {
    final oldest = DateTime(
      today.year,
      today.month - 11,
      1,
    );

    final oldKeys = months.keys.where((key) {
      final parts = key.split('-');

      final date = DateTime(
        int.parse(parts[0]),
        int.parse(parts[1]),
        1,
      );

      return date.isBefore(oldest);
    }).toList();

    for (final key in oldKeys) {
      months.remove(key);
    }

    return oldKeys.isNotEmpty;
  }
}

class ProgressCacheUpdateResult {
  final Map<String, dynamic> cache;
  final bool changed;

  const ProgressCacheUpdateResult({
    required this.cache,
    required this.changed,
  });
}