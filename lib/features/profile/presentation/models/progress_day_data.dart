class ProgressDayData {
  final String date;

  final double calories;
  final double protein;
  final double carbs;
  final double fat;

  final double? calorieGoal;
  final double? proteinGoal;
  final double? carbsGoal;
  final double? fatGoal;

  final int hydrationMl;
  final int? waterGoalMl;

  final int workoutMinutes;
  final int workoutCount;
  final bool isActiveDay;

  const ProgressDayData({
    required this.date,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.calorieGoal,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.hydrationMl,
    required this.waterGoalMl,
    required this.workoutMinutes,
    required this.workoutCount,
    required this.isActiveDay,
  });

  factory ProgressDayData.fromSummary(
      String date,
      Map<String, dynamic> data,
      ) {
    final workoutMinutes =
        (data['workoutMinutes'] as num?)?.round() ?? 0;

    return ProgressDayData(
      date: date,

      // Nutrition Progress calories = net calories.
      calories:
      (data['netCalories'] as num?)?.toDouble() ?? 0,

      protein:
      (data['protein'] as num?)?.toDouble() ?? 0,

      carbs:
      (data['carbs'] as num?)?.toDouble() ?? 0,

      fat:
      (data['fats'] as num?)?.toDouble() ?? 0,

      calorieGoal:
      (data['calorieGoal'] as num?)?.toDouble(),

      proteinGoal:
      (data['proteinGoal'] as num?)?.toDouble(),

      carbsGoal:
      (data['carbsGoal'] as num?)?.toDouble(),

      fatGoal:
      (data['fatGoal'] as num?)?.toDouble(),

      hydrationMl:
      (data['hydrationMl'] as num?)?.round() ?? 0,

      waterGoalMl:
      (data['waterGoalMl'] as num?)?.round(),

      workoutMinutes: workoutMinutes,

      workoutCount:
      (data['workoutCount'] as num?)?.round() ?? 0,

      // Eski dailySummary belgeleri için fallback.
      isActiveDay:
      data['isActiveDay'] as bool? ??
          workoutMinutes >= 20,
    );
  }

  factory ProgressDayData.fromMap(
      String date,
      Map<String, dynamic> data,
      ) {
    return ProgressDayData(
      date: date,

      calories:
      (data['calories'] as num?)?.toDouble() ?? 0,

      protein:
      (data['protein'] as num?)?.toDouble() ?? 0,

      carbs:
      (data['carbs'] as num?)?.toDouble() ?? 0,

      fat:
      (data['fat'] as num?)?.toDouble() ?? 0,

      calorieGoal:
      (data['calorieGoal'] as num?)?.toDouble(),

      proteinGoal:
      (data['proteinGoal'] as num?)?.toDouble(),

      carbsGoal:
      (data['carbsGoal'] as num?)?.toDouble(),

      fatGoal:
      (data['fatGoal'] as num?)?.toDouble(),

      hydrationMl:
      (data['hydrationMl'] as num?)?.round() ?? 0,

      waterGoalMl:
      (data['waterGoalMl'] as num?)?.round(),

      workoutMinutes:
      (data['workoutMinutes'] as num?)?.round() ?? 0,

      workoutCount:
      (data['workoutCount'] as num?)?.round() ?? 0,

      isActiveDay:
      data['isActiveDay'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,

      'calorieGoal': calorieGoal,
      'proteinGoal': proteinGoal,
      'carbsGoal': carbsGoal,
      'fatGoal': fatGoal,

      'hydrationMl': hydrationMl,
      'waterGoalMl': waterGoalMl,

      'workoutMinutes': workoutMinutes,
      'workoutCount': workoutCount,
      'isActiveDay': isActiveDay,
    };
  }
}