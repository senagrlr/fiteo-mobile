import 'package:cloud_firestore/cloud_firestore.dart';

class FoodCalorieCacheRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String normalizeFoodName(String value) {
    return value.trim().toLowerCase();
  }

  Future<Map<String, dynamic>?> getCachedFood(String foodName) async {
    final normalizedName = normalizeFoodName(foodName);

    final doc = await _firestore
        .collection('foodCalorieCache')
        .doc(normalizedName)
        .get();

    if (!doc.exists) return null;

    return doc.data();
  }

  int calculateCalories({
    required int gram,
    required num caloriesPer100g,
  }) {
    return ((gram / 100) * caloriesPer100g).round();
  }

  Future<void> saveFoodToCache({
    required String foodName,
    required String normalizedName,
    required num caloriesPer100g,
    required String source,
    required String foodType,
    String? confidence,
  }) async {
    final docId = normalizeFoodName(normalizedName);

    await _firestore.collection('foodCalorieCache').doc(docId).set({
      'name': foodName,
      'normalizedName': docId,
      'caloriesPer100g': caloriesPer100g,
      'source': source,
      'foodType': foodType,
      'confidence': confidence,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }
}