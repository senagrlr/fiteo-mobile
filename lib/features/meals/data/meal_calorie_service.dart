import 'package:fiteo_myapp/features/ai/data/ai_service.dart';
import 'package:fiteo_myapp/features/meals/data/food_calorie_cache_repository.dart';
import 'package:fiteo_myapp/features/meals/data/nutrition_api_service.dart';

class MealCalorieResult {
  final String foodName;
  final String normalizedName;
  final int estimatedCalories;
  final num caloriesPer100g;
  final String source;
  final String foodType;
  final String? confidence;

  const MealCalorieResult({
    required this.foodName,
    required this.normalizedName,
    required this.estimatedCalories,
    required this.caloriesPer100g,
    required this.source,
    required this.foodType,
    this.confidence,
  });
}

class MealCalorieService {
  final FoodCalorieCacheRepository _cacheRepository =
  FoodCalorieCacheRepository();

  final AiService _aiService = AiService();
  final NutritionApiService _nutritionApiService = NutritionApiService();

  Future<MealCalorieResult?> estimateMealCalories({
    required String foodName,
    required int gram,
  }) async {
    if (foodName.trim().isEmpty || gram <= 0) {
      return null;
    }

    final normalizedFood = await _aiService.normalizeFoodName(foodName);

    if (normalizedFood == null) {
      return null;
    }

    final cachedFood = await _cacheRepository.getCachedFood(
      normalizedFood.normalizedName,
    );

    if (cachedFood != null) {
      final caloriesPer100g = cachedFood['caloriesPer100g'] as num?;

      if (caloriesPer100g != null) {
        final estimatedCalories = _cacheRepository.calculateCalories(
          gram: gram,
          caloriesPer100g: caloriesPer100g,
        );

        return MealCalorieResult(
          foodName: cachedFood['name'] as String? ?? foodName,
          normalizedName: normalizedFood.normalizedName,
          estimatedCalories: estimatedCalories,
          caloriesPer100g: caloriesPer100g,
          source: cachedFood['source'] as String? ?? 'cache',
          foodType: cachedFood['foodType'] as String? ?? normalizedFood.foodType,
          confidence: cachedFood['confidence'] as String?,
        );
      }
    }

    final apiResult = await _nutritionApiService.searchFood(
      query: normalizedFood.searchQuery,
      foodType: normalizedFood.foodType,
    );

    if (apiResult != null) {
      final estimatedCalories = _cacheRepository.calculateCalories(
        gram: gram,
        caloriesPer100g: apiResult.caloriesPer100g,
      );

      return MealCalorieResult(
        foodName: apiResult.name,
        normalizedName: normalizedFood.normalizedName,
        estimatedCalories: estimatedCalories,
        caloriesPer100g: apiResult.caloriesPer100g,
        source: 'api',
        foodType: normalizedFood.foodType,
        confidence: 'high',
      );
    }

    final aiEstimate = await _aiService.estimateFoodCaloriesPer100g(
      foodName: normalizedFood.searchQuery,
    );

    if (aiEstimate != null && aiEstimate.caloriesPer100g > 0) {
      final estimatedCalories = _cacheRepository.calculateCalories(
        gram: gram,
        caloriesPer100g: aiEstimate.caloriesPer100g,
      );

      return MealCalorieResult(
        foodName: normalizedFood.searchQuery,
        normalizedName: normalizedFood.normalizedName,
        estimatedCalories: estimatedCalories,
        caloriesPer100g: aiEstimate.caloriesPer100g,
        source: 'ai_estimate',
        foodType: normalizedFood.foodType,
        confidence: aiEstimate.confidence,
      );
    }

    return null;
  }
}