import 'package:fiteo_myapp/features/profile/presentation/models/overview_achievement.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/overview_stats.dart';

class OverviewAchievementCalculator {
  const OverviewAchievementCalculator();

  List<OverviewAchievement> topAchievements(
      OverviewStats stats,
      ) {
    final achievements = [
      _longestStreak(stats),
      _bestProtein(stats),
      _mostActiveDay(stats),
      _hydrationHero(stats),
      _nutritionPro(stats),
      _balancedDays(stats),
      _activeChampion(stats),
      _goalKeeper(stats),
      _calorieCompass(stats),
      _hydrationStreak(stats),
    ];

    achievements.sort(
          (a, b) => b.strength.compareTo(a.strength),
    );

    final selected = <OverviewAchievement>[];

    for (final achievement in achievements) {
      if (achievement.strength <= 0) {
        continue;
      }

      final hasActivityAchievement = selected.any(
            (item) =>
        item.type == OverviewAchievementType.mostActiveDay ||
            item.type == OverviewAchievementType.activeChampion,
      );

      final isActivityAchievement =
          achievement.type ==
              OverviewAchievementType.mostActiveDay ||
              achievement.type ==
                  OverviewAchievementType.activeChampion;

      if (hasActivityAchievement && isActivityAchievement) {
        continue;
      }

      selected.add(achievement);

      if (selected.length == 3) {
        break;
      }
    }

    return selected;
  }

  double _confidence(int count, {int fullConfidenceAt = 7}) {
    if (count <= 0) return 0;

    return (count / fullConfidenceAt)
        .clamp(0, 1)
        .toDouble();
  }

  OverviewAchievement _longestStreak(
      OverviewStats stats,
      ) {
    final strength =
    (stats.longestTrackingStreak / 30 * 100)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.longestStreak,
      strength: strength,
      value: stats.longestTrackingStreak.toString(),
    );
  }

  OverviewAchievement _bestProtein(
      OverviewStats stats,
      ) {
    final confidence = _confidence(
      stats.nutritionAdherenceCount,
    );

    final strength =
    (stats.bestProteinAdherence * confidence)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.bestProtein,
      strength: strength,
      value: _formatNumber(stats.bestProteinValue),
      secondaryValue:
      '${stats.bestProteinAdherence.round()}%',
    );
  }

  OverviewAchievement _mostActiveDay(
      OverviewStats stats,
      ) {
    String bestDay = 'monday';
    var bestMinutes = 0;

    for (final entry
    in stats.weekdayWorkoutMinutes.entries) {
      if (entry.value > bestMinutes) {
        bestMinutes = entry.value;
        bestDay = entry.key;
      }
    }

    if (stats.trackingEligibleDays == 0) {
      return OverviewAchievement(
        type: OverviewAchievementType.mostActiveDay,
        strength: 0,
        value: bestDay,
      );
    }

    final expectedActiveDays =
        stats.trackingEligibleDays * 3 / 7;

    final strength =
    expectedActiveDays <= 0
        ? 0.0
        : (stats.activeDays /
        expectedActiveDays *
        100)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.mostActiveDay,
      strength: strength,
      value: bestDay,
    );
  }

  OverviewAchievement _hydrationHero(
      OverviewStats stats,
      ) {
    final confidence = _confidence(
      stats.waterAdherenceCount,
    );

    final strength =
    (stats.waterAdherence * confidence)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.hydrationHero,
      strength: strength,
      value: '${stats.waterAdherence.round()}%',
    );
  }

  OverviewAchievement _nutritionPro(
      OverviewStats stats,
      ) {
    final confidence = _confidence(
      stats.nutritionAdherenceCount,
    );

    final strength =
    (stats.nutritionAdherence * confidence)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.nutritionPro,
      strength: strength,
      value: '${stats.nutritionAdherence.round()}%',
    );
  }

  OverviewAchievement _balancedDays(
      OverviewStats stats,
      ) {
    if (stats.nutritionAdherenceCount == 0) {
      return const OverviewAchievement(
        type: OverviewAchievementType.balancedDays,
        strength: 0,
        value: '0',
      );
    }

    final rate =
        stats.balancedDays /
            stats.nutritionAdherenceCount *
            100;

    final confidence = _confidence(
      stats.nutritionAdherenceCount,
    );

    final strength =
    (rate * confidence)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.balancedDays,
      strength: strength,
      value: stats.balancedDays.toString(),
    );
  }

  OverviewAchievement _activeChampion(
      OverviewStats stats,
      ) {
    if (stats.trackingEligibleDays == 0) {
      return const OverviewAchievement(
        type: OverviewAchievementType.activeChampion,
        strength: 0,
        value: '0',
      );
    }

    final expectedActiveDays =
        stats.trackingEligibleDays * 3 / 7;

    final strength =
    expectedActiveDays <= 0
        ? 0.0
        : (stats.activeDays /
        expectedActiveDays *
        100)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.activeChampion,
      strength: strength,
      value: stats.activeDays.toString(),
    );
  }

  OverviewAchievement _goalKeeper(
      OverviewStats stats,
      ) {
    final candidates = <String, int>{
      'calories': stats.calorieGoalHitDays,
      'protein': stats.proteinGoalHitDays,
      'carbs': stats.carbsGoalHitDays,
      'fat': stats.fatGoalHitDays,
      'water': stats.waterGoalHitDays,
    };

    var bestGoal = 'calories';
    var bestDays = 0;

    for (final entry in candidates.entries) {
      if (entry.value > bestDays) {
        bestGoal = entry.key;
        bestDays = entry.value;
      }
    }

    final denominator = bestGoal == 'water'
        ? stats.waterAdherenceCount
        : stats.nutritionAdherenceCount;

    final confidence = _confidence(denominator);

    final strength =
    denominator == 0
        ? 0.0
        : (bestDays / denominator * 100 * confidence)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.goalKeeper,
      strength: strength,
      value: bestGoal,
      secondaryValue: bestDays.toString(),
    );
  }

  OverviewAchievement _calorieCompass(
      OverviewStats stats,
      ) {
    final confidence = _confidence(
      stats.calorieAdherenceCount,
    );

    final strength =
    (stats.calorieAdherence * confidence)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.calorieCompass,
      strength: strength,
      value: '${stats.calorieAdherence.round()}%',
    );
  }

  OverviewAchievement _hydrationStreak(
      OverviewStats stats,
      ) {
    final strength =
    (stats.longestHydrationStreak / 14 * 100)
        .clamp(0, 100)
        .toDouble();

    return OverviewAchievement(
      type: OverviewAchievementType.hydrationStreak,
      strength: strength,
      value: stats.longestHydrationStreak.toString(),
    );
  }

  String _formatNumber(double value) {
    return value == value.roundToDouble()
        ? value.round().toString()
        : value.toStringAsFixed(1);
  }
}