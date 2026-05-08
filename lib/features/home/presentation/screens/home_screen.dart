import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/ai_feedback_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_donut_chart.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/today_calories_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/week_calendar_row.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _homeRepository = HomeRepository();

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

      if (!mounted) return;

      setState(() {
        consumed = data['consumed'];
        burned = data['burned'];
        net = data['netCalories'];
        calorieGoal = data['calorieGoal'];
        remaining = data['remaining'];
        streakDays = streak;
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
          padding: EdgeInsets.fromLTRB(24, 22, 24, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(streakDays: streakDays),
              SizedBox(height: 28),

              WeekCalendarRow(),
              SizedBox(height: 30),

              AiFeedbackCard(),
              SizedBox(height: 45),

              Center(
                child: CalorieDonutChart(
                  consumed: consumed.toDouble(),
                  burned: burned.toDouble(),
                ),
              ),

              SizedBox(height: 48),
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