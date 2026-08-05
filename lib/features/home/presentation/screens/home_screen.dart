import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/data/daily_feedback_service.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/ai_feedback_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_apple_progress.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_donut_chart.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/daily_macros_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/water_progress_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/week_calendar_row.dart';

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

  int calorieGoal = 2000;

  // Geçici tasarım verileri.
  // Backend hazır olduğunda repository üzerinden gelecek.
  double proteinConsumed = 35;
  double proteinGoal = 70;

  double fatConsumed = 15;
  double fatGoal = 50;

  double carbsConsumed = 55;
  double carbsGoal = 120;

  int waterConsumedMl = 420;
  int waterGoalMl = 2500;

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

      final todayGoalReached =
          data['isGoalReached'] as bool? ?? todayConsumed >= todayGoal;

      final trackedDaysLast7 =
          (last7Stats['trackedDays'] as num?)?.toInt() ?? 0;

      final activeDaysLast7 =
          (last7Stats['activeDays'] as num?)?.toInt() ?? 0;

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

  void _addWater() {
    setState(() {
      waterConsumedMl =
          (waterConsumedMl + 250).clamp(0, waterGoalMl).toInt();
    });
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

              const WeekCalendarRow(),
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

              CalorieAppleProgress(
                consumedCalories: consumed,
                calorieGoal: calorieGoal,
              ),
              const SizedBox(height: 34),

              SizedBox(
                height: 170,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      flex: 6,
                      child: DailyMacrosCard(
                        protein: proteinConsumed,
                        proteinGoal: proteinGoal,
                        fat: fatConsumed,
                        fatGoal: fatGoal,
                        carbs: carbsConsumed,
                        carbsGoal: carbsGoal,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      flex: 4,
                      child: WaterProgressCard(
                        consumedMl: waterConsumedMl,
                        goalMl: waterGoalMl,
                        onWaterAdded: (amount) {
                          setState(() {
                            waterConsumedMl =
                                (waterConsumedMl + amount).clamp(0, waterGoalMl).toInt();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}