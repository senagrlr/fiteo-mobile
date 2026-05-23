import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/ai/data/ai_service.dart';

class WorkoutRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final DailySummaryRepository _dailySummaryRepository =
  DailySummaryRepository();
  final AiService _aiService = AiService();

  String _todayDate() {
    final today = DateTime.now();
    return '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
  }

  String _normalizeText(String value) {
    return value
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'\s+'), ' ');
  }

  int _levenshteinDistance(String a, String b) {
    final matrix = List.generate(
      a.length + 1,
          (_) => List<int>.filled(b.length + 1, 0),
    );

    for (int i = 0; i <= a.length; i++) {
      matrix[i][0] = i;
    }

    for (int j = 0; j <= b.length; j++) {
      matrix[0][j] = j;
    }

    for (int i = 1; i <= a.length; i++) {
      for (int j = 1; j <= b.length; j++) {
        final cost = a[i - 1] == b[j - 1] ? 0 : 1;

        matrix[i][j] = [
          matrix[i - 1][j] + 1,
          matrix[i][j - 1] + 1,
          matrix[i - 1][j - 1] + cost,
        ].reduce((value, element) => value < element ? value : element);
      }
    }

    return matrix[a.length][b.length];
  }

  bool _isSimilarEnough(String input, String candidate) {
    if (input.isEmpty || candidate.isEmpty) return false;

    if (input.contains(candidate) || candidate.contains(input)) {
      return true;
    }

    final distance = _levenshteinDistance(input, candidate);
    final maxLength = input.length > candidate.length
        ? input.length
        : candidate.length;

    final similarity = 1 - (distance / maxLength);

    return similarity >= 0.82;
  }

  Future<Map<String, dynamic>?> findExerciseMet(String exerciseName) async {
    final normalizedInput = _normalizeText(exerciseName);

    if (normalizedInput.isEmpty) {
      return null;
    }

    final snapshot =
    await _firestore.collection('exerciseMetValues').get();

    final exercises = snapshot.docs.map((doc) {
      final data = doc.data();

      return {
        'id': doc.id,
        'name': data['name'],
        'aliases': List<String>.from(data['aliases'] ?? []),
        'metValues': data['metValues'],
      };
    }).toList();

    for (final exercise in exercises) {
      final name = _normalizeText(
        (exercise['name'] ?? '').toString(),
      );

      final aliases = List<String>.from(
        exercise['aliases'] as List,
      ).map(_normalizeText).toList();

      if (normalizedInput == name ||
          aliases.contains(normalizedInput)) {
        return {
          'id': exercise['id'],
          'name': exercise['name'],
          'metValues': exercise['metValues'],
          'matchSource': 'exact_or_alias',
        };
      }
    }

    for (final exercise in exercises) {
      final name = _normalizeText(
        (exercise['name'] ?? '').toString(),
      );

      final aliases = List<String>.from(
        exercise['aliases'] as List,
      ).map(_normalizeText).toList();

      final candidates = [
        name,
        ...aliases,
      ];

      final matched = candidates.any(
            (candidate) => _isSimilarEnough(
          normalizedInput,
          candidate,
        ),
      );

      if (matched) {
        return {
          'id': exercise['id'],
          'name': exercise['name'],
          'metValues': exercise['metValues'],
          'matchSource': 'local_similarity',
        };
      }
    }

    final aiResult = await _aiService.classifyExercise(
      input: exerciseName,
      exercises: exercises.map((exercise) {
        return {
          'id': exercise['id'],
          'name': exercise['name'],
          'aliases': exercise['aliases'],
        };
      }).toList(),
    );

    if (aiResult == null || aiResult.exerciseId.isEmpty) {
      return null;
    }

    final matchedExercise = exercises.firstWhere(
          (exercise) => exercise['id'] == aiResult.exerciseId,
      orElse: () => {},
    );

    if (matchedExercise.isEmpty) {
      return null;
    }

    return {
      'id': matchedExercise['id'],
      'name': matchedExercise['name'],
      'metValues': matchedExercise['metValues'],
      'matchSource': 'ai_classification',
      'confidence': aiResult.confidence,
    };
  }

  int calculateCaloriesBurned({
    required double met,
    required double weightKg,
    required int durationMinutes,
  }) {
    final durationHours = durationMinutes / 60;
    return (met * weightKg * durationHours).round();
  }

  Future<double> getUserWeightKg() async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    final doc = await _firestore.collection('users').doc(user.uid).get();
    final preferences = doc.data()?['userPreferences'] as Map<String, dynamic>?;

    final weight = preferences?['weight'];

    if (weight is int) return weight.toDouble();
    if (weight is double) return weight;
    if (weight is String) return double.tryParse(weight) ?? 70;

    return 70;
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

    _dailySummaryRepository.updateDailySummary();

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

    _dailySummaryRepository.updateDailySummary();
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

    _dailySummaryRepository.updateDailySummary();
  }
}