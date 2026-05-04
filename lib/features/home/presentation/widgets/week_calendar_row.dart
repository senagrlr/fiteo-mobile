import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/features/home/presentation/screens/monthly_calendar_screen.dart';

class WeekCalendarRow extends StatelessWidget {
  const WeekCalendarRow({super.key});

  String _dayName(int weekday) {
    const days = [
      'Mon',
      'Tue',
      'Wed',
      'Thu',
      'Fri',
      'Sat',
      'Sun',
    ];
    return days[weekday - 1];
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final dates = List.generate(
      5,
          (index) => today.add(Duration(days: index - 2)),
    );

    // Şimdilik demo: geçmiş 2 gün track yapılmış gibi.
    final completedTrackedDays = <DateTime>{
      DateTime(today.year, today.month, today.day - 2),
      DateTime(today.year, today.month, today.day - 1),
    };

    bool isCompleted(DateTime date) {
      final normalized = DateTime(date.year, date.month, date.day);
      return completedTrackedDays.contains(normalized);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: dates.map((date) {
            return _DayCard(
              dayName: _dayName(date.weekday),
              dayNumber: date.day,
              isCompleted: isCompleted(date),
            );
          }).toList(),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const MonthlyCalendarScreen(),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: AppColors.calendarCompleted,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Text(
              'View calendar',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  final String dayName;
  final int dayNumber;
  final bool isCompleted;

  const _DayCard({
    required this.dayName,
    required this.dayNumber,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 58,
      height: 68,
      decoration: BoxDecoration(
        color: isCompleted
            ? AppColors.calendarCompleted
            : AppColors.calendarInactive,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: isCompleted ? Colors.white : AppColors.blackText,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$dayNumber',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w900,
              color: isCompleted ? Colors.white : AppColors.blackText,
            ),
          ),
        ],
      ),
    );
  }
}