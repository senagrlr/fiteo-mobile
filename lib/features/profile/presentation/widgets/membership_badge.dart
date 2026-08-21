import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';

class MembershipBadge extends StatefulWidget {
  final String label;

  const MembershipBadge({
    super.key,
    required this.label,
  });

  @override
  State<MembershipBadge> createState() => _MembershipBadgeState();
}

class _MembershipBadgeState extends State<MembershipBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPremium = widget.label.toUpperCase() == 'PREMIUM';

    final colors = isPremium
        ? const [
      AppColors.membershipPremiumDark,
      AppColors.membershipPremium,
      AppColors.membershipPremiumLight,
      AppColors.membershipPremium,
      AppColors.membershipPremiumDark,
    ]
        : const [
      AppColors.membershipSilverDark,
      AppColors.membershipSilver,
      AppColors.membershipSilverLight,
      AppColors.membershipSilver,
      AppColors.membershipSilverDark,
    ];

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) {
            final position = _controller.value * 2 - 0.5;

            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: colors,
              stops: [
                0,
                (position - 0.15).clamp(0.0, 1.0),
                position.clamp(0.0, 1.0),
                (position + 0.15).clamp(0.0, 1.0),
                1,
              ],
            ).createShader(bounds);
          },
          child: child,
        );
      },
      child: Text(
        widget.label,
        style: AppTextStyles.labelSmall.copyWith(
          fontSize: 16,
          fontWeight: FontWeight.w700,
          letterSpacing: 1.4,
        ),
      ),
    );
  }
}