import 'dart:async';
import 'package:flutter/material.dart';

import 'package:fiteo_myapp/features/membership/data/membership_repository.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/common/extensions/localization_extension.dart';
import 'package:fiteo_myapp/common/widgets/system_navigation_bar.dart';

import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/weekly_views_card.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_header_loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() =>
      _ProfileScreenState();
}

class _ProfileScreenState
    extends State<ProfileScreen> {
  final _profileRepository =
  ProfileRepository();

  final _membershipRepository =
  MembershipRepository();

  StreamSubscription<bool>? _membershipSubscription;

  String username = '';
  String email = '';
  String? mascot;

  bool isLoading = true;
  bool isPremium = false;

  @override
  void initState() {
    super.initState();

    loadUser();
    _watchMembership();
  }

  void _watchMembership() {
    _membershipSubscription =
        _membershipRepository
            .watchIsPremium()
            .listen((value) {
          if (!mounted) return;

          setState(() {
            isPremium = value;
          });
        });
  }

  @override
  void dispose() {
    _membershipSubscription?.cancel();
    super.dispose();
  }

  Future<void> loadUser() async {
    try {
      final doc =
      await _profileRepository
          .getCurrentUserDoc();

      final data = doc.data();

      if (!mounted) return;

      setState(() {
        username =
            data?['username'] ?? '';

        email =
            data?['email'] ?? '';

        mascot =
        data?['mascot'];

        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  // ============================================================
  // MEMBERSHIP SCREEN
  // ============================================================

  void _openMembershipScreen() {
    // PREMIUM kullanıcı
    if (isPremium) {
      Navigator.pushNamed(
        context,
        AppRoutes.premiumMembership,
      );

      return;
    }

    // FREE kullanıcı
    Navigator.pushNamed(
      context,
      AppRoutes.premium,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SystemNavigationBar(
      color: Colors.white,
      child: Scaffold(
        backgroundColor:
        Colors.white,
        body: SingleChildScrollView(
          padding:
          const EdgeInsets.only(
            bottom: 50,
          ),
          child: Column(
            children: [

              isLoading
              ? const ProfileHeaderLoading()
              : ProfileHeader(
          username: username,
          email: email,
          mascot: mascot,
          isPremium: isPremium,
          onMembershipTap: _openMembershipScreen,
        ),

              const SizedBox(
                height: 30,
              ),

              // =================================================
              // WEEKLY VIEWS
              // =================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 22,
                ),
                child:
                WeeklyViewsCard(
                  onArrowTap: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.progress,
                    );
                  },
                ),
              ),

              const SizedBox(
                height: 50,
              ),

              // =================================================
              // MENU
              // =================================================

              Padding(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 42,
                ),
                child: Column(
                  children: [
                    // =============================================
                    // EDIT PROFILE
                    // =============================================

                    ProfileMenuItem(
                      icon:
                      Icons.edit,

                      title:
                      context
                          .l10n
                          .editProfile,

                      onTap: () async {
                        final result =
                        await Navigator
                            .pushNamed(
                          context,
                          AppRoutes
                              .editProfile,
                        );

                        if (result ==
                            true) {
                          loadUser();
                        }
                      },
                    ),

                    // =============================================
                    // SAVED RECIPES
                    // =============================================

                    ProfileMenuItem(
                      icon:
                      Icons
                          .favorite_border_rounded,

                      title:
                      context
                          .l10n
                          .savedRecipes,

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .savedRecipes,
                        );
                      },
                    ),

                    // =============================================
                    // PLAN TRACKING
                    // =============================================

                    ProfileMenuItem(
                      icon:
                      Icons
                          .timeline_rounded,

                      title:
                      context
                          .l10n
                          .planTracking,

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .planTracking,
                        );
                      },
                    ),

                    // =============================================
                    // GOALS & PREFERENCES
                    // =============================================

                    ProfileMenuItem(
                      icon:
                      Icons
                          .track_changes,

                      title:
                      context
                          .l10n
                          .goalsPreferences,

                      onTap: () async {
                        final result =
                        await Navigator
                            .pushNamed(
                          context,
                          AppRoutes
                              .goalsPreferences,
                        );

                        if (result ==
                            true) {
                          loadUser();
                        }
                      },
                    ),

                    // =============================================
                    // LOG OUT
                    // =============================================

                    ProfileMenuItem(
                      icon:
                      Icons.logout,

                      title:
                      context
                          .l10n
                          .logOut,

                      onTap: () async {
                        await _profileRepository
                            .logout();

                        if (!context
                            .mounted) {
                          return;
                        }

                        Navigator
                            .pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.login,
                              (route) =>
                          false,
                        );
                      },
                    ),

                    // =============================================
                    // DELETE ACCOUNT
                    // =============================================

                    ProfileMenuItem(
                      icon:
                      Icons
                          .delete_outline,

                      title:
                      context
                          .l10n
                          .deleteMyAccount,

                      color:
                      AppColors.red,

                      onTap: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes
                              .deleteAccount,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}