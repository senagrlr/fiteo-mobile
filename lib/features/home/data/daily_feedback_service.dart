class DailyFeedbackResult {
  final String mainMessage;
  final String suggestion;

  const DailyFeedbackResult({
    required this.mainMessage,
    required this.suggestion,
  });
}

class DailyFeedbackOptions {
  final List<String> mainOptions;
  final List<String> suggestionOptions;

  const DailyFeedbackOptions({
    required this.mainOptions,
    required this.suggestionOptions,
  });
}

class DailyFeedbackService {

  DailyFeedbackResult generateFeedback({
    required int consumedCalories,
    required int burnedCalories,
    required int netCalories,
    required int calorieGoal,
    required bool isGoalReached,
    required int streak,
    required int trackedDaysLast7,
    required int activeDaysLast7,
    required bool isFirstAppDay,
  }) {
    final goalDifferencePercent =
    calorieGoal == 0 ? 0 : ((netCalories - calorieGoal).abs() / calorieGoal) *
        100;

    final isAbove20 = netCalories > calorieGoal * 1.2;
    final isBelow20 = netCalories < calorieGoal * 0.8;
    final isCloseToGoal = goalDifferencePercent <= 10;
    final highWorkout = burnedCalories >= 500;
    final strongDeficitAndWorkout = highWorkout && isBelow20;
    final noMealsLogged = consumedCalories == 0;
    final noWorkoutToday = burnedCalories == 0;
    final lowActivityWeek = activeDaysLast7 <= 2;
    final consistentWeek = trackedDaysLast7 >= 5 && consumedCalories > 0;
    final currentHour = DateTime.now().hour;

    final isNightSummaryTime = currentHour >= 22 || currentHour < 5;
    final isFarBelowGoal = netCalories < calorieGoal * 0.7;
    final isSlightlyBelowGoal = netCalories >= calorieGoal * 0.7 && netCalories < calorieGoal;
    final isSlightlyAboveGoal = netCalories > calorieGoal && netCalories <= calorieGoal * 1.2;
    final isFarAboveGoal = netCalories > calorieGoal * 1.2;

    if (isNightSummaryTime) {
      final nightOptions = _selectNightSummaryOptions(
        isFarBelowGoal: isFarBelowGoal,
        isSlightlyBelowGoal: isSlightlyBelowGoal,
        isGoalReached: isGoalReached,
        isFarAboveGoal: isFarAboveGoal,
        isSlightlyAboveGoal: isSlightlyAboveGoal,
      );

      return DailyFeedbackResult(
        mainMessage: _pickStable(nightOptions.mainOptions),
        suggestion: _pickStable(nightOptions.suggestionOptions),
      );
    }

    final mainOptions = _selectMainOptions(
      isFirstAppDay: isFirstAppDay,
      isGoalReached: isGoalReached,
      consistentWeek: consistentWeek,
      streak: streak,
      highWorkout: highWorkout,
      lowActivityWeek: lowActivityWeek,
      noMealsLogged: noMealsLogged,
    );

    final suggestionOptions = _selectSuggestionOptions(
      noMealsLogged: noMealsLogged,
      strongDeficitAndWorkout: strongDeficitAndWorkout,
      isAbove20: isAbove20,
      isBelow20: isBelow20,
      isCloseToGoal: isCloseToGoal,
      highWorkout: highWorkout,
      noWorkoutToday: noWorkoutToday,
    );

    return DailyFeedbackResult(
      mainMessage: _pickStable(mainOptions),
      suggestion: _pickStable(suggestionOptions),
    );
  }

  String _pickStable(List<String> options) {
    final dayKey = DateTime.now().day;
    final index = dayKey % options.length;

    return options[index];
  }

