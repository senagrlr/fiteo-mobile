import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/features/ai_coach/data/ai_usage_limits.dart';
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
    final today = DateTime.now();

    return '${today.year}-'
        '${today.month.toString().padLeft(2, '0')}-'
        '${today.day.toString().padLeft(2, '0')}';
  }

  DocumentReference<Map<String, dynamic>>?
  _usageRef(String documentId) {
    final user = _auth.currentUser;

    if (user == null) {
      return null;
    }

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('aiUsage')
        .doc(documentId);
  }

  Future<AiUsageState> getTodayChatUsage() async {
    return _getTodayUsage(
      documentId: 'current',
      usedCountField: 'messageCount',
      rewardedCreditsField:
      'rewardedMessageCredits',
    );
  }

  Future<AiUsageState> getTodayRecipeUsage() async {
    return _getTodayUsage(
      documentId: 'recipe',
      usedCountField: 'recipeCount',
      rewardedCreditsField:
      'rewardedRecipeCredits',
    );
  }

  Future<AiUsageState> _getTodayUsage({
    required String documentId,
    required String usedCountField,
    required String rewardedCreditsField,
  }) async {
    final ref = _usageRef(documentId);

    if (ref == null) {
      return const AiUsageState.empty();
    }

    final doc = await ref.get();
    final data = doc.data();

    if (data == null ||
        data['date'] != _todayDate()) {
      return const AiUsageState.empty();
    }

    return AiUsageState(
      usedCount:
      (data[usedCountField] as num?)?.toInt() ?? 0,
      rewardedCredits:
      (data[rewardedCreditsField] as num?)
          ?.toInt() ??
          0,
    );
  }

  Future<void> incrementChatUsage() async {
    await _incrementUsage(
      documentId: 'current',
      usedCountField: 'messageCount',
      rewardedCreditsField:
      'rewardedMessageCredits',
    );
  }

  Future<void> incrementRecipeUsage() async {
    await _incrementUsage(
      documentId: 'recipe',
      usedCountField: 'recipeCount',
      rewardedCreditsField:
      'rewardedRecipeCredits',
    );
  }

  Future<void> _incrementUsage({
    required String documentId,
    required String usedCountField,
    required String rewardedCreditsField,
  }) async {
    final ref = _usageRef(documentId);

    if (ref == null) {
      return;
    }

    final today = _todayDate();

    await _firestore.runTransaction(
          (transaction) async {
        final snapshot =
        await transaction.get(ref);

        final data = snapshot.data();

        if (data == null ||
            data['date'] != today) {
          transaction.set(ref, {
            'date': today,
            usedCountField: 1,
            rewardedCreditsField: 0,
            'updatedAt':
            FieldValue.serverTimestamp(),
          });

          return;
        }

        transaction.update(ref, {
          usedCountField:
          FieldValue.increment(1),
          'updatedAt':
          FieldValue.serverTimestamp(),
        });
      },
    );
  }

  Future<bool> grantRewardedChatCredit() async {
    return _grantRewardedCredit(
      documentId: 'current',
      usedCountField: 'messageCount',
      rewardedCreditsField:
      'rewardedMessageCredits',
      maxRewardedCredits:
      AiUsageLimits.maxRewardedChatMessages,
    );
  }

  Future<bool> grantRewardedRecipeCredit() async {
    return _grantRewardedCredit(
      documentId: 'recipe',
      usedCountField: 'recipeCount',
      rewardedCreditsField:
      'rewardedRecipeCredits',
      maxRewardedCredits:
      AiUsageLimits.maxRewardedRecipes,
    );
  }

  Future<bool> _grantRewardedCredit({
    required String documentId,
    required String usedCountField,
    required String rewardedCreditsField,
    required int maxRewardedCredits,
  }) async {
    final ref = _usageRef(documentId);

    if (ref == null) {
      return false;
    }

    final today = _todayDate();

    return _firestore.runTransaction<bool>(
          (transaction) async {
        final snapshot =
        await transaction.get(ref);

        final data = snapshot.data();

        if (data == null ||
            data['date'] != today) {
          transaction.set(ref, {
            'date': today,
            usedCountField: 0,
            rewardedCreditsField: 1,
            'updatedAt':
            FieldValue.serverTimestamp(),
          });

          return true;
        }

        final currentCredits =
            (data[rewardedCreditsField] as num?)
                ?.toInt() ??
                0;

        if (currentCredits >=
            maxRewardedCredits) {
          return false;
        }

        transaction.update(ref, {
          rewardedCreditsField:
          FieldValue.increment(1),
          'updatedAt':
          FieldValue.serverTimestamp(),
        });

        return true;
      },
    );
  }
}