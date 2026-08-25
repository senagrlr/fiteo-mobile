class MonthlyTargetAccumulator {
  final String monthKey;
  final double accruedExpectedChangeKg;
  final DateTime? accruedThrough;

  const MonthlyTargetAccumulator({
    required this.monthKey,
    required this.accruedExpectedChangeKg,
    required this.accruedThrough,
  });
}