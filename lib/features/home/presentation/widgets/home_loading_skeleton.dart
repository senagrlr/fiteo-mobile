import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';

class HomeLoadingContent extends StatelessWidget {
  const HomeLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 50),
        child: AppShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSkeleton(),
              const SizedBox(height: 28),
              _weekSkeleton(),
              const SizedBox(height: 30),
              _feedbackSkeleton(),
              const SizedBox(height: 45),
              _donutSkeleton(),
              const SizedBox(height: 48),
              _calorieSkeleton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _headerSkeleton() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SkeletonBox(width: 105, height: 20, borderRadius: 8),
        Container(
          width: 105,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.homeCardBackground,
            borderRadius: BorderRadius.circular(20),
          ),
          alignment: Alignment.center,
          child: const SkeletonBox(width: 72, height: 12, borderRadius: 6),
        ),
      ],
    );
  }

  Widget _weekSkeleton() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            5,
                (_) => Container(
              width: 58,
              height: 68,
              decoration: BoxDecoration(
                color: AppColors.calendarInactive,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SkeletonBox(width: 28, height: 11, borderRadius: 5),
                  SizedBox(height: 5),
                  SkeletonBox(width: 24, height: 18, borderRadius: 6),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Container(
          width: 108,
          height: 30,
          decoration: BoxDecoration(
            color: AppColors.calendarCompleted,
            borderRadius: BorderRadius.circular(18),
          ),
          alignment: Alignment.center,
          child: const SkeletonBox(width: 76, height: 11, borderRadius: 5),
        ),
      ],
    );
  }

  Widget _feedbackSkeleton() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        const SkeletonBox(width: 130, height: 140, borderRadius: 28),
        const SizedBox(width: 2),
        Expanded(
          child: Container(
            height: 120,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.homeCardBackground,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonBox(height: 12, borderRadius: 6),
                SizedBox(height: 9),
                SkeletonBox(height: 12, borderRadius: 6),
                SizedBox(height: 9),
                SkeletonBox(width: 125, height: 12, borderRadius: 6),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _donutSkeleton() {
    return Center(
      child: Container(
        width: 220,
        height: 220,
        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
        alignment: Alignment.center,
        child: Container(
          width: 145,
          height: 145,
          decoration: BoxDecoration(
            color: AppColors.generalBackground,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }

  Widget _calorieSkeleton() {
    return Row(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 18),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SkeletonBox(width: 150, height: 15, borderRadius: 7),
              SizedBox(height: 14),
              SkeletonBox(width: 165, height: 15, borderRadius: 7),
            ],
          ),
        ),
      ],
    );
  }
}