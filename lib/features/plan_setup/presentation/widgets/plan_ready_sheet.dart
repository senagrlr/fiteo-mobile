import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';

class AiNutritionPlan {
  final int calories;
  final int proteinGrams;
  final int carbsGrams;
  final int fatsGrams;
  final int waterMl;
  final double expectedWeeklyWeightChangeKg;

  const AiNutritionPlan({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatsGrams,
    required this.waterMl,
    required this.expectedWeeklyWeightChangeKg,
  });

  AiNutritionPlan copyWith({
    int? calories,
    int? proteinGrams,
    int? carbsGrams,
    int? fatsGrams,
    int? waterMl,
    double? expectedWeeklyWeightChangeKg,
  }) {
    return AiNutritionPlan(
      calories: calories ?? this.calories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatsGrams: fatsGrams ?? this.fatsGrams,
      waterMl: waterMl ?? this.waterMl,
      expectedWeeklyWeightChangeKg:
      expectedWeeklyWeightChangeKg ?? this.expectedWeeklyWeightChangeKg,
    );
  }
}

class PlanReadySheet extends StatefulWidget {
  final AiNutritionPlan initialPlan;

  const PlanReadySheet({
    super.key,
    required this.initialPlan,
  });

  @override
  State<PlanReadySheet> createState() {
    return _PlanReadySheetState();
  }
}

class _PlanReadySheetState extends State<PlanReadySheet> {
  late final ConfettiController _confettiController;

  late final TextEditingController _caloriesController;
  late final TextEditingController _proteinController;
  late final TextEditingController _carbsController;
  late final TextEditingController _fatsController;
  late final TextEditingController _waterController;

