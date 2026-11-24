import 'package:flutter/material.dart';

import '../core/di/app_dependencies.dart';
import '../core/theme/app_colors.dart';
import '../features/issues/views/create_issue_screen.dart';
import '../features/issues/views/history_screen.dart';
import '../features/issues/views/issue_detail_screen.dart';
import '../features/issues/widgets/feed/issues_feed_view.dart';
import '../features/profile/views/profile_screen.dart';
import '../features/settings/views/settings_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_header_bar.dart';

/// Shell principal de navegação por abas do aplicativo (compositor de features).
class HomeScreen extends StatefulWidget {
  final String userName;
  final AppNavTab initialTab;

  const HomeScreen({
    super.key,
    this.userName = 'Usuário',
    this.initialTab = AppNavTab.home,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late AppNavTab _currentTab;
  String? _selectedIssueId;
  final TextEditingController _searchController = TextEditingController();
  final _viewModel = AppDependencies.instance.issueViewModel;

  @override
  void initState() {
    super.initState();
    _currentTab = widget.initialTab;
    _searchController.addListener(() {
      _viewModel.search(_searchController.text);
    });
  }

  @override
  void didUpdateWidget(HomeScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialTab != widget.initialTab) {
      _currentTab = widget.initialTab;
      _selectedIssueId = null;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _selectTab(AppNavTab tab) {
    setState(() {
      _selectedIssueId = null;
      _currentTab = tab;
    });
  }

  int _getTabIndex(AppNavTab tab) {
    return switch (tab) {
      AppNavTab.home => 0,
      AppNavTab.history => 1,
      AppNavTab.create => 2,
      AppNavTab.profile => 3,
      AppNavTab.settings => 4,
      AppNavTab.none => 0,
    };
  }

  @override
  Widget build(BuildContext context) {
    final canPop = _selectedIssueId == null && _currentTab == AppNavTab.home;
    final resolvedProfileName =
        widget.userName == 'Usuário' || widget.userName == 'Convidado'
            ? 'João Silva'
            : widget.userName;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        if (_selectedIssueId != null) {
          setState(() => _selectedIssueId = null);
        } else if (_currentTab != AppNavTab.home) {
          setState(() => _currentTab = AppNavTab.home);
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: const AppHeaderBar(),
        body: Stack(
          children: [
            if (_selectedIssueId != null)
              IssueDetailScreen(
                issueId: _selectedIssueId!,
                isEmbedded: true,
                onBack: () => setState(() => _selectedIssueId = null),
              )
            else
              IndexedStack(
                index: _getTabIndex(_currentTab),
                children: [
                  IssuesFeedView(
                    userName: widget.userName,
                    viewModel: _viewModel,
                    searchController: _searchController,
                    onOpenIssue: (id) => setState(() => _selectedIssueId = id),
                  ),
                  HistoryScreen(
                    isEmbedded: true,
                    onBackToHome: () => _selectTab(AppNavTab.home),
                    onOpenIssue: (id) => setState(() => _selectedIssueId = id),
                    onOpenCreateIssue: () => _selectTab(AppNavTab.create),
                  ),
                  CreateIssueScreen(
                    isEmbedded: true,
                    onBackToHome: () => _selectTab(AppNavTab.home),
                  ),
                  ProfileScreen(
                    initialName: resolvedProfileName,
                    isEmbedded: true,
                    onBackToHome: () => _selectTab(AppNavTab.home),
                  ),
                  SettingsScreen(
                    isEmbedded: true,
                    onBackToHome: () => _selectTab(AppNavTab.home),
                  ),
                ],
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab:
                    _selectedIssueId != null ? AppNavTab.none : _currentTab,
                onHomeTap: () => _selectTab(AppNavTab.home),
                onHistoryTap: () => _selectTab(AppNavTab.history),
                onPlusTap: () => _selectTab(AppNavTab.create),
                onProfileTap: () => _selectTab(AppNavTab.profile),
                onSettingsTap: () => _selectTab(AppNavTab.settings),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
