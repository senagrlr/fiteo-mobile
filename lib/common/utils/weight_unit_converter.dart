class WeightUnitConverter {
  const WeightUnitConverter._();

  static const double poundsPerKilogram = 2.2046226218;

  static double kgToDisplay({
    required double kg,
    required String unit,
  }) {
    return unit == 'lb'
        ? kg * poundsPerKilogram
        : kg;
  }

  static double displayToKg({
    required double value,
    required String unit,
  }) {
    return unit == 'lb'
        ? value / poundsPerKilogram
        : value;
  }

  static String format(double value) {
    if (value == value.roundToDouble()) {
      return value.round().toString();
    }

    return value.toStringAsFixed(1);
  }
}