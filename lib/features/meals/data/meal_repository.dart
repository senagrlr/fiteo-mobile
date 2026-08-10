import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';

class MealRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final DailySummaryRepository _dailySummaryRepository =
  DailySummaryRepository();

  String _todayDate() {
    final today = DateTime.now();

    return '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
  }

  Future<String> addMeal({
    required String mealName,
    required int amount,
    required String unit,
    required String mealType,
    int? estimatedCalories,
    int protein = 0,
    int fats = 0,
    int carbs = 0,
    String nutritionSource = 'unknown',
    bool isEstimated = false,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .add({
      'mealName': mealName,
      'amount': amount,
      'unit': unit,
      'mealType': mealType,
      'estimatedCalories': estimatedCalories,
      'protein': protein,
      'fats': fats,
      'carbs': carbs,
      'nutritionSource': nutritionSource,
      'isEstimated': isEstimated,
      'date': _todayDate(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _dailySummaryRepository.updateDailySummary();

    return docRef.id;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTodayMeals() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .where(
      'date',
      isEqualTo: _todayDate(),
    )
        .get();
  }

  Future<void> deleteMeal(String mealId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .doc(mealId)
        .delete();

    await _dailySummaryRepository.updateDailySummary();
  }

  Future<void> updateMealCalories({
    required String mealId,
    required int calories,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .doc(mealId)
        .update({
      'estimatedCalories': calories,
      'updatedAt': FieldValue.serverTimestamp(),
    });

    await _dailySummaryRepository.updateDailySummary();
  }
}