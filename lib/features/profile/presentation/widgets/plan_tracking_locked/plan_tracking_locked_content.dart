import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_locked/premium_locked_preview.dart';

import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_locked/plan_tracking_mock_data.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_locked/plan_tracking_overview_content.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_locked/plan_tracking_plan_content.dart';

class PlanTrackingLockedContent extends StatelessWidget {
  final int selectedTab;

  const PlanTrackingLockedContent({
    super.key,
    required this.selectedTab,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        26,
        screenWidth * 0.07,
        45,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: PremiumLockedPreview(
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: selectedTab == 0
                ? PlanTrackingOverviewContent(
              stats:
              PlanTrackingMockData.overview,
              achievements:
              PlanTrackingMockData.achievements,
            )
                : PlanTrackingPlanContent(
              stats:
              PlanTrackingMockData.plan,
            ),
          ),
        ),
      ),
    );
  }
}