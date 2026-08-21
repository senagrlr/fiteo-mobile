import 'package:fiteo_myapp/features/meals/data/providers/legacy_nutrition_provider.dart';
import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';
import 'package:fiteo_myapp/features/meals/domain/providers/nutrition_provider.dart';
import 'package:fiteo_myapp/core/constants/nutrition_market.dart';
import 'package:fiteo_myapp/features/meals/data/providers/fatsecret_nutrition_provider.dart';

class NutritionRepository {
  final NutritionProvider _provider;
  final NutritionMarket market;

  NutritionRepository({
    required this.market,
    NutritionProvider? provider,
  }) : _provider =
      provider ?? _providerForMarket(market);

  static NutritionProvider _providerForMarket(
      NutritionMarket market,
      ) {
    switch (market) {
      case NutritionMarket.us:
        return FatSecretNutritionProvider();

      case NutritionMarket.turkey:
        return LegacyNutritionProvider();
    }
  }

  String get providerName => _provider.providerName;

  Future<List<NutritionFood>> searchFoods({
    required String query,
  }) async {
    final cleanQuery = query.trim();

    if (cleanQuery.isEmpty) {
      return [];
    }

    return _provider.searchFoods(
      query: cleanQuery,
    );
  }

  Future<NutritionFood?> findBestMatch({
    required String query,
  }) async {
    final foods = await searchFoods(query: query);

    if (foods.isEmpty) return null;

    return foods.first;
  }

  Future<NutritionFood?> getFoodDetails({
    required String id,
  }) {
    return _provider.getFoodDetails(
      id: id,
    );
  }
}