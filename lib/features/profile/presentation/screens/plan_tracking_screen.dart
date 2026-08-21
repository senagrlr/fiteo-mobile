import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/fiteo_overview_note_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/fiteo_score_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_status_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_status_note_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_weight_progress_chart.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_weight_summary_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/tracking_summary_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/unique_features_card.dart';

class PlanTrackingScreen extends StatefulWidget {
  const PlanTrackingScreen({
    super.key,
  });

  @override
  State<PlanTrackingScreen> createState() =>
      _PlanTrackingScreenState();
}

class _PlanTrackingScreenState
    extends State<PlanTrackingScreen> {
  int selectedTab = 0;

  // Sadece UI testi.
  // Burayı değiştirerek 4 durumu test edebilirsin.
  final PlanStatus planStatus = PlanStatus.improveConsistencyFirst;

  // Diğer durumlar:
  //
  // PlanStatus.reviewRecommended
  // PlanStatus.notEnoughData
  // PlanStatus.improveConsistencyFirst

  void _changeTab(int index) {
    setState(() {
      selectedTab = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SystemNavigationBar(
      color: AppColors.surfacePrimary,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarColor:
          AppColors.planTrackingHeaderBackground,
          statusBarIconBrightness:
          Brightness.dark,
          statusBarBrightness:
          Brightness.light,
        ),
        child: Scaffold(
          backgroundColor:
          AppColors.surfacePrimary,
          extendBodyBehindAppBar: true,
          body: Column(
            children: [
              if (selectedTab == 0)
                FiteoScoreHeader(
                  score: 80,
                  selectedTab: selectedTab,
                  onTabChanged: _changeTab,
                )
              else
                PlanStatusHeader(
                  status: planStatus,
                  selectedTab: selectedTab,
                  onTabChanged: _changeTab,
                ),

              Expanded(
                child: selectedTab == 0
                    ? const _OverviewContent()
                    : _PlanContent(
                  status: planStatus,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _OverviewContent extends StatelessWidget {
  const _OverviewContent();

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics:
      const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        26,
        screenWidth * 0.07,
        45,
      ),
      child: Column(
        children: [
          const TrackingSummaryCard(
            streakDays: 12,
            goalAchievement: 84,
          ),

          const SizedBox(height: 24),

          UniqueFeaturesCard(
            longestStreak: 12,
            bestProtein: 134,
            mostActiveDay:
            context.l10n.sunday,
          ),

          const SizedBox(height: 30),

          const FiteoOverviewNoteCard(),
        ],
      ),
    );
  }
}

class _PlanContent extends StatelessWidget {
  final PlanStatus status;

  const _PlanContent({
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics:
      const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        26,
        screenWidth * 0.07,
        45,
      ),
      child: Column(
        children: [
          PlanWeightSummaryCard(
            startWeight: 55,
            startDate: '12.04.2026',

            // UI test verisi
            reachDay: 20,
            reachMonth:
            context.l10n.july,

            // true  -> yeşil + yukarı ok
            // false -> kırmızı + aşağı ok
            isProjectionGood: true,

            goalWeight: 50,
          ),

          const SizedBox(height: 24),

          const PlanWeightProgressChart(),

          const SizedBox(height: 30),

          PlanStatusNoteCard(
            status: status,
            estimatedGoalDate:
            '20 ${context.l10n.july} 2026',
            onReviewPlan: () {
              // Sadece Review Recommended
              // durumunda buton görünür.
              //
              // Daha sonra yeni plan
              // ekranına route bağlanacak.
            },
          ),
        ],
      ),
    );
  }
}