import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/plan_tracking_tabs.dart';

class PlanTrackingLockedHeader extends StatefulWidget {
  final int selectedTab;
  final ValueChanged<int> onTabChanged;

  const PlanTrackingLockedHeader({
    super.key,
    required this.selectedTab,
    required this.onTabChanged,
  });

  @override
  State<PlanTrackingLockedHeader> createState() =>
      _PlanTrackingLockedHeaderState();
}

class _PlanTrackingLockedHeaderState
    extends State<PlanTrackingLockedHeader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _rotation;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 850,
      ),
    )..repeat(
      reverse: true,
    );

    _rotation = Tween<double>(
      begin: -0.045,
      end: 0.045,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _scale = Tween<double>(
      begin: 0.96,
      end: 1.04,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
            clipper: _LockedHeaderClipper(),
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
                selectedIndex:
                widget.selectedTab,
                onChanged:
                widget.onTabChanged,
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
                  widget.selectedTab == 0
                      ? context.l10n.fiteoScore
                      : context.l10n.planStatus,
                  style: const TextStyle(
                    color:
                    AppColors.onPrimary,
                    fontSize: 20,
                    fontWeight:
                    FontWeight.w700,
                  ),
                ),

                const SizedBox(
                  height: 7,
                ),

                AnimatedBuilder(
                  animation: _controller,
                  builder: (
                      context,
                      child,
                      ) {
                    return Transform.rotate(
                      angle: _rotation.value,
                      child: Transform.scale(
                        scale: _scale.value,
                        child: child,
                      ),
                    );
                  },
                  child: const Text(
                    '?',
                    style: TextStyle(
                      color:
                      AppColors.onPrimary,
                      fontSize: 50,
                      height: 1,
                      fontWeight:
                      FontWeight.w800,
                    ),
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

class _LockedHeaderClipper
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