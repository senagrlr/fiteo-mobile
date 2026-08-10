import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/features/plan_setup/presentation/widgets/setup_progress_indicator.dart';

class BasicInfoScreen extends StatefulWidget {
  final void Function({
  required int age,
  required int height,
  required int weight,
  required String gender,
  }) onContinue;

  final VoidCallback onBack;

  const BasicInfoScreen({
    super.key,
    required this.onContinue,
    required this.onBack,
  });

  @override
  State<BasicInfoScreen> createState() => _BasicInfoScreenState();
}

class _BasicInfoScreenState extends State<BasicInfoScreen> {
  String? selectedGender;

  String selectedHeightUnit = 'cm';
  String selectedWeightUnit = 'kg';

  final ageController = TextEditingController();

  final heightCmController = TextEditingController();
  final heightFeetController = TextEditingController();
  final heightInchController = TextEditingController();

  final weightController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();

    heightCmController.dispose();
    heightFeetController.dispose();
    heightInchController.dispose();

    weightController.dispose();

    super.dispose();
  }

  int _heightInCm() {
    if (selectedHeightUnit == 'cm') {
      return int.tryParse(
        heightCmController.text.trim(),
      ) ??
          0;
    }

    final feet = int.tryParse(
      heightFeetController.text.trim(),
    ) ??
        0;

    final inches = int.tryParse(
      heightInchController.text.trim(),
    ) ??
        0;

    final totalInches = (feet * 12) + inches;

    return (totalInches * 2.54).round();
  }

  int _weightInKg() {
    final value = double.tryParse(
      weightController.text.trim(),
    ) ??
        0;

    if (selectedWeightUnit == 'kg') {
      return value.round();
    }

    return (value * 0.45359237).round();
  }

  void _continue() {
    final age = int.tryParse(
      ageController.text.trim(),
    ) ??
        0;

    final height = _heightInCm();
    final weight = _weightInKg();

    if (selectedGender == null ||
        age <= 0 ||
        height <= 0 ||
        weight <= 0) {
      return;
    }

    widget.onContinue(
      age: age,
      height: height,
      weight: weight,
      gender: selectedGender!,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    final genderOptions = [
      (
      value: 'Female',
      label: context.l10n.female,
      ),
      (
      value: 'Male',
      label: context.l10n.male,
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: AppColors.onboardingBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: screenWidth * 0.10,
            right: screenWidth * 0.10,
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Column(
            children: [
              const SizedBox(height: 18),

              const SetupProgressIndicator(
                currentStep: 2,
                totalSteps: 7,
              ),

              const SizedBox(height: 25),

              Align(
                alignment: Alignment.centerLeft,
                child: GestureDetector(
                  onTap: widget.onBack,
                  child: const Icon(
                    Icons.arrow_back_ios_new,
                    size: 24,
                    color: AppColors.authText,
                  ),
                ),
              ),

              const SizedBox(height: 60),

              Text(
                context.l10n.planSetupAboutYourselfTitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingLarge.copyWith(
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 36),

              CustomTextField(
                hintText: context.l10n.age,
                fillColor: Colors.white,
                controller: ageController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              if (selectedHeightUnit == 'cm')
                _ValueWithUnitField(
                  controller: heightCmController,
                  hintText: context.l10n.height,
                  selectedUnit: selectedHeightUnit,
                  units: const ['cm', 'ft/in'],
                  onUnitChanged: (value) {
                    setState(() {
                      selectedHeightUnit = value;
                    });
                  },
                )
              else
                _FeetInchesField(
                  feetController: heightFeetController,
                  inchController: heightInchController,
                  selectedUnit: selectedHeightUnit,
                  onUnitChanged: (value) {
                    setState(() {
                      selectedHeightUnit = value;
                    });
                  },
                ),

              const SizedBox(height: 16),

              _ValueWithUnitField(
                controller: weightController,
                hintText: context.l10n.weight,
                selectedUnit: selectedWeightUnit,
                units: const ['kg', 'lb'],
                allowDecimal: true,
                onUnitChanged: (value) {
                  setState(() {
                    selectedWeightUnit = value;
                  });
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                initialValue: selectedGender,
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.authText,
                ),
                decoration: InputDecoration(
                  labelText: context.l10n.gender,
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  labelStyle: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.authText,
                    fontWeight: FontWeight.w400,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 14,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.authText,
                ),
                items: genderOptions.map((gender) {
                  return DropdownMenuItem<String>(
                    value: gender.value,
                    child: Text(
                      gender.label,
                      style: AppTextStyles.bodyLarge.copyWith(
                        color: AppColors.authText,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 150),

              CustomButton(
                text: context.l10n.continueText,
                onPressed:
                selectedGender == null ? null : _continue,
                backgroundColor: AppColors.authButtonGreen,
                textColor: Colors.white,
                height: 54,
                width: screenWidth * 0.72,
                fontSize: 22,
              ),

              const SizedBox(height: 36),
            ],
          ),
        ),
      ),
    );
  }
}

class _ValueWithUnitField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final String selectedUnit;
  final List<String> units;
  final ValueChanged<String> onUnitChanged;
  final bool allowDecimal;

  const _ValueWithUnitField({
    required this.controller,
    required this.hintText,
    required this.selectedUnit,
    required this.units,
    required this.onUnitChanged,
    this.allowDecimal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.numberWithOptions(
                decimal: allowDecimal,
              ),
              inputFormatters: allowDecimal
                  ? [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d*\.?\d{0,2}'),
                ),
              ]
                  : [
                FilteringTextInputFormatter.digitsOnly,
              ],
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.authText,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.authText,
                  fontWeight: FontWeight.w400,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 16,
                ),
              ),
            ),
          ),

          Container(
            width: 1,
            height: 28,
            color: AppColors.onboardingBackground,
          ),

          SizedBox(
            width: 88,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedUnit,
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.authText,
                ),
                padding: const EdgeInsets.only(
                  left: 14,
                  right: 10,
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.authText,
                  fontWeight: FontWeight.w600,
                ),
                items: units.map((unit) {
                  return DropdownMenuItem<String>(
                    value: unit,
                    child: Text(unit),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    onUnitChanged(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeetInchesField extends StatelessWidget {
  final TextEditingController feetController;
  final TextEditingController inchController;
  final String selectedUnit;
  final ValueChanged<String> onUnitChanged;

  const _FeetInchesField({
    required this.feetController,
    required this.inchController,
    required this.selectedUnit,
    required this.onUnitChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: feetController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.authText,
              ),
              decoration: InputDecoration(
                hintText: 'ft',
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.authText,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          Container(
            width: 1,
            height: 28,
            color: AppColors.onboardingBackground,
          ),

          Expanded(
            child: TextField(
              controller: inchController,
              keyboardType: TextInputType.number,
              inputFormatters: [
                FilteringTextInputFormatter.digitsOnly,
              ],
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge.copyWith(
                color: AppColors.authText,
              ),
              decoration: InputDecoration(
                hintText: 'in',
                hintStyle: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.authText,
                ),
                border: InputBorder.none,
              ),
            ),
          ),

          Container(
            width: 1,
            height: 28,
            color: AppColors.onboardingBackground,
          ),

          SizedBox(
            width: 88,
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedUnit,
                isExpanded: true,
                dropdownColor: Colors.white,
                borderRadius: BorderRadius.circular(20),
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.authText,
                ),
                padding: const EdgeInsets.only(
                  left: 10,
                  right: 8,
                ),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.authText,
                  fontWeight: FontWeight.w600,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'cm',
                    child: Text('cm'),
                  ),
                  DropdownMenuItem(
                    value: 'ft/in',
                    child: Text('ft/in'),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) {
                    onUnitChanged(value);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}