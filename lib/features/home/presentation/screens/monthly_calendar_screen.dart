import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/home/data/calendar_repository.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calendar_day_summary_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/monthly_calendar_widget.dart';

class MonthlyCalendarScreen extends StatefulWidget {
  const MonthlyCalendarScreen({
    super.key,
  });

  @override
  State<MonthlyCalendarScreen> createState() =>
      _MonthlyCalendarScreenState();
}

class _MonthlyCalendarScreenState
    extends State<MonthlyCalendarScreen> {
  DateTime currentMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
  );

  int selectedDay = DateTime.now().day;

  final CalendarRepository _repo =
  CalendarRepository();

  Map<int, DayCalories> dayData = {};
  Set<int> trackedDays = {};

  bool isLoading = true;

  @override
  void initState() {
    super.initState();

    _loadMonth();
  }

  int get daysInMonth {
    return DateTime(
      currentMonth.year,
      currentMonth.month + 1,
      0,
    ).day;
  }

  int get firstWeekdayIndex {
    final firstDay = DateTime(
      currentMonth.year,
      currentMonth.month,
      1,
    );

    return firstDay.weekday % 7;
  }

  bool _isCurrentMonth(DateTime month) {
    final now = DateTime.now();

    return month.year == now.year &&
        month.month == now.month;
  }

  String _localizedMonthName(
      BuildContext context,
      ) {
    final locale =
    Localizations.localeOf(context).toLanguageTag();

    return DateFormat(
      'MMMM',
      locale,
    ).format(currentMonth);
  }

  void previousMonth() {
    final newMonth = DateTime(
      currentMonth.year,
      currentMonth.month - 1,
    );

    setState(() {
      currentMonth = newMonth;

      selectedDay = _isCurrentMonth(newMonth)
          ? DateTime.now().day
          : 1;

      isLoading = true;
    });

    _loadMonth();
  }

  void nextMonth() {
    final newMonth = DateTime(
      currentMonth.year,
      currentMonth.month + 1,
    );

    setState(() {
      currentMonth = newMonth;

      selectedDay = _isCurrentMonth(newMonth)
          ? DateTime.now().day
          : 1;

      isLoading = true;
    });

    _loadMonth();
  }

  Future<void> _loadMonth() async {
    final data =
    await _repo.getMonthlyData(currentMonth);

    final map = <int, DayCalories>{};
    final tracked = <int>{};

    data.forEach(
          (day, values) {
        final consumed =
        (values['consumed'] ?? 0).round();

        final burned =
        (values['burned'] ?? 0).round();

        final protein =
        (values['protein'] ?? 0).toDouble();

        final fats =
        (values['fats'] ?? 0).toDouble();

        final carbs =
        (values['carbs'] ?? 0).toDouble();

        final netCalories =
        (values['netCalories'] ?? 0).round();

        final hydration =
        (values['hydration'] ?? 0).round();

        if (consumed > 0 ||
            burned > 0 ||
            hydration > 0) {
          tracked.add(day);

          map[day] = DayCalories(
            consumed: consumed,
            burned: burned,
            protein: protein,
            fats: fats,
            carbs: carbs,
            netCalories: netCalories,
            hydration: hydration,
          );
        }
      },
    );

    if (!mounted) {
      return;
    }

    setState(() {
      dayData = map;
      trackedDays = tracked;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const SystemNavigationBar(
        color: Colors.white,
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    final selectedData =
    dayData[selectedDay];

    final monthName =
    _localizedMonthName(context);

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(
              26,
              18,
              26,
              110,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // ------------------------------------------------
                // HEADER
                // ------------------------------------------------
                SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        context.l10n.monthlyCalendar,
                        textAlign: TextAlign.center,
                        style: AppTextStyles
                            .headingMedium
                            .copyWith(
                          color: AppColors.homeBrown,
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                        ),
                      ),

                      Positioned(
                        left: 0,
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          behavior:
                          HitTestBehavior.opaque,
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              color: AppColors.homeBrown,
                              size: 26,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ------------------------------------------------
                // AYLIK TAKVİM
                // ------------------------------------------------
                MonthlyCalendarWidget(
                  currentMonth: currentMonth,
                  selectedDay: selectedDay,
                  firstWeekdayIndex:
                  firstWeekdayIndex,
                  daysInMonth: daysInMonth,
                  trackedDays: trackedDays,
                  onPreviousMonth:
                  previousMonth,
                  onNextMonth:
                  nextMonth,
                  onDaySelected: (day) {
                    setState(() {
                      selectedDay = day;
                    });
                  },
                ),

                const SizedBox(height: 42),

                // ------------------------------------------------
                // SEÇİLEN GÜNÜN ÖZETİ
                // ------------------------------------------------
                CalendarDaySummaryCard(
                  selectedDay: selectedDay,
                  monthName: monthName,
                  year: currentMonth.year,
                  consumedCalories:
                  selectedData?.consumed ?? 0,
                  burnedCalories:
                  selectedData?.burned ?? 0,
                  protein:
                  selectedData?.protein ?? 0,
                  fats:
                  selectedData?.fats ?? 0,
                  carbs:
                  selectedData?.carbs ?? 0,
                  netCalories:
                  selectedData?.netCalories ?? 0,
                  hydration:
                  selectedData?.hydration ?? 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DayCalories {
  final int consumed;
  final int burned;

  final double protein;
  final double fats;
  final double carbs;

  final int netCalories;
  final int hydration;

  const DayCalories({
    required this.consumed,
    required this.burned,
    required this.protein,
    required this.fats,
    required this.carbs,
    required this.netCalories,
    required this.hydration,
  });
}