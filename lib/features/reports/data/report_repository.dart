import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

  String _requireUserId() {
    final user = _auth.currentUser;

    if (user == null) {
      throw StateError('User not logged in');
    }

    return user.uid;
  }
}