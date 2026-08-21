import 'package:cloud_firestore/cloud_firestore.dart';

class FatSecretFoodCacheRepository {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance;

  String normalizeQuery(String value) {
    return value
        .toLowerCase()
        .replaceAll('&', ' and ')
        .replaceAll(RegExp(r"['’]"), '')
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  Future<String?> getFoodIdForQuery(
      String query,
      ) async {
    final normalizedQuery =
    normalizeQuery(query);

    if (normalizedQuery.isEmpty) {
      return null;
    }

    final doc = await _firestore
        .collection('fatSecretFoodAliases')
        .doc(normalizedQuery)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();

    if (data == null) {
      return null;
    }

    final foodId =
    data['foodId']?.toString();

    if (foodId == null || foodId.isEmpty) {
      return null;
    }

    return foodId;
  }

  Future<void> saveFoodAlias({
    required String query,
    required String foodId,
  }) async {
    final normalizedQuery =
    normalizeQuery(query);

    if (normalizedQuery.isEmpty ||
        foodId.trim().isEmpty) {
      return;
    }

    await _firestore
        .collection('fatSecretFoodAliases')
        .doc(normalizedQuery)
        .set({
      'foodId': foodId.trim(),
      'updatedAt':
      FieldValue.serverTimestamp(),
    });
  }
}