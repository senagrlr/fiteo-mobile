import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_tabs.dart';

class OverviewLoadingHeader extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const OverviewLoadingHeader({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _OverviewHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 220,
              color: AppColors.planTrackingHeaderBackground,
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
                onPressed: () => Navigator.pop(context),
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
            top: statusBarHeight + 77,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  context.l10n.fiteoScore,
                  style: const TextStyle(
                    color: AppColors.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 9),
                const AppShimmer(
                  child: SkeletonBox(
                    width: 64,
                    height: 46,
                    borderRadius: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OverviewLoadingContent extends StatelessWidget {
  const OverviewLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(screenWidth * 0.07, 26, screenWidth * 0.07, 45),
      child: AppShimmer(
        child: Column(
          children: [
            _summarySkeleton(),
            const SizedBox(height: 24),
            _achievementSkeleton(),
            const SizedBox(height: 30),
            _noteSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _summarySkeleton() {
    return Row(
      children: [
        Expanded(child: _summaryCard()),
        const SizedBox(width: 16),
        Expanded(child: _summaryCard()),
      ],
    );
  }

  Widget _summaryCard() {
    return Container(
      height: 105,
      padding: const EdgeInsets.fromLTRB(12, 17, 12, 17),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(26),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        children: [
          SkeletonBox(width: 105, height: 13, borderRadius: 7),
          Spacer(),
          SkeletonBox(width: 58, height: 30, borderRadius: 9),
        ],
      ),
    );
  }

  Widget _achievementSkeleton() {
    return Container(
      width: double.infinity,
      height: 215,
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(26),
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
          const SkeletonBox(width: 135, height: 14, borderRadius: 7),
          const SizedBox(height: 20),
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _achievementItem()),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 30),
                    child: _achievementItem(),
                  ),
                ),
                Expanded(child: _achievementItem()),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _achievementItem() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ClipPath(
          clipper: _SkeletonHexagonClipper(),
          child: Container(width: 60, height: 66, color: Colors.white),
        ),
        const SizedBox(height: 9),
        const SkeletonBox(width: 72, height: 11, borderRadius: 6),
        const SizedBox(height: 5),
        const SkeletonBox(width: 48, height: 11, borderRadius: 6),
      ],
    );
  }

  Widget _noteSkeleton() {
    return Container(
      width: double.infinity,
      constraints: const BoxConstraints(minHeight: 125),
      padding: const EdgeInsets.fromLTRB(20, 27, 20, 18),
      decoration: BoxDecoration(
        color: AppColors.planTrackingNoteBackground,
        borderRadius: BorderRadius.circular(22),
        boxShadow: const [
          BoxShadow(
            color: AppColors.calendarSummaryShadow,
            blurRadius: 14,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: double.infinity, height: 12, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: double.infinity, height: 12, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: 180, height: 12, borderRadius: 6),
        ],
      ),
    );
  }
}

class _OverviewHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.55);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.28,
      size.width,
      size.height * 0.55,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

class _SkeletonHexagonClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.moveTo(size.width * 0.5, 0);
    path.lineTo(size.width, size.height * 0.24);
    path.lineTo(size.width, size.height * 0.76);
    path.lineTo(size.width * 0.5, size.height);
    path.lineTo(0, size.height * 0.76);
    path.lineTo(0, size.height * 0.24);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}