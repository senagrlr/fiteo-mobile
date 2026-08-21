import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/models/plan_status.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_tabs.dart';

class PlanStatusHeader extends StatelessWidget {
  final PlanStatus status;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const PlanStatusHeader({
    super.key,
    required this.status,
    required this.selectedTab,
    required this.onTabChanged,
  });

  String _statusTitle(BuildContext context) {
    switch (status) {
      case PlanStatus.onTrack:
        return context.l10n.onTrack;

      case PlanStatus.reviewRecommended:
        return context.l10n.reviewRecommended;

      case PlanStatus.notEnoughData:
        return context.l10n.notEnoughData;

      case PlanStatus.improveConsistencyFirst:
        return context.l10n.improveConsistencyFirst;
    }
  }

  String _statusEmoji() {
    switch (status) {
      case PlanStatus.onTrack:
        return '😊';

      case PlanStatus.reviewRecommended:
        return '⚠️';

      case PlanStatus.notEnoughData:
        return '🤔';

      case PlanStatus.improveConsistencyFirst:
        return '📌';
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight =
        MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        children: [
          ClipPath(
            clipper: _PlanStatusHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 220,
              color:
              AppColors.planTrackingHeaderBackground,
            ),
          ),

          Positioned(
            top: statusBarHeight + 13,
            left: 10,
            child: SizedBox(
              width: 44,
              height: 44,
              child: IconButton(
                padding: EdgeInsets.zero,
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.homeBrown,
                  size: 24,
                ),
              ),
            ),
          ),

          Positioned(
            top: statusBarHeight + 18,
            left: 0,
            right: 0,
            child: Center(
              child: PlanTrackingTabs(
                selectedIndex: selectedTab,
                onChanged: onTabChanged,
              ),
            ),
          ),

          Positioned(
            top: statusBarHeight + 82,
            left: 24,
            right: 24,
            child: Text(
              '${_statusEmoji()} ${_statusTitle(context)}',
              textAlign: TextAlign.center,
              maxLines: 2,
              style:
              AppTextStyles.headingMedium.copyWith(
                color: AppColors.onPrimary,
                fontSize: 22,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanStatusHeaderClipper
    extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(
      0,
      size.height * 0.55,
    );

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.28,
      size.width,
      size.height * 0.55,
    );

    path.lineTo(
      size.width,
      0,
    );

    path.close();

    return path;
  }

  @override
  bool shouldReclip(
      covariant CustomClipper<Path> oldClipper,
      ) {
    return false;
  }
}