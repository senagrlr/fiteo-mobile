import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class MonthlyCalendarWidget extends StatelessWidget {
  final DateTime currentMonth;
  final int selectedDay;
  final int firstWeekdayIndex;
  final int daysInMonth;
  final Set<int> trackedDays;

  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<int> onDaySelected;

  const MonthlyCalendarWidget({
    super.key,
    required this.currentMonth,
    required this.selectedDay,
    required this.firstWeekdayIndex,
    required this.daysInMonth,
    required this.trackedDays,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDaySelected,
  });

  String get monthName {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];

    return months[currentMonth.month - 1];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        22,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F6F6),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: onPreviousMonth,
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Color(0xFFB8BEC4),
                  size: 20,
                ),
              ),
              Expanded(
                child: Text(
                  '$monthName ${currentMonth.year}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.homeBrown,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: onNextMonth,
                icon: const Icon(
                  Icons.arrow_forward_ios,
                  color: Color(0xFFB8BEC4),
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _WeekDayText('SAN'),
              _WeekDayText('MON'),
              _WeekDayText('TUE'),
              _WeekDayText('WED'),
              _WeekDayText('THU'),
              _WeekDayText('FRI'),
              _WeekDayText('SAT'),
            ],
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: firstWeekdayIndex + daysInMonth,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 6,
            ),
            itemBuilder: (context, index) {
              if (index < firstWeekdayIndex) {
                return const SizedBox();
              }

              final day = index - firstWeekdayIndex + 1;
              final isTracked = trackedDays.contains(day);
              final isSelected = selectedDay == day;

              return GestureDetector(
                onTap: () => onDaySelected(day),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: isTracked
                        ? AppColors.calendarCompleted
                        : Colors.transparent,
                    shape: BoxShape.circle,
                    border: isSelected
                        ? Border.all(
                      color: AppColors.homeBrown,
                      width: 1.5,
                    )
                        : null,
                  ),
                  child: Text(
                    '$day',
                    style: TextStyle(
                      color: isTracked
                          ? Colors.white
                          : Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _WeekDayText extends StatelessWidget {
  final String text;

  const _WeekDayText(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 32,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          color: Color(0xFFA9A0A0),
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}