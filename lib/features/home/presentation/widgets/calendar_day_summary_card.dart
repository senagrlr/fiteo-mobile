import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CalendarDaySummaryCard extends StatelessWidget {
  final int selectedDay;
  final String monthName;
  final int year;
  final int consumedCalories;
  final int burnedCalories;

  const CalendarDaySummaryCard({
    super.key,
    required this.selectedDay,
    required this.monthName,
    required this.year,
    required this.consumedCalories,
    required this.burnedCalories,
  });

  @override
  Widget build(BuildContext context) {
    const calorieGoal = 1600;
    const hydration = 1500;

    const fat = 40;
    const fatGoal = 70;

    const carbs = 100;
    const carbsGoal = 150;

    const protein = 70;
    const proteinGoal = 90;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        22,
        22,
        22,
        24,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(28),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '$selectedDay $monthName $year',
            style: const TextStyle(
              color: AppColors.calendarSummaryTitle,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SummaryInfoItem(
                  icon: Icons.restaurant_rounded,
                  iconColor: AppColors.calendarFoodIcon,
                  label: 'Food Intake',
                  value: '$consumedCalories kcal',
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: _SummaryInfoItem(
                  icon: Icons.fitness_center_rounded,
                  iconColor: AppColors.calendarBurnIcon,
                  label: 'Exercise Burn',
                  value: '$burnedCalories kcal',
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SummaryInfoItem(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AppColors.calendarGoalIcon,
                  label: 'Total Calorie',
                  value: '$calorieGoal kcal',
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: _SummaryInfoItem(
                  icon: Icons.local_drink_rounded,
                  iconColor: AppColors.calendarWaterIcon,
                  label: 'Hydration',
                  value: '$hydration ml',
                ),
              ),
            ],
          ),
          const SizedBox(height: 26),
          const Row(
            children: [
              Expanded(
                child: _MacroSummaryItem(
                  label: 'Protein',
                  value: protein,
                  goal: proteinGoal,
                  progressColor: AppColors.proteinProgress,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _MacroSummaryItem(
                  label: 'Fats',
                  value: fat,
                  goal: fatGoal,
                  progressColor: AppColors.fatProgress,
                ),
              ),
              SizedBox(width: 14),
              Expanded(
                child: _MacroSummaryItem(
                  label: 'Carbs',
                  value: carbs,
                  goal: carbsGoal,
                  progressColor: AppColors.carbsProgress,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryInfoItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;

  const _SummaryInfoItem({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          icon,
          color: iconColor,
          size: 16,
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.calendarSummaryLabel,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style: const TextStyle(
                  color: AppColors.calendarSummaryValue,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MacroSummaryItem extends StatelessWidget {
  final String label;
  final int value;
  final int goal;
  final Color progressColor;

  const _MacroSummaryItem({
    required this.label,
    required this.value,
    required this.goal,
    required this.progressColor,
  });

  @override
  Widget build(BuildContext context) {
    final progress = goal <= 0
        ? 0.0
        : (value / goal).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            color: AppColors.calendarSummaryTitle,
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 10,
            backgroundColor: AppColors.calendarMacroTrack,
            valueColor: AlwaysStoppedAnimation<Color>(
              progressColor,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${value}g/${goal}g',
          style: const TextStyle(
            color: AppColors.calendarSummaryLabel,
            fontSize: 10,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}