  List<String> _selectMainOptions({
    required bool isFirstAppDay,
    required bool isGoalReached,
    required bool consistentWeek,
    required int streak,
    required bool highWorkout,
    required bool lowActivityWeek,
    required bool noMealsLogged,
  }) {
    if (isFirstAppDay) {
      return [
        'Welcome to Fiteo! Today is the first step toward building a healthier routine.',
        'Every strong routine starts with a small first step. Glad to have you here.',
        'You’re starting a new journey today, and consistency will matter more than perfection.',
      ];
    }

    if (isGoalReached) {
      return [
        'You reached your calorie goal today. Great consistency — keep building on this rhythm.',
        'Nice work today. You stayed aligned with your calorie target and routine.',
        'You hit your goal today, and that consistency adds up over time.',
      ];
    }

    if (consistentWeek) {
      return [
        'You’ve been tracking consistently this week. That habit is more important than being perfect every day.',
        'Your consistency this week is building a strong foundation for long-term progress.',
        'You’ve stayed engaged with your routine throughout the week. Great discipline.',
      ];
    }

    if (streak >= 5) {
      return [
        'You’re building a solid routine day by day. Consistency creates long-term results.',
        'Your streak reflects the effort you continue showing for yourself each day.',
        'Small daily actions are starting to turn into a real routine. Keep going.',
      ];
    }

    if (highWorkout) {
      return [
        'You pushed yourself hard today. Strong effort and movement consistency.',
        'Today was an active day, and your effort is clearly showing.',
        'You burned a strong amount of calories today. Nice work staying active.',
      ];
    }

    if (lowActivityWeek) {
      return [
        'Your activity level has been lighter this week, but small steps still create progress.',
        'This week has been less active than usual, and that’s okay sometimes.',
        'Your movement has been lower recently, but rebuilding momentum can start small.',
      ];
    }

    if (noMealsLogged) {
      return [
        'No meals have been logged yet today, and tracking is part of building awareness.',
        'Your day is still open — logging meals can help you stay mindful of your habits.',
        'Tracking your meals regularly can make your progress easier to understand over time.',
      ];
    }

    return [
      'You’re building your routine step by step. Small consistent actions make the biggest difference.',
      'Your daily choices are shaping your long-term progress.',
      'Small habits repeated consistently can create real change over time.',
    ];
  }

  List<String> _selectSuggestionOptions({
    required bool noMealsLogged,
    required bool strongDeficitAndWorkout,
    required bool isAbove20,
    required bool isBelow20,
    required bool isCloseToGoal,
    required bool highWorkout,
    required bool noWorkoutToday,
  }) {
    if (noMealsLogged) {
      return [
        'Start with one simple meal entry to keep your progress visible and consistent.',
        'Even logging one meal today can help build a stronger tracking habit.',
        'Try adding your next meal to stay connected with your daily goals.',
      ];
    }

    if (strongDeficitAndWorkout) {
      return [
        'Make sure you recover properly and avoid under-fueling your body for too long.',
        'A balanced recovery meal and enough hydration can support your energy levels.',
        'Your body still needs fuel after intense activity, so prioritize recovery tonight.',
      ];
    }

    if (isAbove20) {
      return [
        'Focus on balance tomorrow instead of trying to compensate too aggressively.',
        'Return to your normal routine tomorrow and avoid guilt-driven decisions.',
        'A calm and balanced tomorrow is more effective than extreme restriction.',
      ];
    }

    if (isBelow20) {
      return [
        'A balanced meal with protein and carbs can help support your energy levels.',
        'Try not to stay in a large calorie deficit for too many days in a row.',
        'A nourishing meal tonight could help your recovery and overall balance.',
      ];
    }

    if (isCloseToGoal) {
      return [
        'Keep your next meal simple and avoid overcorrecting your calories.',
        'A light balanced meal can help you comfortably finish the day.',
        'Stay steady and avoid unnecessary restriction or overeating tonight.',
      ];
    }

    if (highWorkout) {
      return [
        'Recovery matters too — hydrate well and choose nourishing meals today.',
        'Your body will benefit from proper rest, hydration, and balanced meals tonight.',
        'A recovery-focused evening can help support tomorrow’s energy and performance.',
      ];
    }

    if (noWorkoutToday) {
      return [
        'Even a short walk or light movement session could help your daily balance.',
        'A few minutes of stretching or walking may help you stay active today.',
        'Light movement can still support your energy and routine on quieter days.',
      ];
    }

    return [
      'Keep tracking your meals and movement today to stay aware of your progress.',
      'Focus on one simple healthy choice you can repeat today.',
      'Stay consistent with the basics and let progress build gradually.',
    ];
  }

