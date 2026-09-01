class OverviewStats {
  String? lastProcessedDate;

  int trackingEligibleDays;
  int trackedDays;

  double nutritionAdherenceSum;
  int nutritionAdherenceCount;

  double waterAdherenceSum;
  int waterAdherenceCount;

  double calorieAdherenceSum;
  int calorieAdherenceCount;

  int successfulGoalChecks;
  int totalGoalChecks;

  int currentTrackingStreak;
  int longestTrackingStreak;

  int currentHydrationStreak;
  int longestHydrationStreak;

  int activeDays;
  int totalWorkoutMinutes;

  Map<String, int> weekdayWorkoutMinutes;

  int calorieGoalHitDays;
  int proteinGoalHitDays;
  int carbsGoalHitDays;
  int fatGoalHitDays;
  int waterGoalHitDays;

  int balancedDays;

  double bestProteinAdherence;
  double bestProteinValue;
  String? bestProteinDate;

  int fiteoScore;
  String? fiteoScoreDate;

  String? aiNote;
  String? aiNoteDate;

  OverviewStats({
    this.lastProcessedDate,
    this.trackingEligibleDays = 0,
    this.trackedDays = 0,
    this.nutritionAdherenceSum = 0,
    this.nutritionAdherenceCount = 0,
    this.waterAdherenceSum = 0,
    this.waterAdherenceCount = 0,
    this.calorieAdherenceSum = 0,
    this.calorieAdherenceCount = 0,
    this.successfulGoalChecks = 0,
    this.totalGoalChecks = 0,
    this.currentTrackingStreak = 0,
    this.longestTrackingStreak = 0,
    this.currentHydrationStreak = 0,
    this.longestHydrationStreak = 0,
    this.activeDays = 0,
    this.totalWorkoutMinutes = 0,
    Map<String, int>? weekdayWorkoutMinutes,
    this.calorieGoalHitDays = 0,
    this.proteinGoalHitDays = 0,
    this.carbsGoalHitDays = 0,
    this.fatGoalHitDays = 0,
    this.waterGoalHitDays = 0,
    this.balancedDays = 0,
    this.bestProteinAdherence = 0,
    this.bestProteinValue = 0,
    this.bestProteinDate,
    this.fiteoScore = 0,
    this.fiteoScoreDate,
    this.aiNote,
    this.aiNoteDate,
  }) : weekdayWorkoutMinutes =
      weekdayWorkoutMinutes ??
          {
            'monday': 0,
            'tuesday': 0,
            'wednesday': 0,
            'thursday': 0,
            'friday': 0,
            'saturday': 0,
            'sunday': 0,
          };

  factory OverviewStats.fromMap(Map<String, dynamic> data) {
    final rawWeekdays =
    data['weekdayWorkoutMinutes'] as Map<String, dynamic>?;

    return OverviewStats(
      lastProcessedDate: data['lastProcessedDate'] as String?,
      trackingEligibleDays:
      (data['trackingEligibleDays'] as num?)?.round() ?? 0,
      trackedDays:
      (data['trackedDays'] as num?)?.round() ?? 0,
      nutritionAdherenceSum:
      (data['nutritionAdherenceSum'] as num?)?.toDouble() ?? 0,
      nutritionAdherenceCount:
      (data['nutritionAdherenceCount'] as num?)?.round() ?? 0,
      waterAdherenceSum:
      (data['waterAdherenceSum'] as num?)?.toDouble() ?? 0,
      waterAdherenceCount:
      (data['waterAdherenceCount'] as num?)?.round() ?? 0,
      calorieAdherenceSum:
      (data['calorieAdherenceSum'] as num?)?.toDouble() ?? 0,
      calorieAdherenceCount:
      (data['calorieAdherenceCount'] as num?)?.round() ?? 0,
      successfulGoalChecks:
      (data['successfulGoalChecks'] as num?)?.round() ?? 0,
      totalGoalChecks:
      (data['totalGoalChecks'] as num?)?.round() ?? 0,
      currentTrackingStreak:
      (data['currentTrackingStreak'] as num?)?.round() ?? 0,
      longestTrackingStreak:
      (data['longestTrackingStreak'] as num?)?.round() ?? 0,
      currentHydrationStreak:
      (data['currentHydrationStreak'] as num?)?.round() ?? 0,
      longestHydrationStreak:
      (data['longestHydrationStreak'] as num?)?.round() ?? 0,
      activeDays:
      (data['activeDays'] as num?)?.round() ?? 0,
      totalWorkoutMinutes:
      (data['totalWorkoutMinutes'] as num?)?.round() ?? 0,
      weekdayWorkoutMinutes: {
        'monday':
        (rawWeekdays?['monday'] as num?)?.round() ?? 0,
        'tuesday':
        (rawWeekdays?['tuesday'] as num?)?.round() ?? 0,
        'wednesday':
        (rawWeekdays?['wednesday'] as num?)?.round() ?? 0,
        'thursday':
        (rawWeekdays?['thursday'] as num?)?.round() ?? 0,
        'friday':
        (rawWeekdays?['friday'] as num?)?.round() ?? 0,
        'saturday':
        (rawWeekdays?['saturday'] as num?)?.round() ?? 0,
        'sunday':
        (rawWeekdays?['sunday'] as num?)?.round() ?? 0,
      },
      calorieGoalHitDays:
      (data['calorieGoalHitDays'] as num?)?.round() ?? 0,
      proteinGoalHitDays:
      (data['proteinGoalHitDays'] as num?)?.round() ?? 0,
      carbsGoalHitDays:
      (data['carbsGoalHitDays'] as num?)?.round() ?? 0,
      fatGoalHitDays:
      (data['fatGoalHitDays'] as num?)?.round() ?? 0,
      waterGoalHitDays:
      (data['waterGoalHitDays'] as num?)?.round() ?? 0,
      balancedDays:
      (data['balancedDays'] as num?)?.round() ?? 0,
      bestProteinAdherence:
      (data['bestProteinAdherence'] as num?)?.toDouble() ?? 0,
      bestProteinValue:
      (data['bestProteinValue'] as num?)?.toDouble() ?? 0,
      bestProteinDate:
      data['bestProteinDate'] as String?,
      fiteoScore:
      (data['fiteoScore'] as num?)?.round() ?? 0,
      fiteoScoreDate:
      data['fiteoScoreDate'] as String?,
      aiNote:
      data['aiNote'] as String?,
      aiNoteDate:
      data['aiNoteDate'] as String?,
    );
  }

  double get trackingConsistency {
    if (trackingEligibleDays == 0) return 0;

    return (trackedDays / trackingEligibleDays * 100)
        .clamp(0, 100)
        .toDouble();
  }

  double get goalAchievement {
    if (totalGoalChecks == 0) return 0;

    return (successfulGoalChecks / totalGoalChecks * 100)
        .clamp(0, 100)
        .toDouble();
  }

  double get nutritionAdherence {
    if (nutritionAdherenceCount == 0) return 0;

    return nutritionAdherenceSum / nutritionAdherenceCount;
  }

  double get waterAdherence {
    if (waterAdherenceCount == 0) return 0;

    return waterAdherenceSum / waterAdherenceCount;
  }

  double get calorieAdherence {
    if (calorieAdherenceCount == 0) return 0;

    return calorieAdherenceSum / calorieAdherenceCount;
  }

  Map<String, dynamic> toMap() {
    return {
      'lastProcessedDate': lastProcessedDate,
      'trackingEligibleDays': trackingEligibleDays,
      'trackedDays': trackedDays,
      'nutritionAdherenceSum': nutritionAdherenceSum,
      'nutritionAdherenceCount': nutritionAdherenceCount,
      'waterAdherenceSum': waterAdherenceSum,
      'waterAdherenceCount': waterAdherenceCount,
      'calorieAdherenceSum': calorieAdherenceSum,
      'calorieAdherenceCount': calorieAdherenceCount,
      'successfulGoalChecks': successfulGoalChecks,
      'totalGoalChecks': totalGoalChecks,
      'currentTrackingStreak': currentTrackingStreak,
      'longestTrackingStreak': longestTrackingStreak,
      'currentHydrationStreak': currentHydrationStreak,
      'longestHydrationStreak': longestHydrationStreak,
      'activeDays': activeDays,
      'totalWorkoutMinutes': totalWorkoutMinutes,
      'weekdayWorkoutMinutes': weekdayWorkoutMinutes,
      'calorieGoalHitDays': calorieGoalHitDays,
      'proteinGoalHitDays': proteinGoalHitDays,
      'carbsGoalHitDays': carbsGoalHitDays,
      'fatGoalHitDays': fatGoalHitDays,
      'waterGoalHitDays': waterGoalHitDays,
      'balancedDays': balancedDays,
      'bestProteinAdherence': bestProteinAdherence,
      'bestProteinValue': bestProteinValue,
      'bestProteinDate': bestProteinDate,
      'fiteoScore': fiteoScore,
      'fiteoScoreDate': fiteoScoreDate,
      'aiNote': aiNote,
      'aiNoteDate': aiNoteDate,
    };
  }
}