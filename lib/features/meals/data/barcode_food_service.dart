import 'package:fiteo_myapp/features/meals/data/fatsecret_api_service.dart';
import 'package:fiteo_myapp/features/meals/data/fatsecret_barcode_cache_repository.dart';
import 'package:fiteo_myapp/features/meals/domain/models/barcode_food_data.dart';

class BarcodeFoodService {
  final FatSecretApiService _apiService;
  final FatSecretBarcodeCacheRepository
  _cacheRepository;

  BarcodeFoodService({
    FatSecretApiService? apiService,
    FatSecretBarcodeCacheRepository?
    cacheRepository,
  })  : _apiService =
      apiService ?? FatSecretApiService(),
        _cacheRepository =
            cacheRepository ??
                FatSecretBarcodeCacheRepository();

  Future<BarcodeFoodData?> findFood({
    required String barcode,
  }) async {
    final normalizedBarcode =
    _cacheRepository.normalizeBarcode(
      barcode,
    );

    if (normalizedBarcode == null) {
      return null;
    }

    var foodId =
    await _cacheRepository
        .getFoodIdForBarcode(
      normalizedBarcode,
    );

    if (foodId == null) {
      foodId =
      await _apiService
          .findFoodIdByBarcode(
        barcode: normalizedBarcode,
      );

      if (foodId == null) {
        return null;
      }

      await _cacheRepository
          .saveBarcodeAlias(
        barcode: normalizedBarcode,
        foodId: foodId,
      );
    }

    final details =
    await _apiService.getFoodDetails(
      id: foodId,
    );

    if (details == null ||
        details.name.trim().isEmpty) {
      return null;
    }

    final serving =
    _selectServing(details);

    if (serving == null) {
      return null;
    }

    final amount =
    serving.metricAmount != null
        ? _formatAmount(
      serving.metricAmount!,
    )
        : '1';

    final unit =
    serving.metricUnit?.trim().isNotEmpty ==
        true
        ? serving.metricUnit!.trim()
        : serving.description.trim().isNotEmpty
        ? serving.description.trim()
        : 'serving';

    return BarcodeFoodData(
      barcode: normalizedBarcode,
      name: details.name,
      amount: amount,
      unit: unit,
      calories: serving.calories.round(),
      protein: serving.protein,
      fats: serving.fat,
      carbs: serving.carbs,
      nutritionSource: 'fatsecret',
      isEstimated: false,
    );
  }

  FatSecretServing? _selectServing(
      FatSecretFoodDetails details,
      ) {
    if (details.servings.isEmpty) {
      return null;
    }

    for (final serving
    in details.servings) {
      if (serving.isDefault) {
        return serving;
      }
    }

    for (final serving
    in details.servings) {
      if (serving.metricAmount == 100 &&
          serving.metricUnit
              ?.toLowerCase() ==
              'g') {
        return serving;
      }
    }

    return details.servings.first;
  }

  String _formatAmount(double value) {
    if (value == value.roundToDouble()) {
      return value.toInt().toString();
    }

    return value.toStringAsFixed(1);
  }
}