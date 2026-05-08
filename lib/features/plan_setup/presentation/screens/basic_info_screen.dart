import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
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

  final ageController = TextEditingController();
  final heightController = TextEditingController();
  final weightController = TextEditingController();

  @override
  void dispose() {
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

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

              Column(
                children: [
                  const SetupProgressIndicator(
                    currentStep: 2,
                    totalSteps: 6,
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
                ],
              ),

              const SizedBox(height: 60),

              const Text(
                'Tell us about yourself',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: AppColors.authText,
                ),
              ),

              const SizedBox(height: 36),

              CustomTextField(
                hintText: 'Age',
                fillColor: Colors.white,
                controller: ageController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Height (cm)',
                fillColor: Colors.white,
                controller: heightController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              CustomTextField(
                hintText: 'Weight (kg)',
                fillColor: Colors.white,
                controller: weightController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<String>(
                value: selectedGender,
                dropdownColor: Colors.white,
                icon: const Icon(
                  Icons.keyboard_arrow_down,
                  color: AppColors.authText,
                ),
                decoration: InputDecoration(
                  labelText: 'Gender',
                  floatingLabelBehavior: FloatingLabelBehavior.never,

                  labelStyle: const TextStyle(
                    color: AppColors.authText,
                    fontSize: 18,
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

                style: const TextStyle(
                  color: AppColors.authText,
                  fontSize: 18,
                ),

                items: const [
                  DropdownMenuItem(
                    value: 'Female',
                    child: Text(
                      'Female',
                      style: TextStyle(
                        color: AppColors.authText,
                      ),
                    ),
                  ),

                  DropdownMenuItem(
                    value: 'Male',
                    child: Text(
                      'Male',
                      style: TextStyle(
                        color: AppColors.authText,
                      ),
                    ),
                  ),
                ],

                onChanged: (value) {
                  setState(() {
                    selectedGender = value;
                  });
                },
              ),

              const SizedBox(height: 150),

              CustomButton(
                text: 'Continue',
                onPressed: selectedGender == null
                    ? null
                    : () {
                  widget.onContinue(
                    age: int.tryParse(ageController.text) ?? 0,
                    height: int.tryParse(heightController.text) ?? 0,
                    weight: int.tryParse(weightController.text) ?? 0,
                    gender: selectedGender!,
                  );
                },
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