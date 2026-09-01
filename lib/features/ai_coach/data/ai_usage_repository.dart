import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_usage_state.dart';

class AiUsageRepository {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  AiUsageRepository({
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
  })  : _auth = auth ?? FirebaseAuth.instance,
        _firestore =
            firestore ?? FirebaseFirestore.instance;

  String _todayDate() {
    final today = DateTime.now().toUtc();

    return '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
  }

  DocumentReference<Map<String, dynamic>>?
  _todayUsageRef() {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('aiUsage')
        .doc(_todayDate());
  }

  Future<AiUsageState> getTodayChatUsage() async {
    final ref = _todayUsageRef();

    if (ref == null) {
      return const AiUsageState.empty();
    }

    final snapshot = await ref.get();
    final data = snapshot.data();

    if (data == null) {
      return const AiUsageState.empty();
    }

    return AiUsageState(
      usedCount:
      (data['chatCount'] as num?)
          ?.toInt() ??
          0,
      rewardedCredits:
      (data['rewardedChatCredits']
      as num?)
          ?.toInt() ??
          0,
    );
  }

  Future<AiUsageState> getTodayRecipeUsage() async {
    final ref = _todayUsageRef();

    if (ref == null) {
      return const AiUsageState.empty();
    }

    final snapshot = await ref.get();
    final data = snapshot.data();

    if (data == null) {
      return const AiUsageState.empty();
    }

    return AiUsageState(
      usedCount:
      (data['recipeCount'] as num?)
          ?.toInt() ??
          0,
      rewardedCredits:
      (data['rewardedRecipeCredits']
      as num?)
          ?.toInt() ??
          0,
    );
  }
}