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
    final userData = userDoc.data();

    final userPreferences =
    userData?['userPreferences']
    as Map<String, dynamic>?;

    final nutritionPlan =
    userData?['nutritionPlan']
    as Map<String, dynamic>?;

    final calorieGoal = (
        nutritionPlan?['calorieGoal'] ??
            nutritionPlan?['dailyCalories'] ??
            userPreferences?['calorieGoal']
    ) as num?;

    final proteinGoal = (
        nutritionPlan?['proteinGoal'] ??
            nutritionPlan?['proteinGrams'] ??
            userPreferences?['proteinGoal']
    ) as num?;

    final carbsGoal = (
        nutritionPlan?['carbsGoal'] ??
            nutritionPlan?['carbsGrams'] ??
            userPreferences?['carbsGoal']
    ) as num?;

    final fatGoal = (
        nutritionPlan?['fatGoal'] ??
            nutritionPlan?['fatsGrams'] ??
            userPreferences?['fatGoal']
    ) as num?;

    final waterGoalMl = (
        nutritionPlan?['waterGoalMl'] ??
            nutritionPlan?['waterMl'] ??
            userPreferences?['waterGoalMl']
    ) as num?;

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

    int workoutMinutes = 0;
    int workoutCount = 0;

    double protein = 0.0;
    double fats = 0.0;
    double carbs = 0.0;

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
      final data = doc.data();

      burnedCalories +=
          (data['estimatedCaloriesBurned'] as num?)?.round() ?? 0;

      workoutMinutes +=
          (data['durationMinutes'] as num?)?.round() ?? 0;

      workoutCount++;
    }

    final isActiveDay = workoutMinutes >= 20;

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

      'calorieGoal': calorieGoal?.round(),
      'proteinGoal': proteinGoal?.toDouble(),
      'carbsGoal': carbsGoal?.toDouble(),
      'fatGoal': fatGoal?.toDouble(),
      'waterGoalMl': waterGoalMl?.round(),

      'workoutMinutes': workoutMinutes,
      'workoutCount': workoutCount,
      'isActiveDay': isActiveDay,

      'isGoalReached':
      calorieGoal == null
          ? false
          : netCalories >= calorieGoal,

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

    final userDoc = await _firestore.collection('users').doc(user.uid).get();
    final userData = userDoc.data();

    final userPreferences =
    userData?['userPreferences'] as Map<String, dynamic>?;

    final nutritionPlan =
    userData?['nutritionPlan'] as Map<String, dynamic>?;

    final waterGoalMl = (
        nutritionPlan?['waterGoalMl'] ??
            nutritionPlan?['waterMl'] ??
            userPreferences?['waterGoalMl']
    ) as num?;

    final docRef = _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(dateString);

    await docRef.set({
      'date': dateString,
      'hydrationMl': FieldValue.increment(amountMl),
      'waterGoalMl': waterGoalMl?.round(),
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

  Future<List<Map<String, dynamic>>> getSummariesForPeriod({
    required DateTime startDate,
    required DateTime endDate,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final startKey = _formatDate(startDate);
    final endKey = _formatDate(endDate);

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .where('date', isGreaterThanOrEqualTo: startKey)
        .where('date', isLessThanOrEqualTo: endKey)
        .orderBy('date')
        .get();

    return snapshot.docs.map((doc) {
      return Map<String, dynamic>.from(doc.data());
    }).toList();
  }
}