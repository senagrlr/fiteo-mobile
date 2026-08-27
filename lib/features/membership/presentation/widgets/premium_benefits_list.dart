import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/membership/presentation/models/premium_feature_item.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_feature_carousel.dart';
import 'package:fiteo_myapp/features/membership/presentation/widgets/premium_indicator.dart';

class PremiumBenefitsList extends StatelessWidget {
  final PageController pageController;
  final List<PremiumFeatureItem> features;
  final int currentIndex;
  final ValueChanged<int> onPageChanged;

  const PremiumBenefitsList({
    super.key,
    required this.pageController,
    required this.features,
    required this.currentIndex,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 260,
          child: PremiumFeatureCarousel(
            pageController: pageController,
            features: features,
            onPageChanged: onPageChanged,
          ),
        ),

        PremiumIndicator(
          currentIndex: currentIndex,
          count: features.length,
        ),
      ],
    );
  }
}