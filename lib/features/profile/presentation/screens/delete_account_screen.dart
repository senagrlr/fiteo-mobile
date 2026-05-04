import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/delete_header.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final emailController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            Column(
              children: [
                const DeleteHeader(),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.08),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 44),

                        const Text(
                          'Deleting your account will permanently remove your profile and personal data. This action cannot be undone.',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: AppColors.homeBrown,
                            fontSize: 15,
                            height: 1.45,
                            fontWeight: FontWeight.w500,
                          ),
                        ),

                        const SizedBox(height: 36),

                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          decoration: BoxDecoration(
                            color: AppColors.onboardingBackground,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: TextField(
                            controller: emailController,
                            style: const TextStyle(
                              color: AppColors.homeBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter your email to continue',
                              hintStyle: TextStyle(
                                color: AppColors.homeBrown,
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),

                        const SizedBox(height: 40),

                        Center(
                          child: CustomButton(
                            text: 'Delete My Account',
                            onPressed: () {},
                            backgroundColor: AppColors.authButtonGreen,
                            textColor: Colors.white,
                            height: 54,
                            width: screenWidth * 0.68,
                            fontSize: 18,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Positioned(
              top: 50,
              left: 20,
              child: GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Icon(
                  Icons.arrow_back_ios_new,
                  color: AppColors.homeBrown,
                  size: 26,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}