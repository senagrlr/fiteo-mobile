import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class GoalWeightScreen extends StatefulWidget {
  final double initialWeightKg;
  final ValueChanged<double> onContinue;
  final VoidCallback onBack;

  const GoalWeightScreen({
    super.key,
    required this.initialWeightKg,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<GoalWeightScreen> createState() =>
      _GoalWeightScreenState();
}

class _GoalWeightScreenState
    extends State<GoalWeightScreen> {
  static const double _minimumKg = 30;
  static const double _maximumKg = 200;

  static const double _minimumLb = 66;
  static const double _maximumLb = 440;

  static const double _itemWidth = 10;
  static const int _decimalMultiplier = 10;

  late final ScrollController _scrollController;

  String selectedUnit = 'KG';
  double selectedWeightKg = 70;

  bool _isControllerReady = false;

  double get displayedWeight {
    if (selectedUnit == 'KG') {
      return selectedWeightKg;
    }

    return selectedWeightKg * 2.2046226218;
  }

  double get minimumDisplayedWeight {
    return selectedUnit == 'KG'
        ? _minimumKg
        : _minimumLb;
  }

  double get maximumDisplayedWeight {
    return selectedUnit == 'KG'
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

  @override
  void initState() {
    super.initState();

    selectedWeightKg =
        widget.initialWeightKg.clamp(
          _minimumKg,
          _maximumKg,
        );

    _scrollController = ScrollController();

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

  double _lbToKg(double lb) {
    return lb / 2.2046226218;
  }

  double _valueForIndex(int index) {
    return minimumDisplayedWeight +
        (index / _decimalMultiplier);
  }

  int _indexFromScrollOffset(double offset) {
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

    final value = _valueForIndex(index);

    final newWeightKg =
    selectedUnit == 'KG'
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
        currentRulerIndex * _itemWidth;

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

  void _changeUnit(String unit) {
    if (selectedUnit == unit) {
      return;
    }

    setState(() {
      selectedUnit = unit;
      _isControllerReady = false;
    });

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      _jumpToSelectedWeight();
    });
  }

  String _formattedWeight() {
    return displayedWeight
        .toStringAsFixed(1);
  }

  void _continue() {
    final roundedWeightKg =
    double.parse(
      selectedWeightKg
          .toStringAsFixed(1),
    );

    widget.onContinue(
      roundedWeightKg,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.sizeOf(context).width;

    return SystemNavigationBar(
      color: AppColors.onboardingBackground,
      child: Scaffold(
        backgroundColor:
        AppColors.onboardingBackground,
        body: SafeArea(
          child: Padding(
            padding:
            EdgeInsets.symmetric(
              horizontal:
              screenWidth * 0.10,
            ),
            child: Column(
              children: [
                const SizedBox(height: 24),

                const SetupProgressIndicator(
                  currentStep: 6,
                  totalSteps: 7,
                ),

                const SizedBox(height: 25),

                Align(
                  alignment:
                  Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: widget.onBack,
                    behavior:
                    HitTestBehavior.opaque,
                    child: const Padding(
                      padding:
                      EdgeInsets.all(4),
                      child: Icon(
                        Icons
                            .arrow_back_ios_new,
                        size: 24,
                        color:
                        AppColors.authText,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 54),

                Text(
                  context.l10n.goalWeightTitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles
                      .headingLarge
                      .copyWith(
                    color:
                    AppColors.authText,
                  ),
                ),

                const SizedBox(height: 24),

                _UnitSelector(
                  selectedUnit:
                  selectedUnit,
                  onChanged:
                  _changeUnit,
                ),

                const SizedBox(height: 52),

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
                        AppColors.authText,
                        fontSize: 38,
                        height: 1,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    const SizedBox(width: 5),

                    Padding(
                      padding:
                      const EdgeInsets.only(
                        bottom: 3,
                      ),
                      child: Text(
                        selectedUnit,
                        style: AppTextStyles
                            .labelMedium
                            .copyWith(
                          color: AppColors
                              .authText
                              .withValues(
                            alpha: 0.65,
                          ),
                          fontWeight:
                          FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 26),

                SizedBox(
                  height: 74,
                  child: LayoutBuilder(
                    builder:
                        (context, constraints) {
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
                            onNotification:
                                (notification) {
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
                              itemBuilder:
                                  (context,
                                  index) {
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
                                          .authText
                                          .withValues(
                                        alpha:
                                        isWholeNumber
                                            ? 0.65
                                            : 0.40,
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

                          IgnorePointer(
                            child: Container(
                              width: 3,
                              height: 48,
                              decoration:
                              BoxDecoration(
                                color: AppColors
                                    .authButtonGreen,
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

                const Spacer(),

                CustomButton(
                  text:
                  context.l10n.continueText,
                  onPressed: _continue,
                  backgroundColor:
                  AppColors.authButtonGreen,
                  textColor:
                  Colors.white,
                  height: 54,
                  width:
                  screenWidth * 0.72,
                  fontSize: 22,
                ),

                const SizedBox(height: 36),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnitSelector
    extends StatelessWidget {
  final String selectedUnit;
  final ValueChanged<String> onChanged;

  const _UnitSelector({
    required this.selectedUnit,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(
          alpha: 0.55,
        ),
        borderRadius:
        BorderRadius.circular(24),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _UnitButton(
            title: 'LB',
            isSelected:
            selectedUnit == 'LB',
            onTap: () =>
                onChanged('LB'),
          ),

          const SizedBox(width: 5),

          _UnitButton(
            title: 'KG',
            isSelected:
            selectedUnit == 'KG',
            onTap: () =>
                onChanged('KG'),
          ),
        ],
      ),
    );
  }
}

class _UnitButton extends StatelessWidget {
  final String title;
  final bool isSelected;
  final VoidCallback onTap;

  const _UnitButton({
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(
          milliseconds: 180,
        ),
        width: 58,
        height: 30,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.authButtonGreen
              : Colors.white,
          borderRadius:
          BorderRadius.circular(18),
        ),
        child: Text(
          title,
          style:
          AppTextStyles.labelMedium.copyWith(
            color: isSelected
                ? Colors.white
                : AppColors.authText.withValues(
              alpha: 0.60,
            ),
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}