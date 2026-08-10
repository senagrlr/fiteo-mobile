import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DailySummaryRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> updateDailySummary({DateTime? date}) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final selectedDate = date ?? DateTime.now();
    final dateString = _formatDate(selectedDate);

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userPreferences =
    userDoc.data()?['userPreferences'] as Map<String, dynamic>?;

    final calorieGoal = userPreferences?['calorieGoal'] as int?;

    final mealsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .where('date', isEqualTo: dateString)
        .get();

    final workoutsSnapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .where('date', isEqualTo: dateString)
        .get();

    int consumedCalories = 0;
    int burnedCalories = 0;

    double protein = 0;
    double fats = 0;
    double carbs = 0;

    for (final doc in mealsSnapshot.docs) {
      final data = doc.data();

      consumedCalories +=
          (data['estimatedCalories'] as num?)?.round() ?? 0;

      protein +=
          (data['protein'] as num?)?.toDouble() ?? 0;

      fats +=
          (data['fats'] as num?)?.toDouble() ?? 0;

      carbs +=
          (data['carbs'] as num?)?.toDouble() ?? 0;
    }

    for (final doc in workoutsSnapshot.docs) {
      burnedCalories += (doc.data()['estimatedCaloriesBurned'] as int?) ?? 0;
    }

    final netCalories = consumedCalories - burnedCalories;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(dateString)
        .set({
      'date': dateString,
      'consumedCalories': consumedCalories,
      'burnedCalories': burnedCalories,
      'netCalories': netCalories,
      'protein': protein,
      'fats': fats,
      'carbs': carbs,
      'calorieGoal': calorieGoal,
      'isGoalReached': calorieGoal == null ? false : netCalories >= calorieGoal,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<void> addWater({
    required int amountMl,
    DateTime? date,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    if (amountMl <= 0) {
      return;
    }

    final selectedDate = date ?? DateTime.now();
    final dateString = _formatDate(selectedDate);

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(dateString);

    await docRef.set({
      'date': dateString,
      'hydrationMl': FieldValue.increment(amountMl),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  Future<int> getWaterForDay({
    DateTime? date,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final selectedDate = date ?? DateTime.now();
    final dateString = _formatDate(selectedDate);

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(dateString)
        .get();

    return (doc.data()?['hydrationMl'] as num?)?.round() ?? 0;
  }
}