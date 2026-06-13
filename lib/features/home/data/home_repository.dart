import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<Map<String, dynamic>> getTodaySummary() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = _formatDate(DateTime.now());

    final summaryDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(today)
        .get();

    if (!summaryDoc.exists) {
      return {
        'consumed': 0,
        'burned': 0,
        'netCalories': 0,
        'calorieGoal': null,
        'remaining': null,
        'isGoalReached': false,
      };
    }

    final data = summaryDoc.data();

    final consumed = data?['consumedCalories'] as int? ?? 0;
    final burned = data?['burnedCalories'] as int? ?? 0;
    final netCalories = data?['netCalories'] as int? ?? consumed - burned;
    final calorieGoal = data?['calorieGoal'] as int?;
    final isGoalReached = data?['isGoalReached'] as bool? ?? false;

    return {
      'consumed': consumed,
      'burned': burned,
      'netCalories': netCalories,
      'calorieGoal': calorieGoal,
      'remaining': calorieGoal == null ? null : calorieGoal - netCalories,
      'isGoalReached': isGoalReached,
    };
  }

  Future<int> getCurrentStreak() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    int streak = 0;
    DateTime day = DateTime.now();

    while (true) {
      final date = _formatDate(day);

      final summaryDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailySummaries')
          .doc(date)
          .get();

      if (!summaryDoc.exists) break;

      final data = summaryDoc.data();

      final netCalories = data?['netCalories'] as int? ?? 0;
      final calorieGoal = data?['calorieGoal'] as int?;

      if (calorieGoal != null && netCalories >= calorieGoal) {
        streak++;
        day = day.subtract(const Duration(days: 1));
      } else {
        break;
      }
    }

    return streak;
  }

  Future<Map<String, int>> getLast7DaysStats() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    int trackedDays = 0;
    int activeDays = 0;

    final now = DateTime.now();

    for (int i = 0; i < 7; i++) {
      final day = now.subtract(Duration(days: i));
      final date = _formatDate(day);

      final summaryDoc = await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('dailySummaries')
          .doc(date)
          .get();

      if (!summaryDoc.exists) continue;

      final data = summaryDoc.data();

      final consumed = data?['consumedCalories'] as int? ?? 0;
      final burned = data?['burnedCalories'] as int? ?? 0;

      if (consumed > 0) {
        trackedDays++;
      }

      if (burned > 0) {
        activeDays++;
      }
    }

    return {
      'trackedDays': trackedDays,
      'activeDays': activeDays,
    };
  }

  Future<bool> isFirstAppDay() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final userDoc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final data = userDoc.data();

    final createdAt =
    data?['createdAt'] as Timestamp?;

    if (createdAt == null) {
      return false;
    }

    final createdDate = createdAt.toDate();

    final now = DateTime.now();

    return createdDate.year == now.year &&
        createdDate.month == now.month &&
        createdDate.day == now.day;
  }
}