import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthGateScreen extends StatelessWidget {
  const AuthGateScreen({super.key});

  Future<String> _getLoggedInTargetRoute(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .get();

    final isOnboardingCompleted =
        doc.data()?['isOnboardingCompleted'] == true;

    if (isOnboardingCompleted) {
      return AppRoutes.main;
    }

    return AppRoutes.planSetup;
  }

  Future<String> _getLoggedOutTargetRoute() async {
    final prefs = await SharedPreferences.getInstance();

    final hasSeenOnboarding =
        prefs.getBool('hasSeenOnboarding') ?? false;

    if (hasSeenOnboarding) {
      return AppRoutes.login;
    }

    await prefs.setBool('hasSeenOnboarding', true);

    return AppRoutes.onboarding;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, authSnapshot) {
        if (authSnapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            backgroundColor: Colors.white,
            body: Center(child: CircularProgressIndicator()),
          );
        }

        final user = authSnapshot.data;

        if (user != null) {
          return FutureBuilder<String>(
            future: _getLoggedInTargetRoute(user),
            builder: (context, routeSnapshot) {
              if (routeSnapshot.connectionState ==
                  ConnectionState.waiting) {
                return const Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              final route = routeSnapshot.data ?? AppRoutes.main;

              Future.microtask(() {
                Navigator.pushReplacementNamed(context, route);
              });

              return const Scaffold(
                backgroundColor: Colors.white,
                body: SizedBox.shrink(),
              );
            },
          );
        }

        return FutureBuilder<String>(
          future: _getLoggedOutTargetRoute(),
          builder: (context, routeSnapshot) {
            if (routeSnapshot.connectionState ==
                ConnectionState.waiting) {
              return const Scaffold(
                backgroundColor: Colors.white,
                body: Center(child: CircularProgressIndicator()),
              );
            }

            final route = routeSnapshot.data ?? AppRoutes.login;

            Future.microtask(() {
              Navigator.pushReplacementNamed(context, route);
            });

            return const Scaffold(
              backgroundColor: Colors.white,
              body: SizedBox.shrink(),
            );
          },
        );
      },
    );
  }
}