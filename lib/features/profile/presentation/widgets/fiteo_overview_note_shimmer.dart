import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';

class FiteoOverviewNoteShimmer extends StatelessWidget {
  const FiteoOverviewNoteShimmer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          AppShimmer(
            child: Container(
              width: double.infinity,
              constraints: const BoxConstraints(
                minHeight: 125,
              ),
              padding: const EdgeInsets.fromLTRB(
                20,
                27,
                20,
                18,
              ),
              decoration: BoxDecoration(
                color:
                AppColors.planTrackingNoteBackground,
                borderRadius: BorderRadius.circular(22),
                boxShadow: const [
                  BoxShadow(
                    color:
                    AppColors.calendarSummaryShadow,
                    blurRadius: 14,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  SkeletonBox(
                    width: double.infinity,
                    height: 12,
                    borderRadius: 6,
                  ),
                  SizedBox(height: 8),
                  SkeletonBox(
                    width: double.infinity,
                    height: 12,
                    borderRadius: 6,
                  ),
                  SizedBox(height: 8),
                  SkeletonBox(
                    width: 180,
                    height: 12,
                    borderRadius: 6,
                  ),
                ],
              ),
            ),
          ),

          Positioned(
            top: -12,
            left: 21,
            child: Transform.rotate(
              angle: -0.08,
              child: const Icon(
                Icons.attach_file_rounded,
                color: AppColors.planTrackingLabel,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }
}