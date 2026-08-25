import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/home/data/daily_feedback_service.dart';
import 'package:fiteo_myapp/features/home/data/daily_summary_repository.dart';
import 'package:fiteo_myapp/features/home/data/home_repository.dart';

import 'package:fiteo_myapp/features/home/presentation/widgets/ai_feedback_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_apple_progress.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/calorie_donut_chart.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/daily_macros_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_header.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/water_progress_card.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/week_calendar_row.dart';
import 'package:fiteo_myapp/features/home/presentation/widgets/home_loading_skeleton.dart';

import 'package:fiteo_myapp/features/reports/models/monthly_report_data.dart';
import 'package:fiteo_myapp/features/reports/presentation/popups/monthly_report_popup.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() =>
      _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final HomeRepository _homeRepository =
  HomeRepository();

  final DailyFeedbackService
  _dailyFeedbackService =
  DailyFeedbackService();

  final DailySummaryRepository
  _dailySummaryRepository =
  DailySummaryRepository();

  DailyFeedbackResult? dailyFeedback;

  int consumed = 0;
  int burned = 0;
  int net = 0;
  int streakDays = 0;

  int calorieGoal = 2000;

  double proteinConsumed = 0;
  double proteinGoal = 70;

  double fatConsumed = 0;
  double fatGoal = 50;

  double carbsConsumed = 0;
  double carbsGoal = 120;

  int waterConsumedMl = 0;
  int waterGoalMl = 2500;

  bool isLoading = true;

  // ============================================================
  // MONTHLY REPORT TEST
  // ============================================================

  bool _monthlyReportShown = false;

  @override
  void initState() {
    super.initState();

    _loadData();
  }

  // ============================================================
  // HOME DATA
  // ============================================================

  Future<void> _loadData() async {
    try {
      final data =
      await _homeRepository.getTodaySummary();

      final currentPlan =
      await _homeRepository.getCurrentNutritionPlan();

      final streak =
      await _homeRepository.getCurrentStreak();

      final last7Stats =
      await _homeRepository.getLast7DaysStats();

      final todayWater =
      await _dailySummaryRepository
          .getWaterForDay();

      final todayConsumed =
          data['consumed'] as int? ?? 0;

      final todayBurned =
          data['burned'] as int? ?? 0;

      final todayNet =
          data['netCalories'] as int? ?? 0;

      final todayGoal =
          (data['calorieGoal'] as num?)?.round() ??
              (currentPlan['calorieGoal'] as num?)?.round() ??
              2000;

      final todayProtein =
          (data['protein'] as num?)
              ?.toDouble() ??
              0.0;

      final todayFats =
          (data['fats'] as num?)
              ?.toDouble() ??
              0.0;

      final todayCarbs =
          (data['carbs'] as num?)
              ?.toDouble() ??
              0.0;

      final todayProteinGoal =
          (data['proteinGoal'] as num?)?.toDouble() ??
              (currentPlan['proteinGoal'] as num?)?.toDouble() ??
              70.0;

      final todayFatGoal =
          (data['fatGoal'] as num?)?.toDouble() ??
              (currentPlan['fatGoal'] as num?)?.toDouble() ??
              50.0;

      final todayCarbsGoal =
          (data['carbsGoal'] as num?)?.toDouble() ??
              (currentPlan['carbsGoal'] as num?)?.toDouble() ??
              120.0;

      final todayWaterGoal =
          (data['waterGoalMl'] as num?)?.round() ??
              (currentPlan['waterGoalMl'] as num?)?.round() ??
              2500;

      final todayGoalReached =
          data['isGoalReached'] as bool? ??
              todayConsumed >= todayGoal;

      final trackedDaysLast7 =
          (last7Stats['trackedDays']
          as num?)
              ?.toInt() ??
              0;

      final activeDaysLast7 =
          (last7Stats['activeDays']
          as num?)
              ?.toInt() ??
              0;

      final isFirstAppDay =
      await _homeRepository
          .isFirstAppDay();

      final feedback =
      _dailyFeedbackService
          .generateFeedback(
        consumedCalories:
        todayConsumed,
        burnedCalories:
        todayBurned,
        netCalories:
        todayNet,
        calorieGoal:
        todayGoal,
        isGoalReached:
        todayGoalReached,
        streak:
        streak,
        trackedDaysLast7:
        trackedDaysLast7,
        activeDaysLast7:
        activeDaysLast7,
        isFirstAppDay:
        isFirstAppDay,
      );

      if (!mounted) return;

      setState(() {
        consumed = todayConsumed;

        burned = todayBurned;

        net = todayNet;

        calorieGoal = todayGoal;

        streakDays = streak;

        proteinConsumed = todayProtein;
        proteinGoal = todayProteinGoal;

        fatConsumed = todayFats;
        fatGoal = todayFatGoal;

        carbsConsumed = todayCarbs;
        carbsGoal = todayCarbsGoal;

        waterConsumedMl = todayWater;
        waterGoalMl = todayWaterGoal;

        dailyFeedback = feedback;

        isLoading = false;
      });

      // Şimdilik sadece Monthly Report UI test.
      _showMonthlyReportForTest();
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // MONTHLY REPORT - UI TEST
  // ============================================================

  void _showMonthlyReportForTest() {
    if (_monthlyReportShown ||
        !mounted) {
      return;
    }

    _monthlyReportShown = true;

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      showMonthlyReportPopup(
        context,
        const MonthlyReportData(
          dateRange:
          '1 Ağu - 31 Ağu',

          score: 87,

          scoreChange: 6,

          scoreLabel:
          'Güçlü Ay',

          // ====================================================
          // WHAT CHANGED THIS MONTH
          // ====================================================

          overview:
          MonthlyOverviewData(
            changes: [
              MonthlyChangeItem(
                label:
                'Hedef tutarlılığı',
                value:
                '%12',
                direction:
                MonthlyChangeDirection.up,
              ),

              MonthlyChangeItem(
                label:
                'Protein hedef günleri',
                value:
                '5 gün',
                direction:
                MonthlyChangeDirection.up,
              ),

              MonthlyChangeItem(
                label:
                'Su hedef günleri',
                value:
                '4 gün',
                direction:
                MonthlyChangeDirection.same,
              ),

              MonthlyChangeItem(
                label:
                'Takip',
                value:
                '%7',
                direction:
                MonthlyChangeDirection.down,
              ),

              MonthlyChangeItem(
                label:
                'Aktif günler',
                value:
                '3 gün',
                direction:
                MonthlyChangeDirection.up,
              ),
            ],
          ),

          // ====================================================
          // CALORIES / ACTIVITY / WATER
          // ====================================================

          // ====================================================
// CALORIES / ACTIVITY / PROTEIN
// ====================================================

          metrics:
          MonthlyMetricsData(
            caloriesAverage:
            '1925 kcal',

            caloriesTargetDays:
            '22/31 hedefte',

            activeDays:
            '18 gün',

            workoutTime:
            'Toplam 420 dk',

            proteinAverage:
            '92 g',

            proteinTargetDays:
            '24/31 hedefte',
          ),

          // ====================================================
          // STRONGEST AREA
          // ====================================================

          strongestArea:
          MonthlyAreaData(
            title:
            'Protein',

            primaryText:
            '24 gün protein hedefin karşılandı',

            secondaryText:
            'Haziran ayına göre 5 gün daha fazla',

            badgeText:
            'Böyle\ndevam',
          ),

          // ====================================================
          // WEAKEST AREA
          // ====================================================

          weakestArea:
          MonthlyAreaData(
            title:
            'Hafta Sonları',

            primaryText:
            'Hedef tutarlılığın hafta sonlarında daha düşüktü',

            secondaryText:
            'Hafta içine göre %21 daha düşük',

            badgeText:
            'Odak\nalanı',
          ),

          // ====================================================
          // CONSISTENCY
          // ====================================================

          consistency:
          MonthlyConsistencyData(
            trackingConsistency:
            91,

            trackedDays:
            28,

            totalDays:
            31,

            goalConsistency:
            82,

            goalConsistencyNote:
            'Şimdiye kadarki en tutarlı ayın',

            longestStreakDays:
            11,

            perfectDays:
            9,
          ),

          // ====================================================
          // WEIGHT & PLAN
          // ====================================================

          weightPlan: const MonthlyWeightPlanData(
            startWeight: 82.4,
            currentWeight: 80.6,
            monthlyTargetChange: -2.0,
            progressAchievedPercent: 90,
            statusLabel: 'Yolunda',
            statusDescription:
            'Bu ay planlanan kilo verme hızına oldukça yakın ilerledin.',
          ),

          // ====================================================
          // PATTERNS WE NOTICED
          // ====================================================

          patterns: [
            MonthlyPatternData(
              title:
              'Hafta Sonları',

              description:
              'Hedef tutarlılığın hafta sonlarında %21 daha düşüktü.',
            ),

            MonthlyPatternData(
              title:
              'Akşamlar',

              description:
              'Günlük kalorilerinin ortalama %46’sını akşam yemeğinde tükettin.',
            ),

            MonthlyPatternData(
              title:
              'Protein',

              description:
              'Sabah protein tüketimin günün ilerleyen öğünlerine göre düzenli olarak daha düşüktü.',
            ),
          ],

          // ====================================================
          // YOUR MONTH IN REVIEW
          // ====================================================

          reviewParagraphs: [
            'Bu ayın en belirgin özelliği tek tek iyi günlerden çok genel tutarlılığın oldu. Protein takibi en güçlü alışkanlıklarından biri haline gelirken hedeflerine bağlılığın da düzenli biçimde gelişti.',

            'Genel ilerlemen planınla uyumlu. En büyük gelişim alanın hâlâ hafta sonları; özellikle akşam saatlerindeki kalori yoğunluğu burada dikkat çekiyor.',
          ],

          // ====================================================
          // NEXT MONTH PLAN
          // ====================================================

          plan:
          MonthlyPlanData(
            title:
            'Eylül Planın',

            mainFocus:
            'Hafta sonu tutarlılığını geliştir.',

            keepDoing:
            'Mevcut protein rutinini koru.',

            improve:
            'Her hafta en az 5 gün su hedefine ulaş.',

            watch:
            'Akşam öğünlerindeki kalori yoğunluğuna dikkat et.',
          ),
        ),
      );
    });
  }

  // ============================================================
  // WATER
  // ============================================================

  Future<void> _addWater(
      int amount,
      ) async {
    await _dailySummaryRepository
        .addWater(
      amountMl: amount,
    );

    if (!mounted) return;

    final updatedWater =
    await _dailySummaryRepository
        .getWaterForDay();

    if (!mounted) return;

    setState(() {
      waterConsumedMl =
          updatedWater;
    });
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(
      BuildContext context,
      ) {
    if (isLoading) {
      return const SystemNavigationBar(
        color: AppColors.generalBackground,
        child: Scaffold(
          backgroundColor: AppColors.generalBackground,
          body: HomeLoadingContent(),
        ),
      );
    }

    return SystemNavigationBar(
      color:
      AppColors.generalBackground,
      child: Scaffold(
        backgroundColor:
        AppColors.generalBackground,
        body: SafeArea(
          child:
          SingleChildScrollView(
            padding:
            const EdgeInsets.fromLTRB(
              24,
              22,
              24,
              50,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                // =================================================
                // HEADER
                // =================================================

                HomeHeader(
                  streakDays:
                  streakDays,
                ),

                const SizedBox(
                  height: 28,
                ),

                // =================================================
                // WEEK
                // =================================================

                const WeekCalendarRow(),

                const SizedBox(
                  height: 30,
                ),

                // =================================================
                // AI FEEDBACK
                // =================================================

                AiFeedbackCard(
                  mainMessage:
                  dailyFeedback
                      ?.mainMessage ??
                      context
                          .l10n
                          .defaultAiFeedbackMessage,

                  suggestion:
                  dailyFeedback
                      ?.suggestion ??
                      context
                          .l10n
                          .defaultAiFeedbackSuggestion,
                ),

                const SizedBox(
                  height: 45,
                ),

                // =================================================
                // CALORIE DONUT
                // =================================================

                Center(
                  child:
                  CalorieDonutChart(
                    consumed:
                    consumed.toDouble(),

                    burned:
                    burned.toDouble(),
                  ),
                ),

                const SizedBox(
                  height: 48,
                ),

                // =================================================
                // CALORIE APPLE
                // =================================================

                CalorieAppleProgress(
                  consumedCalories:
                  consumed,

                  calorieGoal:
                  calorieGoal,
                ),

                const SizedBox(
                  height: 34,
                ),

                // =================================================
                // MACROS + WATER
                // =================================================

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                      child: SizedBox(
                        height: 170,
                        child: WaterProgressCard(
                          consumedMl: waterConsumedMl,
                          goalMl: waterGoalMl,
                          onWaterAdded: _addWater,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}