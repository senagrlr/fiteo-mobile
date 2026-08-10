import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CalendarDaySummaryCard extends StatelessWidget {
  final int selectedDay;
  final String monthName;
  final int year;
  final int consumedCalories;
  final int burnedCalories;
  final double protein;
  final double fats;
  final double carbs;
  final int netCalories;
  final int hydration;

  const CalendarDaySummaryCard({
    super.key,
    required this.selectedDay,
    required this.monthName,
    required this.year,
    required this.consumedCalories,
    required this.burnedCalories,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.netCalories,
    required this.hydration,
  });

  @override
  Widget build(BuildContext context) {

    const fatGoal = 70;
    const carbsGoal = 150;
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _SummaryInfoItem(
                  icon: Icons.local_fire_department_rounded,
                  iconColor: AppColors.calendarGoalIcon,
                  label: 'Net Calories',
                  value: '$netCalories kcal',
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
          Row(
            children: [
              Expanded(
                child: _MacroSummaryItem(
                  label: 'Protein',
                  value: protein.round(),
                  goal: proteinGoal,
                  progressColor: AppColors.proteinProgress,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MacroSummaryItem(
                  label: 'Fats',
                  value: fats.round(),
                  goal: fatGoal,
                  progressColor: AppColors.fatProgress,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _MacroSummaryItem(
                  label: 'Carbs',
                  value: carbs.round(),
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