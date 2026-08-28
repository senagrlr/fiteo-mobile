import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';

class PremiumIndicator
    extends StatelessWidget {
  final int currentIndex;
  final int count;

  const PremiumIndicator({
    super.key,
    required this.currentIndex,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) {
          final selected =
              currentIndex == index;

          return AnimatedContainer(
            duration:
            const Duration(
              milliseconds: 180,
            ),
            width: 8,
            height: 8,
            margin:
            const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            decoration: BoxDecoration(
              shape: BoxShape.circle,

              // seçili: #693C37
              // seçili değil: #ABA4A3
              color: selected
                  ? AppColors.homeBrown
                  : AppColors
                  .planTrackingSecondaryLabel,
            ),
          );
        },
      ),
    );
  }
}