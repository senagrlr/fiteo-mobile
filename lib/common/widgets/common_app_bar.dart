import 'package:flutter/material.dart';
import 'package:fiteo_myapp/app/theme/app_colors.dart';

class CommonAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBack;
  final Color backgroundColor;

  const CommonAppBar({
    super.key,
    this.showBack = true,
    this.backgroundColor = Colors.white
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      automaticallyImplyLeading: false,
      leading: showBack
          ? IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          size: 25,
        ),
        color: AppColors.authText,
        onPressed: () {
          Navigator.pop(context);
        },
      )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}