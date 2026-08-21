import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_tabs.dart';

class FiteoScoreHeader extends StatelessWidget {
  final int score;
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const FiteoScoreHeader({
    super.key,
    required this.score,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final statusBarHeight =
        MediaQuery.paddingOf(context).top;

    return SizedBox(
      height: 220,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _FiteoScoreHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 220,
              color:
              AppColors.planTrackingHeaderBackground,
            ),
          ),

          // Geri oku
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

          // Genel Bakış / Plan
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

          // Fiteo Score
          Positioned(
            top: statusBarHeight + 77,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Text(
                  context.l10n.fiteoScore,
                  style:
                  AppTextStyles.headingSmall.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                const SizedBox(height: 5),

                Text(
                  score.toString(),
                  style:
                  AppTextStyles.displayLarge.copyWith(
                    color: AppColors.onPrimary,
                    fontSize: 50,
                    fontWeight: FontWeight.w700,
                    height: 1,
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

class _FiteoScoreHeaderClipper
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