class BarcodeFoodData {
  final String barcode;
  final String name;

  final String amount;
  final String unit;

  final int calories;
  final double protein;
  final double fats;
  final double carbs;

  final String nutritionSource;
  final bool isEstimated;

  const BarcodeFoodData({
    required this.barcode,
    required this.name,
    required this.amount,
    required this.unit,
    required this.calories,
    required this.protein,
    required this.fats,
    required this.carbs,
    this.nutritionSource = 'barcode',
    this.isEstimated = false,
  });
}