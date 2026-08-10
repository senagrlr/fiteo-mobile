import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';

class FoodCalorieCacheRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String normalizeFoodName(String value) {
    return value.trim().toLowerCase();
  }

  Future<NutritionFood?> getCachedFood(String foodName) async {
    final normalizedName = normalizeFoodName(foodName);

    final doc = await _firestore
        .collection('foodCalorieCache')
        .doc(normalizedName)
        .get();

    if (!doc.exists) {
      return null;
    }

    final data = doc.data();

    if (data == null) {
      return null;
    }

    return NutritionFood.fromMap(data);
  }

  Future<void> saveFoodToCache({
    required String normalizedName,
    required NutritionFood food,
  }) async {
    final docId = normalizeFoodName(normalizedName);

    await _firestore
        .collection('foodCalorieCache')
        .doc(docId)
        .set({
      ...food.toMap(),
      'normalizedName': docId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  int calculateCalories({
    required int gram,
    required num caloriesPer100g,
  }) {
    return ((gram / 100) * caloriesPer100g).round();
  }

  double calculateMacro({
    required int gram,
    required num valuePer100g,
  }) {
    return (gram / 100) * valuePer100g;
  }
}