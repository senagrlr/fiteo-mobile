import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_tabs.dart';

class PlanLoadingHeader extends StatelessWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const PlanLoadingHeader({
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
            clipper: _PlanHeaderClipper(),
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
            child: const Column(
              children: [
                AppShimmer(
                  child: SkeletonBox(
                    width: 135,
                    height: 22,
                    borderRadius: 10,
                  ),
                ),
                SizedBox(height: 10),
                AppShimmer(
                  child: SkeletonBox(
                    width: 190,
                    height: 14,
                    borderRadius: 7,
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

class PlanLoadingContent extends StatelessWidget {
  const PlanLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(
        screenWidth * 0.07,
        26,
        screenWidth * 0.07,
        45,
      ),
      child: AppShimmer(
        child: Column(
          children: [
            _summarySkeleton(),
            const SizedBox(height: 24),
            _chartSkeleton(),
            const SizedBox(height: 30),
            _noteSkeleton(),
          ],
        ),
      ),
    );
  }

  Widget _summarySkeleton() {
    return Container(
      width: double.infinity,
      height: 132,
      padding: const EdgeInsets.fromLTRB(12, 14, 8, 12),
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
      child: Row(
        children: const [
          Expanded(child: _SummaryColumnSkeleton()),
          SizedBox(width: 8),
          Expanded(child: _SummaryColumnSkeleton()),
          SizedBox(width: 8),
          Expanded(child: _SummaryColumnSkeleton()),
        ],
      ),
    );
  }

  Widget _chartSkeleton() {
    return Container(
      width: double.infinity,
      height: 340,
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 18),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(28),
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
          const SkeletonBox(width: 120, height: 18, borderRadius: 9),
          const SizedBox(height: 14),
          Row(
            children: const [
              SkeletonBox(width: 80, height: 12, borderRadius: 6),
              SizedBox(width: 18),
              SkeletonBox(width: 95, height: 12, borderRadius: 6),
            ],
          ),
          const SizedBox(height: 22),
          Expanded(
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surfacePrimary,
                borderRadius: BorderRadius.circular(18),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SkeletonBox(height: 1, borderRadius: 1),
                    SkeletonBox(height: 1, borderRadius: 1),
                    SkeletonBox(height: 1, borderRadius: 1),
                    SkeletonBox(height: 1, borderRadius: 1),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _noteSkeleton() {
    return Container(
      width: double.infinity,
      height: 118,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.calendarSummaryCardBackground,
        borderRadius: BorderRadius.circular(24),
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
          SkeletonBox(width: 115, height: 16, borderRadius: 8),
          SizedBox(height: 14),
          SkeletonBox(height: 12, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: 220, height: 12, borderRadius: 6),
        ],
      ),
    );
  }
}

class _SummaryColumnSkeleton extends StatelessWidget {
  const _SummaryColumnSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        SkeletonBox(width: 70, height: 12, borderRadius: 6),
        SizedBox(height: 15),
        SkeletonBox(width: 54, height: 28, borderRadius: 10),
        SizedBox(height: 10),
        SkeletonBox(width: 48, height: 10, borderRadius: 5),
      ],
    );
  }
}

class _PlanHeaderClipper extends CustomClipper<Path> {
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