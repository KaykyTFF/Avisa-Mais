import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_bottom_nav_bar.dart';
import 'app_header_bar.dart';

class AppScaffold extends StatelessWidget {
  final Widget body;
  final PreferredSizeWidget? appBar;
  final bool showHeader;
  final AppNavTab? currentNavTab;
  final VoidCallback? onHomeTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback? onPlusTap;
  final VoidCallback? onProfileTap;
  final VoidCallback? onSettingsTap;
  final bool resizeToAvoidBottomInset;

  const AppScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.showHeader = true,
    this.currentNavTab,
    this.onHomeTap,
    this.onHistoryTap,
    this.onPlusTap,
    this.onProfileTap,
    this.onSettingsTap,
    this.resizeToAvoidBottomInset = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      resizeToAvoidBottomInset: resizeToAvoidBottomInset,
      appBar: appBar ?? (showHeader ? const AppHeaderBar() : null),
      body: Stack(
        fit: StackFit.expand,
        children: [
          body,
          if (currentNavTab != null)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab: currentNavTab!,
                onHomeTap: onHomeTap ?? () {},
                onHistoryTap: onHistoryTap,
                onPlusTap: onPlusTap ?? () {},
                onProfileTap: onProfileTap ?? () {},
                onSettingsTap: onSettingsTap,
              ),
            ),
        ],
      ),
    );
  }
}
