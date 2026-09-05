import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_chat_message.dart';

class AiChatRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _todayDate() {
    final today = DateTime.now();

    return '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  }

  Future<List<AiChatMessage>> getRecentMessages({
    int limit = 6,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('aiChatMessages')
        .orderBy('createdAt', descending: true)
        .limit(limit)
        .get();

    return snapshot.docs
        .map(
          (doc) => AiChatMessage.fromJson(
        id: doc.id,
        json: doc.data(),
      ),
    )
        .toList()
        .reversed
        .toList();
  }

  Stream<List<AiChatMessage>> watchMessages() {
    final user = _auth.currentUser;

    if (user == null) {
      return const Stream.empty();
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('aiChatMessages')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
          .map(
            (doc) => AiChatMessage.fromJson(
          id: doc.id,
          json: doc.data(),
        ),
      )
          .toList(),
    );
  }

  Future<void> saveMessage({
    required String role,
    required String message,
  }) async {
    final user = _auth.currentUser;

    if (user == null) return;

    await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('aiChatMessages')
        .add({
      'role': role,
      'message': message,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  Future<Map<String, dynamic>> getUserPreferences() async {
    final user = _auth.currentUser;

    if (user == null) return {};

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .get();

    final data = doc.data();

    final preferences =
    Map<String, dynamic>.from(
      data?['userPreferences'] ?? {},
    );

    final nutritionPlan =
    data?['nutritionPlan']
    as Map<String, dynamic>?;

    return {
      ...preferences,

      'calorieGoal':
      nutritionPlan?['calorieGoal'] ??
          nutritionPlan?['dailyCalories'],

      'proteinGoal':
      nutritionPlan?['proteinGoal'] ??
          nutritionPlan?['proteinGrams'],

      'carbsGoal':
      nutritionPlan?['carbsGoal'] ??
          nutritionPlan?['carbsGrams'],

      'fatGoal':
      nutritionPlan?['fatGoal'] ??
          nutritionPlan?['fatsGrams'],

      'waterGoalMl':
      nutritionPlan?['waterGoalMl'] ??
          nutritionPlan?['waterMl'],
    };
  }

  Future<Map<String, dynamic>> getTodaySummary() async {
    final user = _auth.currentUser;

    if (user == null) return {};

    final date = _todayDate();

    final doc = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .doc(date)
        .get();

    final data = doc.data();

    if (data == null) return {};

    return {
      'date': data['date'] ?? date,
      'consumedCalories': data['consumedCalories'],
      'burnedCalories': data['burnedCalories'],
      'netCalories': data['netCalories'],
      'calorieGoal': data['calorieGoal'],
      'isGoalReached': data['isGoalReached'],
    };
  }

  Future<List<Map<String, dynamic>>> getLast7DailySummaries() async {
    final user = _auth.currentUser;

    if (user == null) return [];

    final snapshot = await _firestore
        .collection('users')
        .doc(user.uid)
        .collection('dailySummaries')
        .orderBy('date', descending: true)
        .limit(7)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        'date': data['date'] ?? doc.id,
        'consumedCalories': data['consumedCalories'],
        'burnedCalories': data['burnedCalories'],
        'netCalories': data['netCalories'],
        'calorieGoal': data['calorieGoal'],
        'isGoalReached': data['isGoalReached'],
      };
    }).toList().reversed.toList();
  }
  Future<Map<String, dynamic>>
  getRecipePreferences() async {
    final preferences =
    await getUserPreferences();

    return {
      'goal': preferences['goal'],

      'nutritionPreference':
      preferences['nutritionPreference'],

      if (preferences.containsKey(
        'dietaryRequirements',
      ))
        'dietaryRequirements':
        preferences['dietaryRequirements'],

      'calorieGoal':
      preferences['calorieGoal'],

      'proteinGoal':
      preferences['proteinGoal'],

      'carbsGoal':
      preferences['carbsGoal'],

      'fatGoal':
      preferences['fatGoal'],
    };
  }
}