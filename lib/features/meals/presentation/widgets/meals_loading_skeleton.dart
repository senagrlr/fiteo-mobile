import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';

class MealsLoadingContent extends StatelessWidget {
  const MealsLoadingContent({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.zero,
      child: Column(
        children: [
          _headerSkeleton(context),
          Padding(
            padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
            child: AppShimmer(
              child: Column(
                children: [
                  _formSkeleton(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _headerSkeleton(BuildContext context) {
    final statusBarHeight = MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 410,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _MealsLoadingHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 315,
              color: AppColors.calendarCompleted,
            ),
          ),
          Positioned(
            top: statusBarHeight + 16,
            left: 24,
            child: const AppShimmer(
              child: SkeletonBox(width: 92, height: 20, borderRadius: 8),
            ),
          ),
          Positioned(
            top: statusBarHeight + 10,
            right: 20,
            child: Container(
              width: 102,
              height: 36,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              alignment: Alignment.center,
              child: const AppShimmer(
                child: SkeletonBox(width: 68, height: 12, borderRadius: 6),
              ),
            ),
          ),
          Positioned(
            top: statusBarHeight + 76,
            left: 0,
            right: 0,
            child: const AppShimmer(
              child: Column(
                children: [
                  SkeletonBox(width: 145, height: 38, borderRadius: 10),
                  SizedBox(height: 12),
                  SkeletonBox(width: 240, height: 15, borderRadius: 7),
                ],
              ),
            ),
          ),
          Positioned(
            top: 207,
            left: 0,
            right: 0,
            child: Center(
              child: AppShimmer(
                child: Container(
                  width: 150,
                  height: 150,
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _formSkeleton() {
    return Column(
      children: [
        const SkeletonBox(width: 128, height: 38, borderRadius: 22),

        const SizedBox(height: 12),

        const SkeletonBox(
          width: 150,
          height: 38,
          borderRadius: 22,
        ),

        const SizedBox(height: 18),

        const SkeletonBox(width: 230, height: 38, borderRadius: 22),

        const SizedBox(height: 10),

        const SkeletonBox(width: 230, height: 38, borderRadius: 22),

        const SizedBox(height: 18),

        const SkeletonBox(width: 175, height: 9, borderRadius: 5),

        const SizedBox(height: 6),

        const SkeletonBox(width: 145, height: 9, borderRadius: 5),

        const SizedBox(height: 18),

        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SkeletonBox(width: 70, height: 38, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 70, height: 38, borderRadius: 20),
            SizedBox(width: 8),
            SkeletonBox(width: 70, height: 38, borderRadius: 20),
          ],
        ),

        const SizedBox(height: 8),

        const SkeletonBox(width: 150, height: 38, borderRadius: 20),
      ],
    );
  }
}

class _MealsLoadingHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(0, size.height * 0.74);
    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.12,
      size.width,
      size.height * 0.74,
    );
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}