import 'package:fiteo_myapp/features/meals/data/fatsecret_api_service.dart';
import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';
import 'package:fiteo_myapp/features/meals/domain/providers/nutrition_provider.dart';
import 'package:fiteo_myapp/features/meals/data/fatsecret_food_cache_repository.dart';

class FatSecretNutritionProvider implements NutritionProvider {
  final FatSecretApiService _apiService;
  final FatSecretFoodCacheRepository _cacheRepository;

  FatSecretNutritionProvider({
    FatSecretApiService? apiService,
    FatSecretFoodCacheRepository? cacheRepository,
  })  : _apiService = apiService ?? FatSecretApiService(),
        _cacheRepository =
            cacheRepository ?? FatSecretFoodCacheRepository();

  NutritionFood _mapSearchFoodToNutritionFood(
      FatSecretSearchFood food,
      ) {
    return NutritionFood(
      id: food.id,
      name: food.name,
      caloriesPer100g: food.caloriesPer100g,
      proteinPer100g: food.proteinPer100g,
      fatPer100g: food.fatPer100g,
      carbsPer100g: food.carbsPer100g,
      hasPer100gServing: food.hasPer100gServing,
      servings: food.servings.map((serving) {
        return NutritionServing(
          id: serving.id,
          description: serving.description,
          calories: serving.calories,
          protein: serving.protein,
          fat: serving.fat,
          carbs: serving.carbs,
        );
      }).toList(),
      source: providerName,
      isEstimated: false,
      foodType: food.foodType,
      confidence: 'high',
    );
  }

  NutritionFood _mapDetailsToNutritionFood(
      FatSecretFoodDetails details,
      ) {
    return NutritionFood(
      id: details.id,
      name: details.name,
      caloriesPer100g: details.caloriesPer100g,
      proteinPer100g: details.proteinPer100g,
      fatPer100g: details.fatPer100g,
      carbsPer100g: details.carbsPer100g,
      hasPer100gServing: details.hasPer100gServing,
      servings: details.servings.map((serving) {
        return NutritionServing(
          id: serving.id,
          description: serving.description,
          calories: serving.calories,
          protein: serving.protein,
          fat: serving.fat,
          carbs: serving.carbs,
        );
      }).toList(),
      source: providerName,
      isEstimated: false,
      foodType: details.foodType,
      confidence: 'high',
    );
  }

  @override
  String get providerName => 'fatsecret';

  @override
  Future<List<NutritionFood>> searchFoods({
    required String query,
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return [];
    }

    final cachedFoodId =
    await _cacheRepository.getFoodIdForQuery(
      cleanQuery,
    );

    if (cachedFoodId != null) {
      final cachedDetails =
      await _apiService.getFoodDetails(
        id: cachedFoodId,
      );

      if (cachedDetails != null) {
        print(
          'FATSECRET FOOD CACHE HIT: '
              '$cleanQuery -> $cachedFoodId',
        );

        return [
          _mapDetailsToNutritionFood(
            cachedDetails,
          ),
        ];
      }
    }

    print(
      'FATSECRET FOOD CACHE MISS: $cleanQuery',
    );

    final results =
    await _apiService.searchFoods(
      query: cleanQuery,
    );

    if (results.isEmpty) {
      return [];
    }

    return results
        .map(_mapSearchFoodToNutritionFood)
        .toList();
  }

  @override
  Future<NutritionFood?> getFoodDetails({
    required String id,
  }) async {
    final details =
    await _apiService.getFoodDetails(
      id: id,
    );

    if (details == null) {
      return null;
    }

    return _mapDetailsToNutritionFood(details,);
  }
}