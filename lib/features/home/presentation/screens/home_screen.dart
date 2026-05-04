import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/ai_feedback_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_donut_chart.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/today_calories_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/week_calendar_row.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.generalBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(24, 22, 24, 50),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(streakDays: 2),
              SizedBox(height: 28),

              WeekCalendarRow(),
              SizedBox(height: 30),

              AiFeedbackCard(),
              SizedBox(height: 45),

              Center(
                child: CalorieDonutChart(
                  consumed: 2050,
                  burned: 310,
                ),
              ),

              SizedBox(height: 48),
              TodayCaloriesCard(),
            ],
          ),
        ),
      ),
    );
  }
}