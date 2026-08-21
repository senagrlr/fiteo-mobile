import 'package:fiteo_myapp/features/meals/domain/models/nutrition_food.dart';

enum ServingType {
  grams,
  piece,
  serving,
  cup,
  tablespoon,
  can,
  bottle,
  bowl,
  package,
  ounce,
  fluidOunce,
}

class FoodServingOption {
  final ServingType type;
  final String label;
  final String? servingId;
  final String? rawDescription;

  const FoodServingOption({
    required this.type,
    required this.label,
    this.servingId,
    this.rawDescription,
  });

  const FoodServingOption.grams()
      : type = ServingType.grams,
        label = 'Grams',
        servingId = null,
        rawDescription = null;

  String get key {
    if (type == ServingType.grams) {
      return 'grams';
    }

    return '${type.name}_${servingId ?? ''}';
  }
}

class ServingNormalizer {
  const ServingNormalizer._();

  static String _normalize(String value) {
    return value.toLowerCase().trim();
  }

  static bool _containsWord(String text, String word) {
    return RegExp('\\b${RegExp.escape(word)}\\b').hasMatch(text);
  }

  static bool _isChipServing(String text) {
    return _containsWord(text, 'chip') || _containsWord(text, 'chips');
  }

  static bool _isPieceCandidate(String text) {
    if (_isChipServing(text)) {
      return false;
    }

    return _containsWord(text, 'piece') ||
        _containsWord(text, 'pieces') ||
        _containsWord(text, 'cookie') ||
        _containsWord(text, 'cookies') ||
        _containsWord(text, 'biscuit') ||
        _containsWord(text, 'biscuits') ||
        _containsWord(text, 'cracker') ||
        _containsWord(text, 'crackers') ||
        _containsWord(text, 'bar') ||
        _containsWord(text, 'bars') ||
        _containsWord(text, 'item') ||
        _containsWord(text, 'unit') ||
        _containsWord(text, 'whole') ||
        _containsWord(text, 'small') ||
        _containsWord(text, 'medium') ||
        _containsWord(text, 'large');
  }

  static String _singularize(String value) {
    final text = value.toLowerCase().trim();

    if (text.endsWith('ies') && text.length > 3) {
      return '${text.substring(0, text.length - 3)}y';
    }

    if (text.endsWith('es') && text.length > 2) {
      return text.substring(0, text.length - 2);
    }

    if (text.endsWith('s') && text.length > 1) {
      return text.substring(0, text.length - 1);
    }

    return text;
  }

  static bool _isNamedFoodPiece(
      String description,
      String? foodName,
      ) {
    if (foodName == null || foodName.trim().isEmpty) {
      return false;
    }

    final descriptionText = _normalize(description)
        .replaceAll(RegExp(r'\([^)]*\)'), '')
        .trim();

    final nameText = _normalize(foodName);

    final match = RegExp(
      r'^\s*(?:\d+(?:\.\d+)?|\d+\/\d+|\d+\s+\d+\/\d+)\s+(.+)$',
    ).firstMatch(descriptionText);

    if (match == null) {
      return false;
    }

    final servingName = _singularize(match.group(1)!.trim());

    final foodWords = nameText
        .split(RegExp(r'\s+'))
        .map(_singularize)
        .toList();

    return foodWords.contains(servingName);
  }

  static bool _isChipLikeFood(String? foodName) {
    if (foodName == null) return false;

    final text = _normalize(foodName);

    return text.contains('chip') ||
        text.contains('chips') ||
        text.contains('crisp') ||
        text.contains('crisps') ||
        text.contains('cheetos') ||
        text.contains('doritos') ||
        text.contains("lay's") ||
        text.contains('lays') ||
        text.contains('pringles');
  }

