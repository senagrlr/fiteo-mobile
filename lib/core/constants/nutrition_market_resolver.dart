import 'package:fiteo_myapp/core/constants/nutrition_market.dart';

class NutritionMarketResolver {
  const NutritionMarketResolver._();

  static NutritionMarket fromLanguageCode(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'tr':
        return NutritionMarket.turkey;
      case 'en':
      default:
        return NutritionMarket.us;
    }
  }
}