import 'package:fiteo_myapp/features/profile/presentation/models/progress_day_data.dart';

class ProgressMonthData {
  double caloriesSum;
  double proteinSum;
  double carbsSum;
  double fatSum;

  double calorieGoalSum;
  double proteinGoalSum;
  double carbsGoalSum;
  double fatGoalSum;

  int calorieGoalCount;
  int proteinGoalCount;
  int carbsGoalCount;
  int fatGoalCount;

  int hydrationSum;

  int waterGoalSum;
  int waterGoalCount;

  int workoutMinutesSum;
  int workoutCount;
  int activeDays;

  int calorieTargetDays;
  int proteinTargetDays;
  int carbsTargetDays;
  int fatTargetDays;
  int waterTargetDays;

  int dayCount;

  ProgressMonthData({
    this.caloriesSum = 0,
    this.proteinSum = 0,
    this.carbsSum = 0,
    this.fatSum = 0,

    this.calorieGoalSum = 0,
    this.proteinGoalSum = 0,
    this.carbsGoalSum = 0,
    this.fatGoalSum = 0,

    this.calorieGoalCount = 0,
    this.proteinGoalCount = 0,
    this.carbsGoalCount = 0,
    this.fatGoalCount = 0,

    this.hydrationSum = 0,

    this.waterGoalSum = 0,
    this.waterGoalCount = 0,

    this.workoutMinutesSum = 0,
    this.workoutCount = 0,
    this.activeDays = 0,

    this.calorieTargetDays = 0,
    this.proteinTargetDays = 0,
    this.carbsTargetDays = 0,
    this.fatTargetDays = 0,
    this.waterTargetDays = 0,

    this.dayCount = 0,
  });

  factory ProgressMonthData.fromMap(
      Map<String, dynamic> data,
      ) {
    return ProgressMonthData(
      caloriesSum:
      (data['caloriesSum'] as num?)?.toDouble() ?? 0,

      proteinSum:
      (data['proteinSum'] as num?)?.toDouble() ?? 0,

      carbsSum:
      (data['carbsSum'] as num?)?.toDouble() ?? 0,

      fatSum:
      (data['fatSum'] as num?)?.toDouble() ?? 0,

      calorieGoalSum:
      (data['calorieGoalSum'] as num?)?.toDouble() ?? 0,

      proteinGoalSum:
      (data['proteinGoalSum'] as num?)?.toDouble() ?? 0,

      carbsGoalSum:
      (data['carbsGoalSum'] as num?)?.toDouble() ?? 0,

      fatGoalSum:
      (data['fatGoalSum'] as num?)?.toDouble() ?? 0,

      calorieGoalCount:
      (data['calorieGoalCount'] as num?)?.round() ?? 0,

      proteinGoalCount:
      (data['proteinGoalCount'] as num?)?.round() ?? 0,

      carbsGoalCount:
      (data['carbsGoalCount'] as num?)?.round() ?? 0,

      fatGoalCount:
      (data['fatGoalCount'] as num?)?.round() ?? 0,

      hydrationSum:
      (data['hydrationSum'] as num?)?.round() ?? 0,

      waterGoalSum:
      (data['waterGoalSum'] as num?)?.round() ?? 0,

      waterGoalCount:
      (data['waterGoalCount'] as num?)?.round() ?? 0,

      workoutMinutesSum:
      (data['workoutMinutesSum'] as num?)?.round() ?? 0,

      workoutCount:
      (data['workoutCount'] as num?)?.round() ?? 0,

      activeDays:
      (data['activeDays'] as num?)?.round() ?? 0,

      calorieTargetDays:
      (data['calorieTargetDays'] as num?)?.round() ?? 0,

      proteinTargetDays:
      (data['proteinTargetDays'] as num?)?.round() ?? 0,

      carbsTargetDays:
      (data['carbsTargetDays'] as num?)?.round() ?? 0,

      fatTargetDays:
      (data['fatTargetDays'] as num?)?.round() ?? 0,

      waterTargetDays:
      (data['waterTargetDays'] as num?)?.round() ?? 0,

      dayCount:
      (data['dayCount'] as num?)?.round() ?? 0,
    );
  }

  void addDay(ProgressDayData day) {
    dayCount++;

    caloriesSum += day.calories;
    proteinSum += day.protein;
    carbsSum += day.carbs;
    fatSum += day.fat;

    if (day.calorieGoal != null) {
      calorieGoalSum += day.calorieGoal!;
      calorieGoalCount++;
    }

    if (day.proteinGoal != null) {
      proteinGoalSum += day.proteinGoal!;
      proteinGoalCount++;
    }

    if (day.carbsGoal != null) {
      carbsGoalSum += day.carbsGoal!;
      carbsGoalCount++;
    }

    if (day.fatGoal != null) {
      fatGoalSum += day.fatGoal!;
      fatGoalCount++;
    }

    hydrationSum += day.hydrationMl;

    if (day.waterGoalMl != null) {
      waterGoalSum += day.waterGoalMl!;
      waterGoalCount++;
    }

    if (day.calorieGoal != null &&
        day.calorieGoal! > 0 &&
        day.calories >= day.calorieGoal!) {
      calorieTargetDays++;
    }

    if (day.proteinGoal != null &&
        day.proteinGoal! > 0 &&
        day.protein >= day.proteinGoal!) {
      proteinTargetDays++;
    }

    if (day.carbsGoal != null &&
        day.carbsGoal! > 0 &&
        day.carbs >= day.carbsGoal!) {
      carbsTargetDays++;
    }

    if (day.fatGoal != null &&
        day.fatGoal! > 0 &&
        day.fat >= day.fatGoal!) {
      fatTargetDays++;
    }

    if (day.waterGoalMl != null &&
        day.waterGoalMl! > 0 &&
        day.hydrationMl >= day.waterGoalMl!) {
      waterTargetDays++;
    }

    workoutMinutesSum += day.workoutMinutes;
    workoutCount += day.workoutCount;

    if (day.isActiveDay) {
      activeDays++;
    }
  }

  Map<String, dynamic> toMap() {
    return {
      'caloriesSum': caloriesSum,
      'proteinSum': proteinSum,
      'carbsSum': carbsSum,
      'fatSum': fatSum,

      'calorieGoalSum': calorieGoalSum,
      'proteinGoalSum': proteinGoalSum,
      'carbsGoalSum': carbsGoalSum,
      'fatGoalSum': fatGoalSum,

      'calorieGoalCount': calorieGoalCount,
      'proteinGoalCount': proteinGoalCount,
      'carbsGoalCount': carbsGoalCount,
      'fatGoalCount': fatGoalCount,

      'hydrationSum': hydrationSum,

      'waterGoalSum': waterGoalSum,
      'waterGoalCount': waterGoalCount,

      'workoutMinutesSum': workoutMinutesSum,
      'workoutCount': workoutCount,
      'activeDays': activeDays,

      'calorieTargetDays': calorieTargetDays,
      'proteinTargetDays': proteinTargetDays,
      'carbsTargetDays': carbsTargetDays,
      'fatTargetDays': fatTargetDays,
      'waterTargetDays': waterTargetDays,

      'dayCount': dayCount,
    };
  }
}