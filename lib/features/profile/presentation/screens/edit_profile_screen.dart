import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/theme/app_text_styles.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/utils/app_snackbar.dart';
import 'package:fiteo_myapp/common/widgets/custom_button.dart';
import 'package:fiteo_myapp/common/widgets/custom_text_field.dart';
import 'package:fiteo_myapp/common/widgets/field_error_text.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';
import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final usernameController = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final ProfileRepository _profileRepository =
  ProfileRepository();

  bool isLoading = true;
  bool isSaving = false;
  bool isPasswordUser = false;

  String? selectedMascot;
  String? passwordError;
  String? currentPasswordError;
  String? usernameError;

  final List<String> mascots = const [
    'assets/mascots/mascot_1.png',
    'assets/mascots/mascot_2.png',
    'assets/mascots/mascot_3.png',
    'assets/mascots/mascot_4.png',
  ];

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final doc =
    await _profileRepository.getCurrentUserDoc();

    final data = doc.data();

    final provider = data?['authProvider'] ?? '';

    usernameController.text =
        data?['username'] ?? '';

    selectedMascot = data?['mascot'];

    isPasswordUser = provider == 'password';

    if (!mounted) return;

    setState(() {
      isLoading = false;
    });
  }

  bool get isFormValid {
    final username =
    usernameController.text.trim();

    if (username.isEmpty) {
      return false;
    }

    if (!isPasswordUser) {
      return true;
    }

    final currentPassword =
    currentPasswordController.text.trim();

    final newPassword =
    newPasswordController.text.trim();

    final confirmPassword =
    confirmPasswordController.text.trim();

    final passwordFieldsEmpty =
        currentPassword.isEmpty &&
            newPassword.isEmpty &&
            confirmPassword.isEmpty;

    if (passwordFieldsEmpty) {
      return true;
    }

    return currentPassword.isNotEmpty &&
        newPassword.length >= 8 &&
        confirmPassword == newPassword;
  }

  void _showMascotSelector() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      builder: (bottomSheetContext) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.35,
          minChildSize: 0.25,
          maxChildSize: 0.5,
          builder: (
              context,
              scrollController,
              ) {
            return Padding(
              padding: const EdgeInsets.fromLTRB(
                24,
                20,
                24,
                34,
              ),
              child: Column(
                children: [
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color:
                      AppColors.bottomSheetHandle,
                      borderRadius:
                      BorderRadius.circular(10),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Text(
                    context.l10n.chooseYourMascot,
                    style: AppTextStyles.headingMedium
                        .copyWith(
                      color: AppColors.homeBrown,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 20),

                  Expanded(
                    child: ListView(
                      controller: scrollController,
                      children: [
                        Wrap(
                          alignment:
                          WrapAlignment.spaceBetween,
                          runSpacing: 18,
                          children: List.generate(
                            mascots.length,
                                (index) {
                              final mascot =
                              mascots[index];

                              final isSelected =
                                  selectedMascot ==
                                      mascot;

                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedMascot =
                                        mascot;
                                  });

                                  Navigator.pop(
                                    bottomSheetContext,
                                  );
                                },
                                child:
                                AnimatedContainer(
                                  duration:
                                  const Duration(
                                    milliseconds: 200,
                                  ),
                                  width: 88,
                                  height: 88,
                                  padding:
                                  const EdgeInsets
                                      .all(6),
                                  decoration:
                                  BoxDecoration(
                                    color: AppColors
                                        .onboardingBackground,
                                    shape:
                                    BoxShape.circle,
                                    border:
                                    Border.all(
                                      color: isSelected
                                          ? AppColors
                                          .calendarCompleted
                                          : Colors
                                          .transparent,
                                      width: 3,
                                    ),
                                  ),
                                  child: ClipOval(
                                    child:
                                    Image.asset(
                                      mascot,
                                      fit:
                                      BoxFit.cover,
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _validateAndSave() async {
    final username =
    usernameController.text.trim();

    final currentPassword =
    currentPasswordController.text.trim();

    final newPassword =
    newPasswordController.text.trim();

    final confirmPassword =
    confirmPasswordController.text.trim();

    setState(() {
      passwordError = null;
      currentPasswordError = null;
      usernameError = null;
    });

    if (username.isEmpty) {
      setState(() {
        usernameError =
            context.l10n.usernameRequired;
      });

      return;
    }

    final wantsPasswordChange =
        currentPassword.isNotEmpty ||
            newPassword.isNotEmpty ||
            confirmPassword.isNotEmpty;

    if (isPasswordUser && wantsPasswordChange) {
      if (currentPassword.isEmpty) {
        setState(() {
          currentPasswordError =
              context.l10n.currentPasswordRequired;
        });

        return;
      }

      if (newPassword.length < 8) {
        setState(() {
          passwordError =
              context.l10n.passwordMinLength;
        });

        return;
      }

      if (newPassword != confirmPassword) {
        setState(() {
          passwordError =
              context.l10n.passwordsDoNotMatch;
        });

        return;
      }
    }

    setState(() {
      isSaving = true;
    });

    try {
      await _profileRepository.updateProfileInfo(
        username: username,
        mascotPath: selectedMascot,
      );

      if (isPasswordUser &&
          wantsPasswordChange) {
        await _profileRepository.changePassword(
          currentPassword: currentPassword,
          newPassword: newPassword,
        );
      }

      if (!mounted) return;

      AppSnackbar.showSuccess(
        context,
        context.l10n.profileUpdated,
      );

      Navigator.pop(
        context,
        true,
      );
    } on FirebaseAuthException catch (e) {
      if (!mounted) return;

      setState(() {
        if (e.code == 'wrong-password' ||
            e.code == 'invalid-credential') {
          currentPasswordError =
              context.l10n.currentPasswordIncorrect;
        } else {
          passwordError =
              context.l10n.passwordUpdateFailed;
        }

        isSaving = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        isSaving = false;
      });

      AppSnackbar.showError(
        context,
        context.l10n.profileUpdateFailed,
      );
    }
  }

  @override
  void dispose() {
    usernameController.dispose();
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();

    super.dispose();
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
            context.l10n.editProfile,
            style: AppTextStyles.titleMedium.copyWith(
              color: AppColors.homeBrown,
              fontSize: 18,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: true,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(
              screenWidth * 0.10,
              20,
              screenWidth * 0.10,
              40,
            ),
            child: Column(
              children: [
                GestureDetector(
                  onTap: _showMascotSelector,
                  child: Stack(
                    children: [
                      Container(
                        width: 92,
                        height: 92,
                        decoration:
                        const BoxDecoration(
                          color: AppColors
                              .onboardingBackground,
                          shape: BoxShape.circle,
                        ),
                        alignment:
                        Alignment.center,
                        child: selectedMascot ==
                            null
                            ? Text(
                          usernameController
                              .text
                              .trim()
                              .isNotEmpty
                              ? usernameController
                              .text
                              .trim()[0]
                              .toUpperCase()
                              : 'U',
                          style: AppTextStyles
                              .displayLarge
                              .copyWith(
                            color: AppColors
                                .homeBrown,
                            fontSize: 40,
                            fontWeight:
                            FontWeight.w800,
                          ),
                        )
                            : ClipOval(
                          child: Image.asset(
                            selectedMascot!,
                            width: 92,
                            height: 92,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),

                      Positioned(
                        right: 0,
                        bottom: 4,
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration:
                          const BoxDecoration(
                            color: AppColors
                                .calendarCompleted,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Colors.white,
                            size: 17,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 34),

                CustomTextField(
                  hintText:
                  context.l10n.username,
                  controller:
                  usernameController,
                  onChanged: (_) {
                    setState(() {
                      usernameError = null;
                    });
                  },
                  fillColor:
                  AppColors.onboardingBackground,
                ),

                if (usernameError != null)
                  FieldErrorText(
                    message: usernameError!,
                  ),

                if (isPasswordUser) ...[
                  const SizedBox(height: 40),

                  Align(
                    alignment:
                    Alignment.centerLeft,
                    child: Text(
                      context.l10n.changePassword,
                      style: AppTextStyles
                          .headingSmall
                          .copyWith(
                        color:
                        AppColors.homeBrown,
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  CustomTextField(
                    hintText: context
                        .l10n.currentPassword,
                    controller:
                    currentPasswordController,
                    onChanged: (_) {
                      setState(() {
                        currentPasswordError =
                        null;
                      });
                    },
                    isPassword: true,
                    showVisibilityToggle: false,
                    fillColor:
                    AppColors.onboardingBackground,
                  ),

                  if (currentPasswordError !=
                      null)
                    FieldErrorText(
                      message:
                      currentPasswordError!,
                    ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    hintText:
                    context.l10n.newPassword,
                    controller:
                    newPasswordController,
                    onChanged: (value) {
                      if (value.trim().length >=
                          8 &&
                          passwordError ==
                              context.l10n
                                  .passwordMinLength) {
                        setState(() {
                          passwordError = null;
                        });
                      } else {
                        setState(() {});
                      }
                    },
                    isPassword: true,
                    fillColor:
                    AppColors.onboardingBackground,
                  ),

                  const SizedBox(height: 16),

                  CustomTextField(
                    hintText: context
                        .l10n.confirmNewPassword,
                    controller:
                    confirmPasswordController,
                    onChanged: (_) {
                      setState(() {});
                    },
                    isPassword: true,
                    fillColor:
                    AppColors.onboardingBackground,
                  ),
                ],

                if (passwordError != null)
                  FieldErrorText(
                    message: passwordError!,
                  ),

                const SizedBox(height: 36),

                CustomButton(
                  text:
                  context.l10n.saveChanges,
                  onPressed: isSaving
                      ? null
                      : _validateAndSave,
                  backgroundColor: isSaving
                      ? AppColors.authButtonGreen
                      .withValues(
                    alpha: 0.45,
                  )
                      : AppColors.authButtonGreen,
                  textColor: Colors.white,
                  height: 54,
                  width: screenWidth * 0.72,
                  fontSize: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}