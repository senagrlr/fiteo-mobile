import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class MealHeaderData {
  final String name;
  final String imagePath;

  const MealHeaderData({
    required this.name,
    required this.imagePath,
  });
}

class MealSwipeHeader extends StatefulWidget {
  final int selectedIndex;
  final PageController pageController;
  final List<MealHeaderData> meals;
  final int streakDays;
  final int calories;
  final int fats;
  final int carbs;
  final int proteins;
  final ValueChanged<int> onPageChanged;

  const MealSwipeHeader({
    super.key,
    required this.selectedIndex,
    required this.pageController,
    required this.meals,
    required this.streakDays,
    required this.calories,
    required this.fats,
    required this.carbs,
    required this.proteins,
    required this.onPageChanged,
  });

  @override
  State<MealSwipeHeader> createState() {
    return _MealSwipeHeaderState();
  }
}

class _MealSwipeHeaderState extends State<MealSwipeHeader> {
  double currentPage = 0;

  @override
  void initState() {
    super.initState();

    currentPage = widget.selectedIndex.toDouble();

    widget.pageController.addListener(
      _pageListener,
    );
  }

  void _pageListener() {
    if (!widget.pageController.hasClients) {
      return;
    }

    final page = widget.pageController.page;

    if (page == null || !mounted) {
      return;
    }

    setState(() {
      currentPage = page;
    });
  }

  @override
  void didUpdateWidget(
      covariant MealSwipeHeader oldWidget,
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

    if (!widget.pageController.hasClients &&
        widget.selectedIndex != currentPage.round()) {
      currentPage = widget.selectedIndex.toDouble();
    }
  }

  @override
  void dispose() {
    widget.pageController.removeListener(
      _pageListener,
    );

    super.dispose();
  }

  int get _visibleMealIndex {
    if (widget.meals.isEmpty) {
      return 0;
    }

    return currentPage.round().clamp(
      0,
      widget.meals.length - 1,
    );
  }

  double get _swipeProgress {
    final nearestPage = currentPage.roundToDouble();

    return (currentPage - nearestPage).clamp(
      -1.0,
      1.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final statusBarHeight =
        MediaQuery.paddingOf(context).top;

    if (widget.meals.isEmpty) {
      return const SizedBox.shrink();
    }

    final meal = widget.meals[_visibleMealIndex];
    final progress = _swipeProgress;

    final horizontalOffset = progress * -150;

    final arcOffset =
        math.sin(progress.abs() * math.pi) * -42;

    final rotation = progress * -0.25;

    final scale = 1 - (progress.abs() * 0.06);

    return SizedBox(
      height: 410,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          ClipPath(
            clipper: _MealHeaderClipper(),
            child: Container(
              width: double.infinity,
              height: 315,
              color: AppColors.calendarCompleted,
            ),
          ),

          Positioned(
            top: statusBarHeight + 16,
            left: 24,
            child: Text(
              _formattedDate(),
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),

          Positioned(
            top: statusBarHeight + 10,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.local_fire_department_rounded,
                    color: AppColors.red,
                    size: 18,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.streakDays} days',
                    style: const TextStyle(
                      color: AppColors.homeBrown,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Positioned.fill(
            child: PageView.builder(
              controller: widget.pageController,
              physics: const ClampingScrollPhysics(),
              onPageChanged: widget.onPageChanged,
              itemCount: widget.meals.length,
              itemBuilder: (
                  context,
                  index,
                  ) {
                final pageDifference =
                    currentPage - index;

                final absoluteDifference =
                pageDifference.abs().clamp(
                  0.0,
                  1.0,
                );

                final opacity =
                    1 - absoluteDifference;

                final titleOffset =
                    pageDifference * -80;

                final pageMeal =
                widget.meals[index];

                return Stack(
                  children: [
                    Positioned(
                      top: statusBarHeight + 76,
                      left: 20,
                      right: 20,
                      child: Transform.translate(
                        offset: Offset(
                          titleOffset,
                          0,
                        ),
                        child: Opacity(
                          opacity: opacity,
                          child: Column(
                            children: [
                              Text(
                                pageMeal.name,
                                textAlign:
                                TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 38,
                                  fontWeight:
                                  FontWeight.w800,
                                  height: 1,
                                ),
                              ),
                              const SizedBox(height: 10),
                              _MealMacroSummary(
                                calories:
                                widget.calories,
                                fats: widget.fats,
                                carbs: widget.carbs,
                                proteins:
                                widget.proteins,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),

          Positioned(
            top: 152 + arcOffset,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Transform.translate(
                offset: Offset(
                  horizontalOffset,
                  0,
                ),
                child: Transform.rotate(
                  angle: rotation,
                  child: Transform.scale(
                    scale: scale,
                    child: Center(
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 220,
                        ),
                        switchInCurve:
                        Curves.easeOutCubic,
                        switchOutCurve:
                        Curves.easeInCubic,
                        transitionBuilder: (
                            child,
                            animation,
                            ) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(
                                begin: 0.94,
                                end: 1,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: SizedBox(
                          key: ValueKey(
                            meal.imagePath,
                          ),
                          width: 300,
                          height: 300,
                          child: Image.asset(
                            meal.imagePath,
                            width: 300,
                            height: 300,
                            fit: BoxFit.contain,
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
                                      .restaurant_rounded,
                                  color:
                                  AppColors.homeBrown,
                                  size: 90,
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
          ),
        ],
      ),
    );
  }

  String _formattedDate() {
    final now = DateTime.now();

    const months = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    return '${now.day} ${months[now.month - 1]}';
  }
}

class _MealMacroSummary extends StatelessWidget {
  final int calories;
  final int fats;
  final int carbs;
  final int proteins;

  const _MealMacroSummary({
    required this.calories,
    required this.fats,
    required this.carbs,
    required this.proteins,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
      ),
      child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.center,
          children: [
            _value('$calories kcal'),
            _divider(),
            _value('$proteins protein'),
            _divider(),
            _value('$fats fat'),
            _divider(),
            _value('$carbs carbs'),
          ],
        ),
      ),
    );
  }

  Widget _value(String value) {
    return Text(
      value,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 15,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  Widget _divider() {
    return Container(
      width: 1.2,
      height: 24,
      margin: const EdgeInsets.symmetric(
        horizontal: 14,
      ),
      color: Colors.white.withValues(
        alpha: 0.82,
      ),
    );
  }
}

class _MealHeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();

    path.lineTo(
      0,
      size.height * 0.74,
    );

    path.quadraticBezierTo(
      size.width * 0.5,
      size.height * 1.12,
      size.width,
      size.height * 0.74,
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