class AdherenceCalculator {
  const AdherenceCalculator();

  double targetCloseness({
    required double actual,
    required double goal,
  }) {
    if (goal <= 0) return 0;

    final differenceRatio =
        (actual - goal).abs() / goal;

    return ((1 - differenceRatio) * 100)
        .clamp(0, 100)
        .toDouble();
  }

  double? calorieAdherence({
    required double? netCalories,
    required double? calorieGoal,
  }) {
    if (netCalories == null ||
        calorieGoal == null ||
        calorieGoal <= 0) {
      return null;
    }

    return targetCloseness(
      actual: netCalories,
      goal: calorieGoal,
    );
  }

  double? hydrationAdherence({
    required double? hydrationMl,
    required double? waterGoalMl,
  }) {
    if (hydrationMl == null ||
        waterGoalMl == null ||
        waterGoalMl <= 0) {
      return null;
    }

    return (hydrationMl / waterGoalMl * 100)
        .clamp(0, 100)
        .toDouble();
  }
}