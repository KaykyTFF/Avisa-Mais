import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_logo.dart';

class AppHeaderBar extends StatelessWidget implements PreferredSizeWidget {
  final double logoSize;

  const AppHeaderBar({
    super.key,
    this.logoSize = 48,
  });

  @override
  Size get preferredSize => const Size.fromHeight(66);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.primaryYellow, width: 1.5),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: AppLogo(size: logoSize),
          ),
        ),
      ),
    );
  }
}
