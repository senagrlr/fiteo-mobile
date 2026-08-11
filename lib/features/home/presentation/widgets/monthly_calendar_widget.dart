import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

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

  List<String> _weekDays(BuildContext context) {
    final locale =
    Localizations.localeOf(context).toLanguageTag();

    final sunday = DateTime(2026, 8, 9);

    return List.generate(
      7,
          (index) {
        return DateFormat(
          'EEE',
          locale,
        ).format(
          sunday.add(
            Duration(days: index),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale =
    Localizations.localeOf(context).toLanguageTag();

    final monthTitle = DateFormat(
      'MMMM yyyy',
      locale,
    ).format(currentMonth);

    final weekDays = _weekDays(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(
        18,
        18,
        18,
        22,
      ),
      decoration: BoxDecoration(
        color: AppColors.calendarBackground,
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
                  color: AppColors.calendarArrow,
                  size: 20,
                ),
              ),

              Expanded(
                child: Text(
                  monthTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.titleLarge.copyWith(
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
                  color: AppColors.calendarArrow,
                  size: 20,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: weekDays
                .map(
                  (day) => _WeekDayText(day),
            )
                .toList(),
          ),

          const SizedBox(height: 12),

          GridView.builder(
            shrinkWrap: true,
            physics:
            const NeverScrollableScrollPhysics(),
            itemCount:
            firstWeekdayIndex + daysInMonth,
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

              final day =
                  index - firstWeekdayIndex + 1;

              final isTracked =
              trackedDays.contains(day);

              final isSelected =
                  selectedDay == day;

              return GestureDetector(
                onTap: () =>
                    onDaySelected(day),
                behavior: HitTestBehavior.opaque,
                child: AnimatedContainer(
                  duration:
                  const Duration(milliseconds: 180),
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
                    style:
                    AppTextStyles.bodyMedium.copyWith(
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
        text.toUpperCase(),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: AppTextStyles.labelSmall.copyWith(
          color: AppColors.calendarWeekdayText,
          fontSize: 11,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}