  static ServingType? _typeForDescription(
      String description, {
        String? foodName,
      }) {
    final text = _normalize(description);

    if (_containsWord(text, 'bag') ||
        _containsWord(text, 'pack') ||
        _containsWord(text, 'packet') ||
        _containsWord(text, 'package') ||
        _containsWord(text, 'pouch') ||
        _containsWord(text, 'box') ||
        _containsWord(text, 'boxes')) {
      return ServingType.package;
    }

    if (_containsWord(text, 'cup') || _containsWord(text, 'mug')) {
      return ServingType.cup;
    }

    if (_containsWord(text, 'tablespoon') ||
        _containsWord(text, 'tablespoons') ||
        _containsWord(text, 'tbsp')) {
      return ServingType.tablespoon;
    }

    if (_containsWord(text, 'can') || _containsWord(text, 'tin')) {
      return ServingType.can;
    }

    if (_containsWord(text, 'bottle')) {
      return ServingType.bottle;
    }

    if (_containsWord(text, 'bowl')) {
      return ServingType.bowl;
    }

    if (_isPieceCandidate(text) || _isNamedFoodPiece(description, foodName)) {
      return ServingType.piece;
    }

    if (_containsWord(text, 'serving') || _containsWord(text, 'portion')) {
      return ServingType.serving;
    }

    if (text.contains('fl oz') ||
        text.contains('fluid ounce') ||
        text.contains('fluid ounces')) {
      return ServingType.fluidOunce;
    }

    if (_containsWord(text, 'oz') || _containsWord(text, 'ounce')) {
      return ServingType.ounce;
    }

    return null;
  }

  static int _priority(ServingType type, String description) {
    final text = _normalize(description);

    switch (type) {
      case ServingType.piece:
        if (_containsWord(text, 'piece')) return 100;
        if (_containsWord(text, 'cookie')) return 95;
        if (_containsWord(text, 'biscuit')) return 95;
        if (_containsWord(text, 'bar')) return 95;
        if (_containsWord(text, 'cracker')) return 90;
        if (_containsWord(text, 'medium')) return 85;
        if (_containsWord(text, 'whole')) return 80;
        if (_containsWord(text, 'small')) return 70;
        if (_containsWord(text, 'large')) return 60;
        return 50;

      case ServingType.cup:
        if (_containsWord(text, 'cup')) return 100;
        if (_containsWord(text, 'mug')) return 80;
        return 50;

      case ServingType.package:
        if (_containsWord(text, 'package')) return 100;
        if (_containsWord(text, 'pack')) return 95;
        if (_containsWord(text, 'bag')) return 90;
        if (_containsWord(text, 'packet')) return 85;
        if (_containsWord(text, 'pouch')) return 80;
        return 50;

      case ServingType.can:
        if (_containsWord(text, 'can')) return 100;
        if (_containsWord(text, 'tin')) return 80;
        return 50;

      default:
        return 100;
    }
  }

  static String labelForType(ServingType type) {
    switch (type) {
      case ServingType.grams:
        return 'Grams';
      case ServingType.piece:
        return 'Piece';
      case ServingType.serving:
        return 'Serving';
      case ServingType.cup:
        return 'Cup';
      case ServingType.tablespoon:
        return 'tbsp';
      case ServingType.can:
        return 'Can';
      case ServingType.bottle:
        return 'Bottle';
      case ServingType.bowl:
        return 'Bowl';
      case ServingType.package:
        return 'Package';
      case ServingType.ounce:
        return 'oz';
      case ServingType.fluidOunce:
        return 'fl oz';
    }
  }

  static List<FoodServingOption> buildOptions(
      List<NutritionServing> servings, {
        String? foodName,
        bool hasPer100gServing = true,
      }) {
    final bestByType = <ServingType, NutritionServing>{};

    for (final serving in servings) {
      final type = _typeForDescription(
        serving.description,
        foodName: foodName,
      );

      if (type == ServingType.piece &&
          _isChipLikeFood(foodName)) {
        continue;
      }

      if (type == null) {
        continue;
      }

      final existing = bestByType[type];

      if (existing == null ||
          _priority(type, serving.description) >
              _priority(type, existing.description)) {
        bestByType[type] = serving;
      }
    }

    const order = [
      ServingType.piece,
      ServingType.serving,
      ServingType.cup,
      ServingType.tablespoon,
      ServingType.can,
      ServingType.bottle,
      ServingType.bowl,
      ServingType.package,
      ServingType.ounce,
      ServingType.fluidOunce,
    ];

    final options = <FoodServingOption>[];

    if (hasPer100gServing) {
      options.add(const FoodServingOption.grams());
    }

    for (final type in order) {
      final serving = bestByType[type];

      if (serving == null) {
        continue;
      }

      options.add(
        FoodServingOption(
          type: type,
          label: labelForType(type),
          servingId: serving.id,
          rawDescription: serving.description,
        ),
      );
    }

    return options;
  }
}