import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';

class MealRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DailySummaryRepository _dailySummaryRepository =
  DailySummaryRepository();

  Future<String> addMeal({
    required String mealName,
    required int gram,
    required String mealType,
    int? estimatedCalories,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .add({
      'mealName': mealName,
      'gram': gram,
      'mealType': mealType,
      'estimatedCalories': estimatedCalories,
      'date': date,
      'createdAt': FieldValue.serverTimestamp(),
    });

    _dailySummaryRepository.updateDailySummary();

    return docRef.id;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTodayMeals() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final today = DateTime.now();
    final date =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('meals')
        .where('date', isEqualTo: date)
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

    _dailySummaryRepository.updateDailySummary();
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
    });

    _dailySummaryRepository.updateDailySummary();
  }
}