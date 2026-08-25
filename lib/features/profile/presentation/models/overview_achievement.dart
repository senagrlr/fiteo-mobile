enum OverviewAchievementType {
  longestStreak,
  bestProtein,
  mostActiveDay,
  hydrationHero,
  nutritionPro,
  balancedDays,
  activeChampion,
  goalKeeper,
  calorieCompass,
  hydrationStreak,
}

class OverviewAchievement {
  final OverviewAchievementType type;
  final double strength;
  final String value;
  final String? secondaryValue;

  const OverviewAchievement({
    required this.type,
    required this.strength,
    required this.value,
    this.secondaryValue,
  });
}