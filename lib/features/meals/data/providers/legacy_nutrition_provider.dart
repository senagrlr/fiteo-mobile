import 'package:fiteo_myapp/features/meals/data/nutrition_api_service.dart';
import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';
import 'package:fiteo_myapp/features/meals/domain/providers/nutrition_provider.dart';

class LegacyNutritionProvider implements NutritionProvider {
  final NutritionApiService _nutritionApiService;

  LegacyNutritionProvider({
    NutritionApiService? nutritionApiService,
  }) : _nutritionApiService =
      nutritionApiService ?? NutritionApiService();

  @override
  String get providerName => 'legacy';

  @override
  Future<List<NutritionFood>> searchFoods({
    required String query,
  }) async {
    final result = await _nutritionApiService.searchFood(
      query: query,
      foodType: 'generic',
    );

    if (result == null) {
      return [];
    }

    final calories = result.caloriesPer100g.toDouble();

    return [
      NutritionFood(
        id: 'legacy_${query.toLowerCase().trim()}',
        name: result.name,

        caloriesPer100g: calories,

        proteinPer100g: calories * 0.07,
        fatPer100g: calories * 0.035,
        carbsPer100g: calories * 0.10,

        servings: const [],

        source: providerName,
        isEstimated: true,
      ),
    ];
  }

  @override
  Future<NutritionFood?> getFoodDetails({
    required String id,
  }) async {
    return null;
  }
}