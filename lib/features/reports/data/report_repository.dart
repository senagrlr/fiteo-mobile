import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/features/reports/models/previous_report_snapshot.dart';
import 'package:fiteo_myapp/features/reports/models/report_comparison_basis.dart';
import 'package:fiteo_myapp/features/reports/data/report_cache_serializer.dart';
import 'package:fiteo_myapp/features/reports/models/monthly_report_cache.dart';
import 'package:fiteo_myapp/features/reports/models/weekly_report_cache.dart';

class ReportRepository {
  ReportRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  static const ReportCacheSerializer _serializer =
  ReportCacheSerializer();

  Future<PreviousReportSnapshot?> getPreviousWeeklyReport() {
    return _getPreviousReport('weeklyCurrent');
  }

  Future<PreviousReportSnapshot?> getPreviousMonthlyReport() {
    return _getPreviousReport('monthlyCurrent');
  }

  Future<void> saveWeeklyReport(WeeklyReportCache cache) async {
    final userId = _requireUserId();

    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('reports')
        .doc('weeklyCurrent');

    await ref.set(_serializer.weeklyToMap(cache));
  }

  Future<WeeklyReportCache?> getWeeklyReport() async {
    final userId = _requireUserId();

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('reports')
        .doc('weeklyCurrent')
        .get();

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      return null;
    }

    return _serializer.weeklyFromMap(data);
  }

  Future<MonthlyReportCache?> getMonthlyReport() async {
    final userId = _requireUserId();

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('reports')
        .doc('monthlyCurrent')
        .get();

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      return null;
    }

    return _serializer.monthlyFromMap(data);
  }

  Future<void> saveMonthlyReport(MonthlyReportCache cache) async {
    final userId = _requireUserId();

    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('reports')
        .doc('monthlyCurrent');

    await ref.set(_serializer.monthlyToMap(cache));
  }

  Future<void> makeWeeklyReportAvailable() async {
    await _updateReportState(
      documentId: 'weeklyCurrent',
      data: {
        'isAvailable': true,
      },
    );
  }

  Future<void> makeMonthlyReportAvailable() async {
    await _updateReportState(
      documentId: 'monthlyCurrent',
      data: {
        'isAvailable': true,
      },
    );
  }

  Future<void> dismissWeeklyReport() async {
    await _updateReportState(
      documentId: 'weeklyCurrent',
      data: {
        'dismissed': true,
        'dismissedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> dismissMonthlyReport() async {
    await _updateReportState(
      documentId: 'monthlyCurrent',
      data: {
        'dismissed': true,
        'dismissedAt': FieldValue.serverTimestamp(),
      },
    );
  }

  Future<void> _updateReportState({
    required String documentId,
    required Map<String, dynamic> data,
  }) async {
    final userId = _requireUserId();

    final ref = _firestore
        .collection('users')
        .doc(userId)
        .collection('reports')
        .doc(documentId);

    await ref.update(data);
  }

  Future<PreviousReportSnapshot?> _getPreviousReport(String documentId) async {
    final userId = _requireUserId();

    final snapshot = await _firestore
        .collection('users')
        .doc(userId)
        .collection('reports')
        .doc(documentId)
        .get();

    final data = snapshot.data();

    if (!snapshot.exists || data == null) {
      return null;
    }

    final comparisonBasis = _comparisonBasisFromData(data);

    if (comparisonBasis == null) {
      return null;
    }

    final score = (data['score'] as num?)?.round() ?? comparisonBasis.score;

    return PreviousReportSnapshot(
      score: score,
      comparisonBasis: comparisonBasis,
    );
  }

  ReportComparisonBasis? _comparisonBasisFromData(
      Map<String, dynamic>? data,
      ) {
    if (data == null) {
      return null;
    }

    final rawBasis = data['comparisonBasis'];

    if (rawBasis is! Map) {
      return null;
    }

    final basis = Map<String, dynamic>.from(rawBasis);

    return ReportComparisonBasis(
      score: (basis['score'] as num?)?.round() ?? 0,
      trackingConsistency:
      (basis['trackingConsistency'] as num?)?.toDouble() ?? 0,
      goalConsistency: (basis['goalConsistency'] as num?)?.toDouble() ?? 0,
      calorieAdherence: (basis['calorieAdherence'] as num?)?.toDouble() ?? 0,
      calorieTargetDays: (basis['calorieTargetDays'] as num?)?.round() ?? 0,
      proteinAdherence: (basis['proteinAdherence'] as num?)?.toDouble() ?? 0,
      proteinTargetDays: (basis['proteinTargetDays'] as num?)?.round() ?? 0,
      carbsAdherence: (basis['carbsAdherence'] as num?)?.toDouble() ?? 0,
      carbsTargetDays: (basis['carbsTargetDays'] as num?)?.round() ?? 0,
      fatAdherence: (basis['fatAdherence'] as num?)?.toDouble() ?? 0,
      fatTargetDays: (basis['fatTargetDays'] as num?)?.round() ?? 0,
      hydrationAdherence:
      (basis['hydrationAdherence'] as num?)?.toDouble() ?? 0,
      hydrationTargetDays:
      (basis['hydrationTargetDays'] as num?)?.round() ?? 0,
      activityScore: (basis['activityScore'] as num?)?.toDouble() ?? 0,
      activeDays: (basis['activeDays'] as num?)?.round() ?? 0,
    );
  }

  String _requireUserId() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('User not logged in');
    }

    return user.uid;
  }
}