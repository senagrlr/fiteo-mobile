import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/features/membership/presentation/models/premium_feature_item.dart';

class PremiumFeatureCarousel
    extends StatefulWidget {
  final PageController pageController;
  final List<PremiumFeatureItem> features;
  final ValueChanged<int> onPageChanged;

  const PremiumFeatureCarousel({
    super.key,
    required this.pageController,
    required this.features,
    required this.onPageChanged,
  });

  @override
  State<PremiumFeatureCarousel>
  createState() =>
      _PremiumFeatureCarouselState();
}

class _PremiumFeatureCarouselState
    extends State<PremiumFeatureCarousel> {
  double currentPage = 0;

  @override
  void initState() {
    super.initState();

    currentPage =
        widget.pageController.initialPage
            .toDouble();

    widget.pageController.addListener(
      _pageListener,
    );
  }

  void _pageListener() {
    if (!widget.pageController.hasClients) {
      return;
    }

    final page =
        widget.pageController.page;

    if (page == null || !mounted) {
      return;
    }

    setState(() {
      currentPage = page;
    });
  }

  @override
  void didUpdateWidget(
      covariant PremiumFeatureCarousel oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.pageController !=
        widget.pageController) {
      oldWidget.pageController.removeListener(
        _pageListener,
      );

      widget.pageController.addListener(
        _pageListener,
      );
    }
  }

  @override
  void dispose() {
    widget.pageController.removeListener(
      _pageListener,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PageView.builder(
      controller: widget.pageController,
      physics:
      const ClampingScrollPhysics(),
      onPageChanged:
      widget.onPageChanged,
      itemCount:
      widget.features.length,
      itemBuilder: (
          context,
          index,
          ) {
        final feature =
        widget.features[index];

        final pageDifference =
            currentPage - index;

        final absoluteDifference =
        pageDifference
            .abs()
            .clamp(
          0.0,
          1.0,
        );

        final horizontalOffset =
            pageDifference * -150;

        final arcOffset =
            math.sin(
              absoluteDifference *
                  math.pi,
            ) *
                -42;

        final rotation =
            pageDifference * -0.25;

        final scale =
            1 -
                (absoluteDifference * 0.06);

        final opacity =
            1 - absoluteDifference;

        final titleOffset =
            pageDifference * -80;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // ILLUSTRATION
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: IgnorePointer(
                child:
                Transform.translate(
                  offset: Offset(
                    horizontalOffset,
                    arcOffset,
                  ),
                  child: Transform.rotate(
                    angle: rotation,
                    child:
                    Transform.scale(
                      scale: scale,
                      child: Center(
                        child: SizedBox(
                          width: 220,
                          height: 220,
                          child: Image.asset(
                            feature.imageAsset,
                            fit:
                            BoxFit.contain,
                            filterQuality:
                            FilterQuality.high,
                            errorBuilder: (
                                context,
                                error,
                                stackTrace,
                                ) {
                              return const Center(
                                child: Icon(
                                  Icons
                                      .auto_awesome_rounded,
                                  size: 90,
                                  color: AppColors
                                      .homeBrown,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // TEXT
            Positioned(
              top: 220,
              left: 24,
              right: 24,
              child:
              Transform.translate(
                offset: Offset(
                  titleOffset,
                  0,
                ),
                child: Opacity(
                  opacity: opacity,
                  child: Text(
                    feature.title,
                    textAlign:
                    TextAlign.center,
                    maxLines: 2,
                    style: AppTextStyles
                        .titleMedium
                        .copyWith(
                      color:
                      AppColors.homeBrown,
                      fontSize: 17,
                      fontWeight:
                      FontWeight.w800,
                      height: 1.25,
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}