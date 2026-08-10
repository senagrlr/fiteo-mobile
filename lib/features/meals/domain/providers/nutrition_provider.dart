import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';

abstract class NutritionProvider {
  String get providerName;

  Future<List<NutritionFood>> searchFoods({
    required String query,
  });

  Future<NutritionFood?> getFoodDetails({
    required String id,
  });
}