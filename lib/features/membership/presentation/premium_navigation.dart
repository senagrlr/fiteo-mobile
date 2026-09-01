import 'package:flutter/material.dart';

import 'package:fiteo_myapp/app/router/app_routes.dart';

class PremiumNavigation {
  PremiumNavigation._();

  static Future<T?> openPaywall<T>(
      BuildContext context,
      ) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.premium,
    );
  }

  static Future<T?> openMembership<T>(
      BuildContext context,
      ) {
    return Navigator.of(context).pushNamed<T>(
      AppRoutes.premiumMembership,
    );
  }
}