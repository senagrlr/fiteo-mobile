import 'package:fiteo_myapp/features/ai/data/ai_service.dart';
import 'package:fiteo_myapp/features/meals/data/food_calorie_cache_repository.dart';
import 'package:fiteo_myapp/features/meals/data/nutrition_repository.dart';

class MealCalorieResult {
  final String foodName;
  final String normalizedName;

  final int estimatedCalories;
  final double protein;
  final double fat;
  final double carbs;

  final num caloriesPer100g;

  final String source;
  final String foodType;
  final String? confidence;

  final bool isEstimated;

  const MealCalorieResult({
    required this.foodName,
    required this.normalizedName,
    required this.estimatedCalories,
    required this.protein,
    required this.fat,
    required this.carbs,
    required this.caloriesPer100g,
    required this.source,
    required this.foodType,
    this.confidence,
    this.isEstimated = false,
  });
}

class MealCalorieService {
  final FoodCalorieCacheRepository _cacheRepository =
  FoodCalorieCacheRepository();

  final AiService _aiService = AiService();

  final NutritionRepository _nutritionRepository =
  NutritionRepository();

  Future<MealCalorieResult?> estimateForGrams({
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
      final values = cachedFood.calculateForGrams(
        gram.toDouble(),
      );

      return MealCalorieResult(
        foodName: cachedFood.name,
        normalizedName: normalizedFood.normalizedName,
        estimatedCalories: values.calories.round(),
        protein: values.protein,
        fat: values.fat,
        carbs: values.carbs,
        caloriesPer100g: cachedFood.caloriesPer100g,
        source: cachedFood.source,
        foodType: cachedFood.foodType ?? normalizedFood.foodType,
        confidence: cachedFood.confidence,
        isEstimated: cachedFood.isEstimated,
      );
    }

    final nutritionFood = await _nutritionRepository.findBestMatch(
      query: normalizedFood.searchQuery,
    );

    if (nutritionFood != null) {
      final values = nutritionFood.calculateForGrams(
        gram.toDouble(),
      );

      return MealCalorieResult(
        foodName: nutritionFood.name,
        normalizedName: normalizedFood.normalizedName,
        estimatedCalories: values.calories.round(),
        protein: values.protein,
        fat: values.fat,
        carbs: values.carbs,
        caloriesPer100g: nutritionFood.caloriesPer100g,
        source: nutritionFood.source,
        foodType: normalizedFood.foodType,
        confidence: nutritionFood.isEstimated ? 'estimated' : 'high',
        isEstimated: nutritionFood.isEstimated,
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
        protein: estimatedCalories * 0.07,
        fat: estimatedCalories * 0.035,
        carbs: estimatedCalories * 0.10,
        caloriesPer100g: aiEstimate.caloriesPer100g,
        source: 'ai_estimate',
        foodType: normalizedFood.foodType,
        confidence: aiEstimate.confidence,
        isEstimated: true,
      );
    }

    return null;
  }

  Future<MealCalorieResult?> estimateForPieces({
    required String foodName,
    required double pieces,
  }) async {
    if (foodName.trim().isEmpty || pieces <= 0) {
      return null;
    }

    final normalizedFood = await _aiService.normalizeFoodName(foodName);

    if (normalizedFood == null) {
      return null;
    }

    final cachedFood = await _cacheRepository.getCachedFood(
      normalizedFood.normalizedName,
    );

    if (cachedFood != null && cachedFood.servings.isNotEmpty) {
      final serving = cachedFood.servings.first;
      final values = serving.calculateForAmount(pieces);

      return MealCalorieResult(
        foodName: cachedFood.name,
        normalizedName: normalizedFood.normalizedName,
        estimatedCalories: values.calories.round(),
        protein: values.protein,
        fat: values.fat,
        carbs: values.carbs,
        caloriesPer100g: cachedFood.caloriesPer100g,
        source: cachedFood.source,
        foodType: cachedFood.foodType ?? normalizedFood.foodType,
        confidence: cachedFood.confidence,
        isEstimated: cachedFood.isEstimated,
      );
    }

    final nutritionFood = await _nutritionRepository.findBestMatch(
      query: normalizedFood.searchQuery,
    );

    if (nutritionFood == null || nutritionFood.servings.isEmpty) {
      return null;
    }

    final serving = nutritionFood.servings.first;
    final values = serving.calculateForAmount(pieces);

    return MealCalorieResult(
      foodName: nutritionFood.name,
      normalizedName: normalizedFood.normalizedName,
      estimatedCalories: values.calories.round(),
      protein: values.protein,
      fat: values.fat,
      carbs: values.carbs,
      caloriesPer100g: nutritionFood.caloriesPer100g,
      source: nutritionFood.source,
      foodType: nutritionFood.foodType ?? normalizedFood.foodType,
      confidence: nutritionFood.confidence,
      isEstimated: nutritionFood.isEstimated,
    );
  }
}