import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fiteo_myapp/app/theme/app_theme.dart';

import 'package:fiteo_myapp/app/router/app_router.dart';
import 'package:fiteo_myapp/app/router/app_routes.dart';

class FiteoApp extends StatelessWidget {
  const FiteoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarDividerColor: Colors.transparent,
      ),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Fiteo',
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutes.authGate,
        routes: AppRouter.routes,
      ),
    );
  }
}