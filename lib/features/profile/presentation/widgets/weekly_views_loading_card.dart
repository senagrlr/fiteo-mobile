import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';

class WeeklyViewsLoadingCard extends StatelessWidget {
  const WeeklyViewsLoadingCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
      decoration: BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: AppShimmer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Row(
              children: [
                SkeletonBox(width: 125, height: 16, borderRadius: 7),
                Spacer(),
                SkeletonBox(width: 28, height: 28, borderRadius: 14),
              ],
            ),
            const SizedBox(height: 14),
            const Divider(color: AppColors.weeklyChartDivider),
            const SizedBox(height: 14),
            SizedBox(
              height: 165,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const SizedBox(
                    width: 44,
                    height: 126,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SkeletonBox(width: 24, height: 9, borderRadius: 4),
                        SkeletonBox(width: 24, height: 9, borderRadius: 4),
                        SkeletonBox(width: 24, height: 9, borderRadius: 4),
                        SkeletonBox(width: 12, height: 9, borderRadius: 4),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                        7,
                            (index) => Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            SkeletonBox(
                              width: 18,
                              height: 25.0 + (index % 4) * 15.0,
                              borderRadius: 9,
                            ),
                            const SizedBox(height: 6),
                            const SkeletonBox(width: 20, height: 9, borderRadius: 4),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}