import 'package:flutter/material.dart';
import 'package:fiteo_myapp/features/profile/data/profile_repository.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_header.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/profile_menu_item.dart';
import 'package:fiteo_myapp/features/profile/presentation/widgets/weekly_views_card.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _profileRepository = ProfileRepository();

  String username = '';
  String email = '';
  String? mascot;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadUser();
  }

  Future<void> loadUser() async {
    try {
      final doc = await _profileRepository.getCurrentUserDoc();
      final data = doc.data();

      if (!mounted) return;

      setState(() {
        username = data?['username'] ?? '';
        email = data?['email'] ?? '';
        mascot = data?['mascot'];
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 50),
        child: Column(
          children: [
            ProfileHeader(
              username: isLoading ? '...' : username,
              email: isLoading ? '...' : email,
              mascot: isLoading ? null : mascot,
            ),

            const SizedBox(height: 14),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22),
              child: WeeklyViewsCard(),
            ),

            const SizedBox(height: 50),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 42),
              child: Column(
                children: [
                  ProfileMenuItem(
                    icon: Icons.edit,
                    title: 'Edit Profile',
                    onTap: () async {
                      final result = await Navigator.pushNamed(
                        context,
                        AppRoutes.editProfile,
                      );

                      if (result == true) {
                        loadUser();
                      }
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.favorite_border_rounded,
                    title: 'Saved Recipes',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.savedRecipes,
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.track_changes,
                    title: 'Goals & Preferences',
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.goalsPreferences,
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Log out',
                    onTap: () async {
                      await _profileRepository.logout();

                      if (!context.mounted) return;

                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        AppRoutes.login,
                            (route) => false,
                      );
                    },
                  ),
                  ProfileMenuItem(
                    icon: Icons.delete_outline,
                    title: 'Delete my account',
                    color: AppColors.red,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.deleteAccount,
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}