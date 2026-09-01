import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';

class WeeklyWeightUpdateSheet
    extends StatefulWidget {
  final double initialWeightKg;
  final String unit;

  final Future<void> Function(double weightKg) onUpdate;

  const WeeklyWeightUpdateSheet({
    super.key,
    required this.initialWeightKg,
    required this.unit,
    required this.onUpdate,
  });

  @override
  State<WeeklyWeightUpdateSheet> createState() =>
      _WeeklyWeightUpdateSheetState();
}

class _WeeklyWeightUpdateSheetState
    extends State<WeeklyWeightUpdateSheet> {
  static const double _minimumKg = 30;
  static const double _maximumKg = 200;

  static const double _minimumLb = 66;
  static const double _maximumLb = 440;

  static const double _itemWidth = 10;
  static const int _decimalMultiplier = 10;

  late final ScrollController _scrollController;

  late double selectedWeightKg;

  bool _isControllerReady = false;

  bool get isKg =>
      widget.unit.toUpperCase() == 'KG';

  double get displayedWeight {
    if (isKg) {
      return selectedWeightKg;
    }

    return selectedWeightKg * 2.2046226218;
  }

  double get initialDisplayedWeight {
    if (isKg) {
      return widget.initialWeightKg;
    }

    return widget.initialWeightKg *
        2.2046226218;
  }

  double get minimumDisplayedWeight {
    return isKg
        ? _minimumKg
        : _minimumLb;
  }

  double get maximumDisplayedWeight {
    return isKg
        ? _maximumKg
        : _maximumLb;
  }

  int get totalRulerItems {
    return ((maximumDisplayedWeight -
        minimumDisplayedWeight) *
        _decimalMultiplier)
        .round() +
        1;
  }

  int get currentRulerIndex {
    return ((displayedWeight -
        minimumDisplayedWeight) *
        _decimalMultiplier)
        .round()
        .clamp(
      0,
      totalRulerItems - 1,
    );
  }

  double get displayedDifference {
    return displayedWeight -
        initialDisplayedWeight;
  }

  @override
  void initState() {
    super.initState();

    selectedWeightKg =
        widget.initialWeightKg.clamp(
          _minimumKg,
          _maximumKg,
        );

    _scrollController =
        ScrollController();

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _jumpToSelectedWeight();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();

    super.dispose();
  }

  double _lbToKg(
      double lb,
      ) {
    return lb / 2.2046226218;
  }

  double _valueForIndex(
      int index,
      ) {
    return minimumDisplayedWeight +
        (index / _decimalMultiplier);
  }

  int _indexFromScrollOffset(
      double offset,
      ) {
    final index =
    (offset / _itemWidth).round();

    return index.clamp(
      0,
      totalRulerItems - 1,
    );
  }

  void _updateWeightFromScroll() {
    if (!_scrollController.hasClients ||
        !_isControllerReady) {
      return;
    }

    final index =
    _indexFromScrollOffset(
      _scrollController.offset,
    );

    final value =
    _valueForIndex(index);

    final newWeightKg =
    isKg
        ? value
        : _lbToKg(value);

    final clampedWeight =
    newWeightKg.clamp(
      _minimumKg,
      _maximumKg,
    );

    if ((selectedWeightKg -
        clampedWeight)
        .abs() <
        0.001) {
      return;
    }

    setState(() {
      selectedWeightKg =
          clampedWeight;
    });
  }

  void _jumpToSelectedWeight() {
    if (!_scrollController.hasClients) {
      return;
    }

    _isControllerReady = true;

    final targetOffset =
        currentRulerIndex *
            _itemWidth;

    _scrollController.jumpTo(
      targetOffset.clamp(
        0,
        _scrollController
            .position
            .maxScrollExtent,
      ),
    );

    _updateWeightFromScroll();
  }

  Future<void>
  _snapToNearestValue() async {
    if (!_scrollController.hasClients) {
      return;
    }

    final index =
    _indexFromScrollOffset(
      _scrollController.offset,
    );

    final targetOffset =
        index * _itemWidth;

    await _scrollController.animateTo(
      targetOffset.clamp(
        0,
        _scrollController
            .position
            .maxScrollExtent,
      ),
      duration: const Duration(
        milliseconds: 180,
      ),
      curve: Curves.easeOut,
    );

    _updateWeightFromScroll();
  }

  String _formattedWeight() {
    return displayedWeight
        .toStringAsFixed(1);
  }

  String _formattedDifference() {
    final difference =
        displayedDifference;

    if (difference.abs() < 0.05) {
      return '0.0 ${widget.unit.toUpperCase()}';
    }

    final sign =
    difference > 0 ? '+' : '';

    return '$sign${difference.toStringAsFixed(1)} '
        '${widget.unit.toUpperCase()}';
  }

  Future<void> _update() async {
    final roundedWeightKg = double.parse(
      selectedWeightKg.toStringAsFixed(1),
    );

    await widget.onUpdate(
      roundedWeightKg,
    );

    if (!mounted) return;

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding:
          const EdgeInsets.fromLTRB(
            26,
            14,
            26,
            28,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              // DRAG HANDLE
              Container(
                width: 46,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors
                      .planTrackingSecondaryLabel
                      .withValues(
                    alpha: 0.32,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              const SizedBox(
                height: 22,
              ),

              Text(
                context.l10n
                    .weeklyWeightUpdateTitle,
                textAlign:
                TextAlign.center,
                style: AppTextStyles
                    .headingLarge
                    .copyWith(
                  color:
                  AppColors.homeBrown,
                  fontSize: 24,
                  fontWeight:
                  FontWeight.w800,
                  height: 1.15,
                ),
              ),

              const SizedBox(
                height: 9,
              ),

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                ),
                child: Text(
                  context
                      .l10n
                      .weeklyWeightUpdateDescription,
                  textAlign:
                  TextAlign.center,
                  style: AppTextStyles
                      .bodyMedium
                      .copyWith(
                    color: AppColors
                        .planTrackingSecondaryLabel,
                    fontSize: 13,
                    fontWeight:
                    FontWeight.w500,
                    height: 1.4,
                  ),
                ),
              ),

              const SizedBox(
                height: 28,
              ),

              // SELECTED WEIGHT
              Row(
                mainAxisAlignment:
                MainAxisAlignment.center,
                crossAxisAlignment:
                CrossAxisAlignment.end,
                children: [
                  Text(
                    _formattedWeight(),
                    style: AppTextStyles
                        .displayMedium
                        .copyWith(
                      color:
                      AppColors.homeBrown,
                      fontSize: 38,
                      fontWeight:
                      FontWeight.w800,
                      height: 1,
                    ),
                  ),

                  const SizedBox(
                    width: 6,
                  ),

                  Padding(
                    padding:
                    const EdgeInsets.only(
                      bottom: 3,
                    ),
                    child: Text(
                      widget.unit
                          .toUpperCase(),
                      style: AppTextStyles
                          .labelMedium
                          .copyWith(
                        color: AppColors
                            .planTrackingSecondaryLabel,
                        fontSize: 13,
                        fontWeight:
                        FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(
                height: 26,
              ),

              // RULER
              SizedBox(
                height: 72,
                child: LayoutBuilder(
                  builder: (
                      context,
                      constraints,
                      ) {
                    final sidePadding =
                        (constraints
                            .maxWidth -
                            _itemWidth) /
                            2;

                    return Stack(
                      alignment:
                      Alignment.topCenter,
                      children: [
                        NotificationListener<
                            ScrollNotification>(
                          onNotification: (
                              notification,
                              ) {
                            if (notification
                            is ScrollUpdateNotification) {
                              _updateWeightFromScroll();
                            }

                            if (notification
                            is ScrollEndNotification) {
                              _snapToNearestValue();
                            }

                            return false;
                          },
                          child:
                          ListView.builder(
                            controller:
                            _scrollController,
                            scrollDirection:
                            Axis.horizontal,
                            physics:
                            const ClampingScrollPhysics(),
                            padding:
                            EdgeInsets.symmetric(
                              horizontal:
                              sidePadding,
                            ),
                            itemCount:
                            totalRulerItems,
                            itemExtent:
                            _itemWidth,
                            itemBuilder: (
                                context,
                                index,
                                ) {
                              final isWholeNumber =
                                  index % 10 ==
                                      0;

                              final isHalfNumber =
                                  index % 5 ==
                                      0;

                              final tickHeight =
                              isWholeNumber
                                  ? 34.0
                                  : isHalfNumber
                                  ? 26.0
                                  : 18.0;

                              return Align(
                                alignment:
                                Alignment
                                    .topCenter,
                                child:
                                Container(
                                  width:
                                  isWholeNumber
                                      ? 2
                                      : 1,
                                  height:
                                  tickHeight,
                                  decoration:
                                  BoxDecoration(
                                    color: AppColors
                                        .homeBrown
                                        .withValues(
                                      alpha:
                                      isWholeNumber
                                          ? 0.55
                                          : 0.28,
                                    ),
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      2,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // ORTA SEÇİM ÇİZGİSİ
                        IgnorePointer(
                          child: Container(
                            width: 3,
                            height: 48,
                            decoration:
                            BoxDecoration(
                              color: AppColors
                                  .calendarCompleted,
                              borderRadius:
                              BorderRadius
                                  .circular(
                                3,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),

              // CHANGE VALUE
              Align(
                alignment:
                Alignment.centerRight,
                child: AnimatedSwitcher(
                  duration:
                  const Duration(
                    milliseconds: 160,
                  ),
                  child: Text(
                    _formattedDifference(),
                    key: ValueKey(
                      _formattedDifference(),
                    ),
                    style: AppTextStyles
                        .labelMedium
                        .copyWith(
                      color: AppColors
                          .planTrackingSecondaryLabel,
                      fontSize: 12,
                      fontWeight:
                      FontWeight.w700,
                    ),
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              CustomButton(
                text: context
                    .l10n
                    .updateWeight,
                onPressed: _update,
                backgroundColor:
                AppColors
                    .calendarCompleted,
                textColor:
                Colors.white,
                height: 50,
                width:
                screenWidth * 0.58,
                fontSize: 17,
              ),

              const SizedBox(
                height: 4,
              ),
            ],
          ),
        ),
      ),
    );
  }
}