import 'package:fiteo_myapp/features/ai/data/ai_service.dart';
import 'package:fiteo_myapp/features/meals/data/nutrition_repository.dart';
import 'package:fiteo_myapp/core/constants/nutrition_market.dart';
import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';
import 'package:fiteo_myapp/features/meals/data/fatsecret_food_cache_repository.dart';

class MealCalorieResult {
  final String foodId;
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
  final bool hasPer100gServing;
  final List<NutritionServing> servings;

  const MealCalorieResult({
    required this.foodId,
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
    this.hasPer100gServing = true,
    this.servings = const [],
  });
}

class MealCalorieService {
  final AiService _aiService = AiService();
  final FatSecretFoodCacheRepository _fatSecretCacheRepository =
    FatSecretFoodCacheRepository();
  final NutritionRepository _nutritionRepository;
  final NutritionMarket market;

  MealCalorieService({
    required this.market,
  }) : _nutritionRepository = NutritionRepository(market: market);

  String _cleanSearchQuery(String value) {
    return value.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  MealCalorieResult _lookupResultFromFood({
    required NutritionFood food,
    required String normalizedName,
  }) {
    return MealCalorieResult(
      foodId: food.id,
      foodName: food.name,
      normalizedName: normalizedName,
      estimatedCalories: food.caloriesPer100g.round(),
      protein: food.proteinPer100g,
      fat: food.fatPer100g,
      carbs: food.carbsPer100g,
      caloriesPer100g: food.caloriesPer100g,
      source: food.source,
      foodType: food.foodType ?? 'unknown',
      confidence: food.confidence,
      isEstimated: food.isEstimated,
      hasPer100gServing: food.hasPer100gServing,
      servings: food.servings,
    );
  }

  Future<MealCalorieResult?> lookupFood({
    required String foodName,
  }) async {
    final cleanQuery = _cleanSearchQuery(foodName);
    if (cleanQuery.isEmpty) return null;

    if (market == NutritionMarket.us) {
      final directFood = await _nutritionRepository.findBestMatch(
        query: cleanQuery,
      );

      if (directFood != null) {
        return _lookupResultFromFood(
          food: directFood,
          normalizedName: cleanQuery.toLowerCase(),
        );
      }
    }

    final normalizedFood = await _aiService.normalizeFoodName(cleanQuery);
    if (normalizedFood == null) return null;

    final nutritionFood = await _nutritionRepository.findBestMatch(
      query: normalizedFood.searchQuery,
    );

    if (nutritionFood == null) return null;

    return _lookupResultFromFood(
      food: nutritionFood,
      normalizedName: normalizedFood.normalizedName,
    );
  }

  Future<void> confirmFoodAlias({
    required String query,
    required MealCalorieResult result,
  }) async {
    if (market != NutritionMarket.us) {
      return;
    }

    if (result.source != 'fatsecret') {
      return;
    }

    if (result.foodId.trim().isEmpty) {
      return;
    }

    await _fatSecretCacheRepository.saveFoodAlias(
      query: query,
      foodId: result.foodId,
    );

    print(
      'FATSECRET FOOD CACHE CONFIRMED: '
          '$query -> ${result.foodId}',
    );
  }

  MealCalorieResult calculateLookupForGrams({
    required MealCalorieResult lookup,
    required int gram,
  }) {
    final multiplier = gram / 100;

    return MealCalorieResult(
      foodId: lookup.foodId,
      foodName: lookup.foodName,
      normalizedName: lookup.normalizedName,
      estimatedCalories: (lookup.caloriesPer100g * multiplier).round(),
      protein: lookup.protein * multiplier,
      fat: lookup.fat * multiplier,
      carbs: lookup.carbs * multiplier,
      caloriesPer100g: lookup.caloriesPer100g,
      source: lookup.source,
      foodType: lookup.foodType,
      confidence: lookup.confidence,
      isEstimated: lookup.isEstimated,
      hasPer100gServing: lookup.hasPer100gServing,
      servings: lookup.servings,
    );
  }

  MealCalorieResult? calculateLookupForServing({
    required MealCalorieResult lookup,
    required double amount,
    required String servingId,
    required bool isPiece,
  }) {
    NutritionServing? selectedServing;

    for (final serving in lookup.servings) {
      if (serving.id == servingId) {
        selectedServing = serving;
        break;
      }
    }

    if (selectedServing == null) return null;

    double multiplier = amount;

    if (isPiece) {
      final basePieceCount = _extractPhysicalUnitCount(
        selectedServing.description,
      );

      multiplier = amount / basePieceCount;
    }

    final values = selectedServing.calculateForAmount(multiplier);

    return MealCalorieResult(
      foodId: lookup.foodId,
      foodName: lookup.foodName,
      normalizedName: lookup.normalizedName,
      estimatedCalories: values.calories.round(),
      protein: values.protein,
      fat: values.fat,
      carbs: values.carbs,
      caloriesPer100g: lookup.caloriesPer100g,
      source: lookup.source,
      foodType: lookup.foodType,
      confidence: lookup.confidence,
      isEstimated: lookup.isEstimated,
      hasPer100gServing: lookup.hasPer100gServing,
      servings: lookup.servings,
    );
  }

  double _extractPhysicalUnitCount(String description) {
    final text = description.trim();

    final mixedFraction = RegExp(
      r'^(\d+)\s+(\d+)\/(\d+)\b',
    ).firstMatch(text);

    if (mixedFraction != null) {
      final whole = double.parse(mixedFraction.group(1)!);
      final numerator = double.parse(mixedFraction.group(2)!);
      final denominator = double.parse(mixedFraction.group(3)!);

      if (denominator == 0) return 1;

      return whole + (numerator / denominator);
    }

    final fraction = RegExp(
      r'^(\d+)\/(\d+)\b',
    ).firstMatch(text);

    if (fraction != null) {
      final numerator = double.parse(fraction.group(1)!);
      final denominator = double.parse(fraction.group(2)!);

      if (denominator == 0) return 1;

      return numerator / denominator;
    }

    final decimal = RegExp(
      r'^(\d+(?:\.\d+)?)\b',
    ).firstMatch(text);

    if (decimal != null) {
      return double.tryParse(decimal.group(1)!) ?? 1;
    }

    return 1;
  }
}