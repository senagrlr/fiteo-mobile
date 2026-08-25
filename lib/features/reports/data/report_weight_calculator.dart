class ReportWeightCalculator {
  const ReportWeightCalculator();

  double? calculateWeightChangeKg({
    required double? startWeightKg,
    required double? currentWeightKg,
  }) {
    if (startWeightKg == null || currentWeightKg == null) {
      return null;
    }

    return currentWeightKg - startWeightKg;
  }

  int? calculateProgressAchievedPercent({
    required double? startWeightKg,
    required double? currentWeightKg,
    required double? targetChangeKg,
  }) {
    if (startWeightKg == null ||
        currentWeightKg == null ||
        targetChangeKg == null ||
        targetChangeKg.abs() < 0.01) {
      return null;
    }

    final actualChangeKg = currentWeightKg - startWeightKg;

    if (actualChangeKg.abs() < 0.01) {
      return 0;
    }

    final movingInTargetDirection =
        actualChangeKg.sign == targetChangeKg.sign;

    if (!movingInTargetDirection) {
      return 0;
    }

    return (actualChangeKg.abs() / targetChangeKg.abs() * 100).round();
  }
}