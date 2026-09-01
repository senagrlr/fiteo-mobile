import 'package:flutter/material.dart';

import 'package:fiteo_myapp/common/widgets/loading/app_shimmer.dart';
import 'package:fiteo_myapp/common/widgets/loading/skeleton_box.dart';

class ProfileHeaderLoading extends StatelessWidget {
  const ProfileHeaderLoading({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 235,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Positioned(
            top: -45,
            left: -35,
            right: -55,
            child: Image.asset(
              'assets/images/profile_header_bg.png',
              width: MediaQuery.of(context).size.width + 70,
              height: 270,
              fit: BoxFit.fill,
            ),
          ),
          Positioned(
            top: 68,
            left: 0,
            right: 0,
            child: AppShimmer(
              child: Column(
                children: [
                  Container(
                    width: 68,
                    height: 68,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                  const SizedBox(height: 8),
                  const SkeletonBox(width: 85, height: 12, borderRadius: 6),
                  const SizedBox(height: 7),
                  const SkeletonBox(width: 145, height: 15, borderRadius: 7),
                ],
              ),
            ),
          ),
          const Positioned(
            top: 45,
            right: 24,
            child: AppShimmer(
              child: SkeletonBox(width: 72, height: 28, borderRadius: 14),
            ),
          ),
        ],
      ),
    );
  }
}