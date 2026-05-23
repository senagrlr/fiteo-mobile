import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/ai_feedback_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_donut_chart.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/today_calories_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/week_calendar_row.dart';
import 'package:fiteo_myapp/features/home/data/daily_feedback_service.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeRepository = HomeRepository();
  final _dailyFeedbackService = DailyFeedbackService();

  DailyFeedbackResult? dailyFeedback;

  int consumed = 0;
  int burned = 0;
  int net = 0;
  int streakDays = 0;
  int? calorieGoal;
  int? remaining;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final data = await _homeRepository.getTodaySummary();
      final streak = await _homeRepository.getCurrentStreak();
      final last7Stats = await _homeRepository.getLast7DaysStats();
      final todayConsumed = data['consumed'] as int? ?? 0;
      final todayBurned = data['burned'] as int? ?? 0;
      final todayNet = data['netCalories'] as int? ?? 0;
      final todayGoal = data['calorieGoal'] as int? ?? 2000;
      final todayGoalReached = data['isGoalReached'] as bool? ?? false;
      final trackedDaysLast7 = last7Stats['trackedDays'] ?? 0;
      final activeDaysLast7 = last7Stats['activeDays'] ?? 0;
      final isFirstAppDay = await _homeRepository.isFirstAppDay();

      final feedback = _dailyFeedbackService.generateFeedback(
        consumedCalories: todayConsumed,
        burnedCalories: todayBurned,
        netCalories: todayNet,
        calorieGoal: todayGoal,
        isGoalReached: todayGoalReached,
        streak: streak,
        trackedDaysLast7: trackedDaysLast7,
        activeDaysLast7: activeDaysLast7,
        isFirstAppDay: isFirstAppDay,
      );

      if (!mounted) return;

      setState(() {
        consumed = todayConsumed;
        burned = todayBurned;
        net = todayNet;
        calorieGoal = todayGoal;
        remaining = data['remaining'];
        streakDays = streak;
        dailyFeedback = feedback;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Scaffold(
        backgroundColor: AppColors.generalBackground,
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.generalBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(24, 22, 24, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(streakDays: streakDays),
              const SizedBox(height: 28),

              WeekCalendarRow(),
              const SizedBox(height: 30),

              AiFeedbackCard(
                mainMessage: dailyFeedback?.mainMessage ??
                    'You’re building your routine step by step.',
                suggestion: dailyFeedback?.suggestion ??
                    'Keep tracking your meals and movement today to stay aware of your progress.',
              ),
              const SizedBox(height: 45),

              Center(
                child: CalorieDonutChart(
                  consumed: consumed.toDouble(),
                  burned: burned.toDouble(),
                ),
              ),

              const SizedBox(height: 48),
              TodayCaloriesCard(
                calorieGoal: calorieGoal,
                remaining: remaining,
              ),
            ],
          ),
        ),
      ),
    );
  }
}