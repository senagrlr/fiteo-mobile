import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_locked/premium_lock_overlay.dart';

class PremiumLockedPreview extends StatelessWidget {
  final Widget child;
  final double blurSigma;

  const PremiumLockedPreview({
    super.key,
    required this.child,
    this.blurSigma = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          fit: StackFit.expand,
          children: [
            child,

            ClipRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: blurSigma,
                  sigmaY: blurSigma,
                ),
                child: Container(
                  color: const Color(0xFFEEEEEE).withValues(
                    alpha: 0.55,
                  ),
                ),
              ),
            ),

            const PremiumLockOverlay(),
          ],
        ),
      ),
    );
  }
}