  @override
  void initState() {
    super.initState();

    _confettiController = ConfettiController(
      duration: const Duration(seconds: 3),
    );

    _caloriesController = TextEditingController(
      text: widget.initialPlan.calories.toString(),
    );

    _proteinController = TextEditingController(
      text: widget.initialPlan.proteinGrams.toString(),
    );

    _carbsController = TextEditingController(
      text: widget.initialPlan.carbsGrams.toString(),
    );

    _fatsController = TextEditingController(
      text: widget.initialPlan.fatsGrams.toString(),
    );

    _waterController = TextEditingController(
      text: (widget.initialPlan.waterMl / 1000)
          .toStringAsFixed(1),
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      _confettiController.play();
    });
  }

  @override
  void dispose() {
    _confettiController.dispose();

    _caloriesController.dispose();
    _proteinController.dispose();
    _carbsController.dispose();
    _fatsController.dispose();
    _waterController.dispose();

    super.dispose();
  }

  void _submit() {
    final calories = int.tryParse(
      _caloriesController.text.trim(),
    );

    final protein = int.tryParse(
      _proteinController.text.trim(),
    );

    final carbs = int.tryParse(
      _carbsController.text.trim(),
    );

    final fats = int.tryParse(
      _fatsController.text.trim(),
    );

    final waterLiters = double.tryParse(
      _waterController.text
          .trim()
          .replaceAll(',', '.'),
    );

    if (calories == null ||
        protein == null ||
        carbs == null ||
        fats == null ||
        waterLiters == null) {
      return;
    }

    if (calories <= 0 ||
        protein < 0 ||
        carbs < 0 ||
        fats < 0 ||
        waterLiters <= 0) {
      return;
    }

    Navigator.pop(
      context,
      AiNutritionPlan(
        calories: calories,
        proteinGrams: protein,
        carbsGrams: carbs,
        fatsGrams: fats,
        waterMl: (waterLiters * 1000).round(),
        expectedWeeklyWeightChangeKg:
        widget.initialPlan.expectedWeeklyWeightChangeKg,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final keyboardHeight =
        MediaQuery.viewInsetsOf(context).bottom;

    final screenHeight =
        MediaQuery.sizeOf(context).height;

    final screenWidth =
        MediaQuery.sizeOf(context).width;

    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Padding(
          padding: EdgeInsets.only(
            top: 22,
            bottom: keyboardHeight,
          ),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.88,
            ),
            decoration: const BoxDecoration(
              color: AppColors.onboardingBackground,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(34),
              ),
            ),
            child: SafeArea(
              top: false,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(
                  26,
                  20,
                  26,
                  30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color:
                        AppColors.authText.withValues(
                          alpha: 0.22,
                        ),
                        borderRadius:
                        BorderRadius.circular(20),
                      ),
                    ),

                    const SizedBox(height: 24),

                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        color: AppColors.authButtonGreen
                            .withValues(
                          alpha: 0.18,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.auto_awesome_rounded,
                        color: AppColors.authButtonGreen,
                        size: 36,
                      ),
                    ),

                    const SizedBox(height: 18),

                    Text(
                      context.l10n.aiPlanReadyTitle,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyles.headingLarge.copyWith(
                        color: AppColors.authText,
                        fontSize: 27,
                        height: 1.15,
                        fontWeight: FontWeight.w800,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      context.l10n.aiPlanReadyDescription,
                      textAlign: TextAlign.center,
                      style:
                      AppTextStyles.bodyMedium.copyWith(
                        color:
                        AppColors.authText.withValues(
                          alpha: 0.72,
                        ),
                        height: 1.45,
                        fontWeight: FontWeight.w400,
                      ),
                    ),

                    const SizedBox(height: 26),

                    Container(
                      padding: const EdgeInsets.fromLTRB(
                        18,
                        20,
                        18,
                        8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(26),
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
                              context.l10n.dailyTargets,
                              style: AppTextStyles
                                  .titleMedium
                                  .copyWith(
                                color:
                                AppColors.authText,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ),

                          const SizedBox(height: 16),

                          _PlanValueField(
                            icon: Icons
                                .local_fire_department_rounded,
                            label:
                            context.l10n.calories,
                            controller:
                            _caloriesController,
                            suffix: 'kcal',
                          ),

                          _PlanValueField(
                            icon: Icons
                                .fitness_center_rounded,
                            label:
                            context.l10n.protein,
                            controller:
                            _proteinController,
                            suffix: 'g',
                          ),

                          _PlanValueField(
                            icon: Icons.grain_rounded,
                            label: context
                                .l10n.carbohydrates,
                            controller:
                            _carbsController,
                            suffix: 'g',
                          ),

                          _PlanValueField(
                            icon: Icons.opacity_rounded,
                            label: context.l10n.fats,
                            controller:
                            _fatsController,
                            suffix: 'g',
                          ),

                          _PlanValueField(
                            icon: Icons
                                .local_drink_outlined,
                            label:
                            context.l10n.water,
                            controller:
                            _waterController,
                            suffix: 'L',
                            allowDecimal: true,
                            showBottomDivider: false,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    CustomButton(
                      text:
                      context.l10n.startMyJourney,
                      onPressed: _submit,
                      backgroundColor:
                      AppColors.authButtonGreen,
                      textColor: Colors.white,
                      height: 54,
                      width: screenWidth * 0.72,
                      fontSize: 19,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),

        Positioned(
          top: 0,
          child: IgnorePointer(
            child: ConfettiWidget(
              confettiController:
              _confettiController,
              blastDirectionality:
              BlastDirectionality.explosive,
              shouldLoop: false,
              emissionFrequency: 0.04,
              numberOfParticles: 22,
              maxBlastForce: 22,
              minBlastForce: 9,
              gravity: 0.18,
              colors: const [
                AppColors.authButtonGreen,
                AppColors.authText,
                AppColors.confettiLightGreen,
                AppColors.confettiGold,
                Colors.white,
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _PlanValueField extends StatelessWidget {
  final IconData icon;
  final String label;
  final TextEditingController controller;
  final String suffix;
  final bool allowDecimal;
  final bool showBottomDivider;

  const _PlanValueField({
    required this.icon,
    required this.label,
    required this.controller,
    required this.suffix,
    this.allowDecimal = false,
    this.showBottomDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.authButtonGreen
                    .withValues(
                  alpha: 0.15,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: AppColors.authButtonGreen,
                size: 20,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Text(
                label,
                style:
                AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.authText,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            SizedBox(
              width: 96,
              child: TextField(
                controller: controller,
                keyboardType:
                TextInputType.numberWithOptions(
                  decimal: allowDecimal,
                ),
                inputFormatters: allowDecimal
                    ? [
                  FilteringTextInputFormatter
                      .allow(
                    RegExp(
                      r'^\d*[.,]?\d{0,1}',
                    ),
                  ),
                ]
                    : [
                  FilteringTextInputFormatter
                      .digitsOnly,
                ],
                textAlign: TextAlign.end,
                style:
                AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.authText,
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                ),
                decoration: InputDecoration(
                  suffixText: suffix,
                  suffixStyle: AppTextStyles
                      .labelSmall
                      .copyWith(
                    color:
                    AppColors.authText.withValues(
                      alpha: 0.58,
                    ),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                  filled: true,
                  fillColor:
                  AppColors.onboardingBackground,
                  isDense: true,
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  border: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                    BorderRadius.circular(16),
                    borderSide:
                    const BorderSide(
                      color:
                      AppColors.authButtonGreen,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        if (showBottomDivider)
          Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
            ),
            child: Divider(
              height: 1,
              thickness: 1,
              color:
              AppColors.authText.withValues(
                alpha: 0.08,
              ),
            ),
          )
        else
          const SizedBox(height: 10),
      ],
    );
  }
}