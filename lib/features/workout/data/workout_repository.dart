import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';

class WorkoutRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DailySummaryRepository _dailySummaryRepository =
  DailySummaryRepository();

  String _todayDate() {
    final today = DateTime.now();
    return '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  }

  Future<String> addWorkout({
    required String workoutName,
    required int durationMinutes,
    required String intensity,
    int? estimatedCaloriesBurned,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final docRef = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .add({
      'workoutName': workoutName,
      'durationMinutes': durationMinutes,
      'intensity': intensity,
      'estimatedCaloriesBurned': estimatedCaloriesBurned,
      'date': _todayDate(),
      'createdAt': FieldValue.serverTimestamp(),
    });

    await _dailySummaryRepository.updateDailySummary();

    return docRef.id;
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTodayWorkouts() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .where('date', isEqualTo: _todayDate())
        .get();
  }

  Future<void> deleteWorkout(String workoutId) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .doc(workoutId)
        .delete();

    await _dailySummaryRepository.updateDailySummary();
  }

  Future<void> updateWorkoutCalories({
    required String workoutId,
    required int calories,
  }) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('workouts')
        .doc(workoutId)
        .update({
      'estimatedCaloriesBurned': calories,
    });

    await _dailySummaryRepository.updateDailySummary();
  }
}