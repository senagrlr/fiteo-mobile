import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SystemNavigationBar extends StatelessWidget {
  final Widget child;
  final Color color;
  final Brightness iconBrightness;

  const SystemNavigationBar({
    super.key,
    required this.child,
    required this.color,
    this.iconBrightness = Brightness.dark,
  });

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        systemNavigationBarColor: color,
        systemNavigationBarIconBrightness: iconBrightness,
        systemNavigationBarDividerColor: color,
        systemNavigationBarContrastEnforced: false,
      ),
      child: child,
    );
  }
}