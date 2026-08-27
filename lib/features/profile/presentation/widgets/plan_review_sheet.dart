import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';

class PlanNutritionTargets {
  final double calories;
  final double protein;
  final double carbs;
  final double fats;
  final double waterLiters;

  const PlanNutritionTargets({
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fats,
    required this.waterLiters,
  });
}

class PlanReviewSheet extends StatefulWidget {
  final PlanNutritionTargets previousPlan;
  final PlanNutritionTargets newPlan;
  final VoidCallback onSavePlan;

  const PlanReviewSheet({
    super.key,
    required this.previousPlan,
    required this.newPlan,
    required this.onSavePlan,
  });

  @override
  State<PlanReviewSheet> createState() =>
      _PlanReviewSheetState();
}

class _PlanReviewSheetState
    extends State<PlanReviewSheet>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _animationController;

  @override
  void initState() {
    super.initState();

    _animationController =
        AnimationController(
          vsync: this,
          duration: const Duration(
            milliseconds: 1500,
          ),
        );

    WidgetsBinding.instance
        .addPostFrameCallback((_) {
      if (!mounted) return;

      _animationController.forward();
    });
  }

  @override
  void dispose() {
    _animationController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight =
        MediaQuery.sizeOf(context).height;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    return Container(
      constraints: BoxConstraints(
        maxHeight: screenHeight * 0.88,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfacePrimary,
        borderRadius:
        BorderRadius.vertical(
          top: Radius.circular(34),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics:
          const ClampingScrollPhysics(),
          padding:
          const EdgeInsets.fromLTRB(
            26,
            16,
            26,
            30,
          ),
          child: Column(
            mainAxisSize:
            MainAxisSize.min,
            children: [
              // ================================================
              // DRAG HANDLE
              // ================================================

              Container(
                width: 48,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors
                      .planTrackingSecondaryLabel
                      .withValues(
                    alpha: 0.35,
                  ),
                  borderRadius:
                  BorderRadius.circular(
                    20,
                  ),
                ),
              ),

              const SizedBox(
                height: 24,
              ),

              // ================================================
              // ICON
              // ================================================

              Container(
                width: 68,
                height: 68,
                decoration: BoxDecoration(
                  color: AppColors
                      .calendarCompleted
                      .withValues(
                    alpha: 0.15,
                  ),
                  shape:
                  BoxShape.circle,
                ),
                child: const Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors
                      .calendarCompleted,
                  size: 34,
                ),
              ),

              const SizedBox(
                height: 17,
              ),

              // ================================================
              // TITLE
              // ================================================

              Text(
                context.l10n.newPlanTitle,
                textAlign:
                TextAlign.center,
                style: AppTextStyles
                    .headingLarge
                    .copyWith(
                  color:
                  AppColors.homeBrown,
                  fontSize: 27,
                  fontWeight:
                  FontWeight.w800,
                  height: 1.15,
                ),
              ),

              const SizedBox(
                height: 9,
              ),

              Text(
                context
                    .l10n
                    .newPlanDescription,
                textAlign:
                TextAlign.center,
                style: AppTextStyles
                    .bodyMedium
                    .copyWith(
                  color: AppColors
                      .planTrackingSecondaryLabel,
                  fontSize: 14,
                  fontWeight:
                  FontWeight.w500,
                  height: 1.4,
                ),
              ),

              const SizedBox(
                height: 27,
              ),

              // ================================================
              // DAILY TARGETS
              // ================================================

              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.fromLTRB(
                  18,
                  20,
                  18,
                  8,
                ),
                decoration: BoxDecoration(
                  color:
                  AppColors.surfacePrimary,
                  borderRadius:
                  BorderRadius.circular(
                    26,
                  ),
                  border: Border.all(
                    color: AppColors
                        .planTrackingSecondaryLabel
                        .withValues(
                      alpha: 0.13,
                    ),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black
                          .withValues(
                        alpha: 0.045,
                      ),
                      blurRadius: 14,
                      offset:
                      const Offset(
                        0,
                        5,
                      ),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                      const EdgeInsets.only(
                        left: 4,
                      ),
                      child: Text(
                        context
                            .l10n
                            .dailyTargets,
                        style: AppTextStyles
                            .titleMedium
                            .copyWith(
                          color: AppColors
                              .homeBrown,
                          fontSize: 17,
                          fontWeight:
                          FontWeight
                              .w800,
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 18,
                    ),

                    _AnimatedPlanChangeRow(
                      animationController:
                      _animationController,
                      intervalStart: 0.00,
                      intervalEnd: 0.52,
                      icon: Icons
                          .local_fire_department_rounded,
                      label:
                      context.l10n.calories,
                      oldValue: widget
                          .previousPlan.calories,
                      newValue:
                      widget.newPlan.calories,
                      suffix: 'kcal',
                    ),

                    _AnimatedPlanChangeRow(
                      animationController:
                      _animationController,
                      intervalStart: 0.10,
                      intervalEnd: 0.62,
                      icon: Icons
                          .fitness_center_rounded,
                      label:
                      context.l10n.protein,
                      oldValue: widget
                          .previousPlan.protein,
                      newValue:
                      widget.newPlan.protein,
                      suffix: 'g',
                    ),

                    _AnimatedPlanChangeRow(
                      animationController:
                      _animationController,
                      intervalStart: 0.20,
                      intervalEnd: 0.72,
                      icon:
                      Icons.grain_rounded,
                      label: context
                          .l10n
                          .carbohydrates,
                      oldValue: widget
                          .previousPlan.carbs,
                      newValue:
                      widget.newPlan.carbs,
                      suffix: 'g',
                    ),

                    _AnimatedPlanChangeRow(
                      animationController:
                      _animationController,
                      intervalStart: 0.30,
                      intervalEnd: 0.82,
                      icon:
                      Icons.opacity_rounded,
                      label:
                      context.l10n.fats,
                      oldValue: widget
                          .previousPlan.fats,
                      newValue:
                      widget.newPlan.fats,
                      suffix: 'g',
                    ),

                    _AnimatedPlanChangeRow(
                      animationController:
                      _animationController,
                      intervalStart: 0.40,
                      intervalEnd: 1.00,
                      icon: Icons
                          .local_drink_outlined,
                      label:
                      context.l10n.water,
                      oldValue: widget
                          .previousPlan
                          .waterLiters,
                      newValue: widget
                          .newPlan
                          .waterLiters,
                      suffix: 'L',
                      decimalPlaces: 1,
                      showBottomDivider:
                      false,
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: 26,
              ),

              // ================================================
              // SAVE NEW PLAN
              // ================================================

              CustomButton(
                text:
                context.l10n.saveNewPlan,
                onPressed:
                widget.onSavePlan,
                backgroundColor:
                AppColors.calendarCompleted,
                textColor:
                Colors.white,
                height: 54,
                width:
                screenWidth * 0.72,
                fontSize: 17,
              ),

              const SizedBox(
                height: 8,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedPlanChangeRow
    extends StatelessWidget {
  final AnimationController
  animationController;

  final double intervalStart;
  final double intervalEnd;

  final IconData icon;
  final String label;

  final double oldValue;
  final double newValue;

  final String suffix;
  final int decimalPlaces;
  final bool showBottomDivider;

  const _AnimatedPlanChangeRow({
    required this.animationController,
    required this.intervalStart,
    required this.intervalEnd,
    required this.icon,
    required this.label,
    required this.oldValue,
    required this.newValue,
    required this.suffix,
    this.decimalPlaces = 0,
    this.showBottomDivider = true,
  });

  String _formatValue(
      double value,
      ) {
    if (decimalPlaces == 0) {
      return value
          .round()
          .toString();
    }

    return value.toStringAsFixed(
      decimalPlaces,
    );
  }

  @override
  Widget build(BuildContext context) {
    final animation =
    CurvedAnimation(
      parent: animationController,
      curve: Interval(
        intervalStart,
        intervalEnd,
        curve:
        Curves.easeOutCubic,
      ),
    );

    final difference =
        newValue - oldValue;

    final isIncrease =
        difference > 0;

    return AnimatedBuilder(
      animation: animation,
      builder: (
          context,
          child,
          ) {
        final progress =
            animation.value;

        final animatedValue =
            oldValue +
                ((newValue -
                    oldValue) *
                    progress);

        return Column(
          children: [
            Row(
              children: [
                // ==============================================
                // ICON
                // ==============================================

                Container(
                  width: 38,
                  height: 38,
                  decoration:
                  BoxDecoration(
                    color: AppColors
                        .calendarCompleted
                        .withValues(
                      alpha: 0.14,
                    ),
                    shape:
                    BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: AppColors
                        .calendarCompleted,
                    size: 20,
                  ),
                ),

                const SizedBox(
                  width: 12,
                ),

                // ==============================================
                // LABEL
                // ==============================================

                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles
                        .bodyMedium
                        .copyWith(
                      color:
                      AppColors.homeBrown,
                      fontSize: 15,
                      fontWeight:
                      FontWeight.w600,
                    ),
                  ),
                ),

                // ==============================================
                // ANIMATED VALUE
                // ==============================================

                SizedBox(
                  width: 100,
                  child: Text(
                    '${_formatValue(animatedValue)} $suffix',
                    textAlign:
                    TextAlign.end,
                    style: AppTextStyles
                        .bodyMedium
                        .copyWith(
                      color:
                      AppColors.homeBrown,
                      fontSize: 16,
                      fontWeight:
                      FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),

            // ================================================
            // CHANGE AMOUNT
            // ================================================

            if (difference != 0)
              Padding(
                padding:
                const EdgeInsets.only(
                  top: 5,
                  right: 2,
                ),
                child: Align(
                  alignment:
                  Alignment.centerRight,
                  child: Opacity(
                    opacity:
                    progress,
                    child: Row(
                      mainAxisSize:
                      MainAxisSize.min,
                      children: [
                        Icon(
                          isIncrease
                              ? Icons
                              .arrow_upward_rounded
                              : Icons
                              .arrow_downward_rounded,
                          color: AppColors
                              .planTrackingSecondaryLabel,
                          size: 13,
                        ),

                        const SizedBox(
                          width: 2,
                        ),

                        Text(
                          '${_formatValue(difference.abs())} $suffix',
                          style: AppTextStyles
                              .labelSmall
                              .copyWith(
                            color: AppColors
                                .planTrackingSecondaryLabel,
                            fontSize: 10,
                            fontWeight:
                            FontWeight
                                .w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            if (showBottomDivider)
              Padding(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Divider(
                  height: 1,
                  thickness: 1,
                  color: AppColors
                      .planTrackingSecondaryLabel
                      .withValues(
                    alpha: 0.10,
                  ),
                ),
              )
            else
              const SizedBox(
                height: 10,
              ),
          ],
        );
      },
    );
  }
}