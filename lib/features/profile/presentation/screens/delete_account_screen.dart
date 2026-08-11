import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/delete_header.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  @override
  State<DeleteAccountScreen> createState() =>
      _DeleteAccountScreenState();
}

class _DeleteAccountScreenState
    extends State<DeleteAccountScreen> {
  final passwordController = TextEditingController();
  final _profileRepository = ProfileRepository();

  bool isLoading = true;
  bool isDeleting = false;
  bool isPasswordUser = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _loadUserProvider();
  }

  Future<void> _loadUserProvider() async {
    final doc =
    await _profileRepository.getCurrentUserDoc();

    final data = doc.data();

    if (!mounted) return;

    setState(() {
      isPasswordUser =
          data?['authProvider'] == 'password';

      isLoading = false;
    });
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  Future<void> _deleteAccount() async {
    final password =
    passwordController.text.trim();

    if (isPasswordUser && password.isEmpty) {
      AppSnackbar.showError(
        context,
        context.l10n.currentPasswordRequired,
      );

      return;
    }

    setState(() {
      isDeleting = true;
    });

    try {
      await _profileRepository.deleteAccount(
        currentPassword:
        isPasswordUser ? password : null,
      );

      if (!mounted) return;

      AppSnackbar.showSuccess(
        context,
        context.l10n.accountDeleted,
      );

      await Future.delayed(
        const Duration(milliseconds: 700),
      );

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

      if (e.code == 'wrong-password' ||
          e.code == 'invalid-credential') {
        AppSnackbar.showError(
          context,
          context.l10n.currentPasswordIncorrect,
        );
      } else if (e.code ==
          'requires-recent-login') {
        AppSnackbar.showError(
          context,
          context.l10n.recentLoginRequired,
        );
      } else {
        AppSnackbar.showError(
          context,
          context.l10n.accountDeleteFailed,
        );
      }
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isDeleting = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.accountDeleteFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth =
        MediaQuery.of(context).size.width;

    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.homeBrown,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            context.l10n.deleteMyAccount,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeBrown,
              fontWeight: FontWeight.w800,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.09,
              18,
              screenWidth * 0.09,
              40,
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                const DeleteHeader(),

                const SizedBox(height: 24),

                Text(
                  context.l10n.deleteAccountDescription,
                  textAlign: TextAlign.left,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.homeBrown,
                    fontSize: 15,
                    height: 1.45,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const SizedBox(height: 24),

                if (isPasswordUser)
                  Container(
                    height: 52,
                    padding: const EdgeInsets.only(
                      left: 22,
                    ),
                    decoration: BoxDecoration(
                      color:
                      AppColors.onboardingBackground,
                      borderRadius:
                      BorderRadius.circular(28),
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: obscurePassword,
                      textAlignVertical:
                      TextAlignVertical.center,
                      style:
                      AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.homeBrown,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText:
                        context.l10n.enterCurrentPassword,
                        hintStyle:
                        AppTextStyles.bodySmall.copyWith(
                          color:
                          AppColors.homeSecondaryValue,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        border: InputBorder.none,
                        contentPadding:
                        const EdgeInsets.symmetric(
                          vertical: 15,
                        ),
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              obscurePassword =
                              !obscurePassword;
                            });
                          },
                          icon: Icon(
                            obscurePassword
                                ? Icons
                                .visibility_off_outlined
                                : Icons
                                .visibility_outlined,
                            color: AppColors.homeBrown,
                            size: 21,
                          ),
                        ),
                      ),
                    ),
                  ),

                const Spacer(),

                Center(
                  child: CustomButton(
                    text: isDeleting
                        ? context.l10n.deleting
                        : context.l10n.confirm,
                    onPressed:
                    isDeleting || isLoading
                        ? null
                        : _deleteAccount,
                    backgroundColor:
                    AppColors.authButtonGreen,
                    textColor: Colors.white,
                    height: 54,
                    width: screenWidth * 0.52,
                    fontSize: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}