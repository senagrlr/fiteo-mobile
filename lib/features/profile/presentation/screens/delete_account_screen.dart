import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/delete_header.dart';
import 'package:fiteo_myapp/features/profile/utils/profile_messages.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  final passwordController = TextEditingController();
  final _profileRepository = ProfileRepository();

  bool isLoading = true;
  bool isDeleting = false;
  bool isPasswordUser = false;
  String? deleteError;

  @override
  void initState() {
    super.initState();
    _loadUserProvider();
  }

  Future<void> _loadUserProvider() async {
    final doc = await _profileRepository.getCurrentUserDoc();
    final data = doc.data();

    if (!mounted) return;

    setState(() {
      isPasswordUser = data?['authProvider'] == 'password';
      isLoading = false;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    final password = passwordController.text.trim();

    setState(() {
      deleteError = null;
    });

    if (isPasswordUser && password.isEmpty) {
      AppSnackbar.showError(context, ProfileMessages.currentPasswordRequired,
      );
      return;
    }

    setState(() {
      isDeleting = true;
    });

    try {
      await _profileRepository.deleteAccount(
        currentPassword: isPasswordUser ? password : null,
      );

      if (!mounted) return;

      AppSnackbar.showSuccess(
        context,
        ProfileMessages.accountDeleted,
      );

      await Future.delayed(const Duration(milliseconds: 700));

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.login,
            (route) => false,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        isDeleting = false;
      });

      if (e.code == 'wrong-password' || e.code == 'invalid-credential') {
        AppSnackbar.showError(context, ProfileMessages.currentPasswordIncorrect,
        );
      } else if (e.code == 'requires-recent-login') {
        AppSnackbar.showError(context, ProfileMessages.recentLoginRequired,
        );
      } else {
        AppSnackbar.showError(context, ProfileMessages.accountDeleteFailed,
        );
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isDeleting = false;
      });

      AppSnackbar.showError(context, ProfileMessages.accountDeleteFailed,
      );
    }
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

                      if (isPasswordUser) ...[
                        Container(
                          height: 52,
                          padding: const EdgeInsets.symmetric(horizontal: 22),
                          decoration: BoxDecoration(
                            color: AppColors.onboardingBackground,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: TextField(
                            controller: passwordController,
                            obscureText: true,
                            style: const TextStyle(
                              color: AppColors.homeBrown,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter your current password',
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
                      ] else ...[
                        const SizedBox(height: 40),
                      ],

                        Center(
                          child: CustomButton(
                            text: isDeleting ? 'Deleting...' : 'Delete My Account',
                            onPressed: isDeleting || isLoading ? null : _deleteAccount,
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