  DailyFeedbackOptions _selectNightSummaryOptions({
    required bool isFarBelowGoal,
    required bool isSlightlyBelowGoal,
    required bool isGoalReached,
    required bool isFarAboveGoal,
    required bool isSlightlyAboveGoal,
  }) {
    if (isFarBelowGoal) {
      return const DailyFeedbackOptions(
        mainOptions: [
          'You ended the day far below your calorie goal. Your body still needs enough fuel.',
          'Today finished with a large calorie gap. Balance matters as much as discipline.',
          'You kept calories very low today. Strong effort, but energy still matters.',
        ],
        suggestionOptions: [
          'Tomorrow, try to add balanced meals earlier in the day to support your energy.',
          'Aim for a steadier intake tomorrow instead of staying too far below your goal.',
          'A more balanced day tomorrow can help your routine feel more sustainable.',
        ],
      );
    }

    if (isSlightlyBelowGoal) {
      return const DailyFeedbackOptions(
        mainOptions: [
          'You ended the day slightly below your calorie goal. That can still be a solid step toward progress.',
          'Today finished a little under your target, and your overall direction looks controlled.',
          'You stayed just below your calorie goal today. Nice effort keeping things balanced.',
        ],
        suggestionOptions: [
          'Tomorrow, keep the same steady rhythm and focus on simple balanced meals.',
          'Try to repeat this consistency tomorrow without making the day too restrictive.',
          'A similar balanced approach tomorrow can help you build momentum.',
        ],
      );
    }

    if (isGoalReached) {
      return const DailyFeedbackOptions(
        mainOptions: [
          'You reached your calorie goal today. Great job staying aligned with your plan.',
          'Today ended right on track. That kind of consistency builds real progress.',
          'You completed the day in line with your goal. Strong and steady work.',
        ],
        suggestionOptions: [
          'Tomorrow, focus on repeating the same sustainable habits.',
          'Keep your routine simple tomorrow and build on today’s consistency.',
          'A steady day tomorrow can help turn this progress into a habit.',
        ],
      );
    }

    if (isFarAboveGoal) {
      return const DailyFeedbackOptions(
        mainOptions: [
          'You ended the day well above your calorie goal. One day does not define progress.',
          'Today finished higher than planned, but long-term consistency matters more.',
          'You went far over your target today. It is okay — progress is built over time.',
        ],
        suggestionOptions: [
          'Tomorrow, return to your normal routine without aggressive restriction.',
          'Focus on a calm, balanced day with simple meals and light movement.',
          'Avoid guilt-driven choices tomorrow; just reset with steady habits.',
        ],
      );
    }

    if (isSlightlyAboveGoal) {
      return const DailyFeedbackOptions(
        mainOptions: [
          'You ended the day slightly above your calorie goal. That is manageable and part of normal progress.',
          'Today finished a little over your target, but your routine can easily stay on track.',
          'You went slightly above your goal today. No need to overcorrect.',
        ],
        suggestionOptions: [
          'Tomorrow, aim for balance and return to your usual rhythm.',
          'Keep tomorrow simple with steady meals and normal activity.',
          'A consistent day tomorrow is enough to stay on track.',
        ],
      );
    }

    return const DailyFeedbackOptions(
      mainOptions: [
        'Your day is complete, and every logged choice helps you understand your routine better.',
        'Today gave you useful feedback about your habits and daily rhythm.',
        'Another day is in the books. Small patterns become clearer when you keep tracking.',
      ],
      suggestionOptions: [
        'Tomorrow, focus on one simple improvement you can repeat.',
        'Use today’s progress as feedback and keep building gradually tomorrow.',
        'Start tomorrow with a clear, simple goal and keep it sustainable.',
      ],
    );
  }
}