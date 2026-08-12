import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/home/data/calendar_repository.dart';

class WeekCalendarRow extends StatefulWidget {
  const WeekCalendarRow({
    super.key,
  });

  @override
  State<WeekCalendarRow> createState() =>
      _WeekCalendarRowState();
}

class _WeekCalendarRowState extends State<WeekCalendarRow> {
  final CalendarRepository _repo =
  CalendarRepository();

  final Set<String> completedDays = {};

  String _format(DateTime date) {
    return '${date.year}-${date.month}-${date.day}';
  }

  @override
  void initState() {
    super.initState();
    _loadWeek();
  }

  Future<void> _loadWeek() async {
    final today = DateTime.now();

    for (int i = -2; i <= 2; i++) {
      final date = today.add(
        Duration(days: i),
      );

      final data =
      await _repo.getDayCalories(date);

      if ((data['consumed'] ?? 0) > 0 ||
          (data['burned'] ?? 0) > 0) {
        completedDays.add(
          _format(date),
        );
      }
    }

    if (!mounted) return;

    setState(() {});
  }

  String _dayName(
      BuildContext context,
      DateTime date,
      ) {
    final locale =
    Localizations.localeOf(context)
        .toLanguageTag();

    return DateFormat(
      'EEE',
      locale,
    ).format(date);
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    final dates = List.generate(
      5,
          (index) => today.add(
        Duration(
          days: index - 2,
        ),
      ),
    );

    bool isCompleted(DateTime date) {
      return completedDays.contains(
        _format(date),
      );
    }

    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: dates.map(
                (date) {
              return _DayCard(
                dayName: _dayName(
                  context,
                  date,
                ),
                dayNumber: date.day,
                isCompleted:
                isCompleted(date),
              );
            },
          ).toList(),
        ),

        const SizedBox(height: 12),

        GestureDetector(
          onTap: () {
            Navigator.pushNamed(
              context,
              AppRoutes.monthlyCalendar,
            );
          },
          child: Container(
            padding:
            const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color:
              AppColors.calendarCompleted,
              borderRadius:
              BorderRadius.circular(18),
            ),
            child: Text(
              context.l10n.viewCalendar,
              style:
              AppTextStyles.bodyMedium
                  .copyWith(
                fontSize: 15,
                fontWeight:
                FontWeight.w700,
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
        borderRadius:
        BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment:
        MainAxisAlignment.center,
        children: [
          Text(
            dayName,
            style:
            AppTextStyles.bodySmall
                .copyWith(
              fontSize: 14,
              fontWeight:
              FontWeight.w700,
              color: isCompleted
                  ? Colors.white
                  : AppColors.blackText,
            ),
          ),

          const SizedBox(height: 2),

          Text(
            '$dayNumber',
            style:
            AppTextStyles.titleLarge
                .copyWith(
              fontSize: 20,
              fontWeight:
              FontWeight.w900,
              color: isCompleted
                  ? Colors.white
                  : AppColors.blackText,
            ),
          ),
        ],
      ),
    );
  }
}