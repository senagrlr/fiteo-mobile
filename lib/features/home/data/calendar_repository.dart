import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class CalendarRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<Map<String, int>> getDayCalories(DateTime date) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final formatted = _formatDate(date);

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(formatted)
        .get();

    if (!doc.exists) {
      return {
        'consumed': 0,
        'burned': 0,
      };
    }

    final data = doc.data();

    return {
      'consumed': data?['consumedCalories'] as int? ?? 0,
      'burned': data?['burnedCalories'] as int? ?? 0,
    };
  }

  Future<Map<int, Map<String, num>>> getMonthlyData(DateTime month) async {
    final user = _auth.currentUser;
    if (user == null) throw Exception('User not logged in');

    final startDate =
        '${month.year}-${month.month.toString().padLeft(2, '0')}-01';

    final lastDay = DateTime(month.year, month.month + 1, 0).day;

    final endDate =
        '${month.year}-${month.month.toString().padLeft(2, '0')}-${lastDay.toString().padLeft(2, '0')}';

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .where('date', isGreaterThanOrEqualTo: startDate)
        .where('date', isLessThanOrEqualTo: endDate)
        .get();

    final Map<int, Map<String, num>> data = {};

    for (final doc in snapshot.docs) {
      final d = doc.data();
      final dateStr = d['date'] as String?;

      if (dateStr == null) continue;

      final day = int.parse(dateStr.split('-')[2]);

      data[day] = {
        'consumed': (d['consumedCalories'] as num?) ?? 0,
        'burned': (d['burnedCalories'] as num?) ?? 0,
        'netCalories': (d['netCalories'] as num?) ?? 0,

        'protein': (d['protein'] as num?) ?? 0,
        'fats': (d['fats'] as num?) ?? 0,
        'carbs': (d['carbs'] as num?) ?? 0,

        'proteinGoal': (d['proteinGoal'] as num?) ?? 0,
        'fatGoal': (d['fatGoal'] as num?) ?? 0,
        'carbsGoal': (d['carbsGoal'] as num?) ?? 0,

        'hydration': (d['hydrationMl'] as num?) ?? 0,
      };
    }

    return data;
  }
}