import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';

class WorkoutLoadingContent extends StatelessWidget {
  const WorkoutLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        child: AppShimmer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _headerSkeleton(),
              const SizedBox(height: 42),
              Center(
                child: Container(
                  width: 210,
                  height: 170,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(28),
                  ),
                ),
              ),
              const SizedBox(height: 45),
              _formSkeleton(),
              const SizedBox(height: 42),
              const Center(
                child: SkeletonBox(width: 145, height: 18, borderRadius: 8),
              ),
              const SizedBox(height: 14),
              _exerciseSkeleton(),
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

  Widget _formSkeleton() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SkeletonBox(width: 135, height: 38, borderRadius: 22),
          const SizedBox(height: 18),
          const SkeletonBox(width: 230, height: 38, borderRadius: 22),
          const SizedBox(height: 10),
          const SkeletonBox(width: 230, height: 38, borderRadius: 22),
          const SizedBox(height: 10),
          const SkeletonBox(width: 230, height: 38, borderRadius: 22),
          const SizedBox(height: 18),
          const SkeletonBox(width: 160, height: 38, borderRadius: 20),
          const SizedBox(height: 22),
          const SkeletonBox(width: 185, height: 9, borderRadius: 5),
          const SizedBox(height: 5),
          const SkeletonBox(width: 130, height: 9, borderRadius: 5),
        ],
      ),
    );
  }

  Widget _exerciseSkeleton() {
    return Container(
      width: double.infinity,
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(18),
      ),
      child: const Row(
        children: [
          SkeletonBox(width: 52, height: 52, borderRadius: 14),
          SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SkeletonBox(width: 135, height: 13, borderRadius: 6),
                SizedBox(height: 9),
                SkeletonBox(width: 95, height: 11, borderRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}