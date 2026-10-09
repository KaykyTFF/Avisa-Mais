import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../viewmodels/issue_viewmodel.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_header_bar.dart';
import '../widgets/issue_card.dart';
import 'create_issue_screen.dart';
import 'history_screen.dart';
import 'issue_detail_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

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
  final IssueViewModel _viewModel = IssueViewModel();

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

  void _openCreateIssueScreen() {
    setState(() {
      _selectedIssueId = null;
      _currentTab = AppNavTab.create;
    });
  }

  void _openIssueDetailScreen(String issueId) {
    setState(() {
      _selectedIssueId = issueId;
    });
  }

  int _getTabIndex(AppNavTab tab) {
    switch (tab) {
      case AppNavTab.home:
        return 0;
      case AppNavTab.history:
        return 1;
      case AppNavTab.create:
        return 2;
      case AppNavTab.profile:
        return 3;
      case AppNavTab.settings:
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool canPop = _selectedIssueId == null && _currentTab == AppNavTab.home;

    return PopScope(
      canPop: canPop,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          if (_selectedIssueId != null) {
            setState(() => _selectedIssueId = null);
          } else if (_currentTab != AppNavTab.home) {
            setState(() => _currentTab = AppNavTab.home);
          }
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
                onBack: () {
                  setState(() => _selectedIssueId = null);
                },
              )
            else
              IndexedStack(
                index: _getTabIndex(_currentTab),
                children: [
                  _buildHomeContent(),
                  HistoryScreen(
                    isEmbedded: true,
                    onBackToHome: () {
                      setState(() {
                        _selectedIssueId = null;
                        _currentTab = AppNavTab.home;
                      });
                    },
                    onOpenIssue: (id) {
                      setState(() => _selectedIssueId = id);
                    },
                    onOpenCreateIssue: _openCreateIssueScreen,
                  ),
                  CreateIssueScreen(
                    isEmbedded: true,
                    onBackToHome: () {
                      setState(() {
                        _selectedIssueId = null;
                        _currentTab = AppNavTab.home;
                      });
                    },
                  ),
                  ProfileScreen(
                    initialName: widget.userName == 'Usuário' || widget.userName == 'Convidado'
                        ? 'João Silva'
                        : widget.userName,
                    isEmbedded: true,
                    onBackToHome: () {
                      setState(() {
                        _selectedIssueId = null;
                        _currentTab = AppNavTab.home;
                      });
                    },
                  ),
                  SettingsScreen(
                    isEmbedded: true,
                    onBackToHome: () {
                      setState(() {
                        _selectedIssueId = null;
                        _currentTab = AppNavTab.home;
                      });
                    },
                  ),
                ],
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab: _selectedIssueId != null ? AppNavTab.none : _currentTab,
                onHomeTap: () {
                  setState(() {
                    _selectedIssueId = null;
                    _currentTab = AppNavTab.home;
                  });
                },
                onHistoryTap: () {
                  setState(() {
                    _selectedIssueId = null;
                    _currentTab = AppNavTab.history;
                  });
                },
                onPlusTap: _openCreateIssueScreen,
                onProfileTap: () {
                  setState(() {
                    _selectedIssueId = null;
                    _currentTab = AppNavTab.profile;
                  });
                },
                onSettingsTap: () {
                  setState(() {
                    _selectedIssueId = null;
                    _currentTab = AppNavTab.settings;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return ListenableBuilder(
      listenable: _viewModel,
      builder: (context, _) {
        final issues = _viewModel.issues;
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Olá, ${widget.userName}!',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w900,
                        color: AppColors.textDark,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'Bem-vindo de volta ao Avisa + IFPI.',
                      style: TextStyle(
                        fontSize: 14,
                        color: AppColors.textMuted,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 18),
                    _buildSearchBar(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            if (issues.isEmpty)
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 60),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.search_off_rounded,
                          size: 56,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'Nenhuma ocorrência encontrada',
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final issue = issues[index];
                      return IssueCard(
                        issue: issue,
                        onTap: () => _openIssueDetailScreen(issue.id),
                        onUpvote: () => _viewModel.toggleUpvote(issue.id),
                        onDownvote: () => _viewModel.toggleDownvote(issue.id),
                      );
                    },
                    childCount: issues.length,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Row(
        children: [
          const SizedBox(width: 18),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
              decoration: const InputDecoration(
                hintText: 'Buscar por setor ou problema...',
                hintStyle: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 13,
                ),
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.symmetric(vertical: 14),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.tune_rounded,
              color: AppColors.primaryYellow,
              size: 22,
            ),
            splashRadius: 20,
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Filtro por setor ativado.'),
                  duration: Duration(milliseconds: 1500),
                ),
              );
            },
          ),
          Container(
            height: 22,
            width: 1,
            color: Colors.grey.shade300,
          ),
          IconButton(
            icon: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryYellow,
              size: 26,
            ),
            splashRadius: 20,
            onPressed: () {
              _viewModel.search(_searchController.text);
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
