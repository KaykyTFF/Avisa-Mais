import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/issue_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../../widgets/app_header_bar.dart';
import '../widgets/history/history_empty_state.dart';
import '../widgets/history/history_filters.dart';
import '../widgets/history/history_issue_card.dart';
import '../widgets/history/history_metrics_row.dart';

class HistoryScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onBackToHome;
  final ValueChanged<String>? onOpenIssue;
  final VoidCallback? onOpenCreateIssue;

  const HistoryScreen({
    super.key,
    this.isEmbedded = false,
    this.onBackToHome,
    this.onOpenIssue,
    this.onOpenCreateIssue,
  });

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final _viewModel = AppDependencies.instance.issueViewModel;
  final TextEditingController _searchController = TextEditingController();

  HistoryFilter _currentFilter = HistoryFilter.all;
  HistorySort _currentSort = HistorySort.recent;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IssueModel> _getFilteredIssues(List<IssueModel> allIssues) {
    final query = _searchController.text.trim().toLowerCase();

    final list = allIssues.where((issue) {
      final matchesQuery = query.isEmpty ||
          issue.title.toLowerCase().contains(query) ||
          issue.location.toLowerCase().contains(query) ||
          (issue.description?.toLowerCase().contains(query) ?? false);

      if (!matchesQuery) return false;

      return switch (_currentFilter) {
        HistoryFilter.all => true,
        HistoryFilter.myIssues =>
          issue.userUpvoted || issue.id == '1' || issue.id == '2',
        HistoryFilter.resolved => issue.status.toLowerCase() == 'resolvido',
        HistoryFilter.pending => issue.status.toLowerCase() == 'pendente',
      };
    }).toList();

    if (_currentSort == HistorySort.mostVoted) {
      list.sort((a, b) => b.score.compareTo(a.score));
    } else {
      list.sort((a, b) => b.id.compareTo(a.id));
    }
    return list;
  }

  void _openIssueDetail(String issueId) {
    if (widget.isEmbedded && widget.onOpenIssue != null) {
      widget.onOpenIssue!(issueId);
    } else {
      Navigator.of(context).pushNamed(
        AppRoutes.issueDetail,
        arguments: issueId,
      );
    }
  }

  void _openCreateIssue() {
    if (widget.isEmbedded && widget.onOpenCreateIssue != null) {
      widget.onOpenCreateIssue!();
    } else {
      Navigator.of(context).pushNamed(AppRoutes.createIssue);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isEmbedded ? Colors.transparent : AppColors.backgroundLight,
      appBar: widget.isEmbedded ? null : const AppHeaderBar(),
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: _viewModel,
            builder: (context, _) {
              final allIssues = _viewModel.issues;
              final filtered = _getFilteredIssues(allIssues);
              final totalResolved = allIssues
                  .where((i) => i.status.toLowerCase() == 'resolvido')
                  .length;
              final totalPending = allIssues
                  .where((i) => i.status.toLowerCase() == 'pendente')
                  .length;
              final totalVotes =
                  allIssues.fold<int>(0, (sum, i) => sum + i.upvotes);

              return RefreshIndicator(
                color: AppColors.primaryYellow,
                onRefresh: _viewModel.refresh,
                child: CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  slivers: [
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                IconButton(
                                  tooltip: 'Voltar',
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.textDark,
                                    size: 22,
                                  ),
                                  splashRadius: 20,
                                  onPressed: () {
                                    if (widget.isEmbedded &&
                                        widget.onBackToHome != null) {
                                      widget.onBackToHome!();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Expanded(
                                  child: Text(
                                    'Histórico de Demandas',
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.w900,
                                      color: AppColors.textDark,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 2,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryYellow,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${filtered.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            HistoryMetricsRow(
                              total: allIssues.length,
                              resolved: totalResolved,
                              pending: totalPending,
                              votes: totalVotes,
                            ),
                            const SizedBox(height: 18),
                            HistorySearchSortBar(
                              controller: _searchController,
                              currentSort: _currentSort,
                              onSortChanged: (sort) =>
                                  setState(() => _currentSort = sort),
                            ),
                            const SizedBox(height: 14),
                            HistoryFilterChips(
                              currentFilter: _currentFilter,
                              onFilterChanged: (filter) =>
                                  setState(() => _currentFilter = filter),
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    if (filtered.isEmpty)
                      SliverToBoxAdapter(
                        child: HistoryEmptyState(
                          onResetFilters: () {
                            setState(() {
                              _searchController.clear();
                              _currentFilter = HistoryFilter.all;
                            });
                          },
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => HistoryIssueCard(
                              item: filtered[index],
                              onTap: () => _openIssueDetail(filtered[index].id),
                            ),
                            childCount: filtered.length,
                          ),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
          if (!widget.isEmbedded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab: AppNavTab.history,
                onHomeTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
                onHistoryTap: () {},
                onPlusTap: _openCreateIssue,
                onProfileTap: () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.profile),
                onSettingsTap: () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.settings),
              ),
            ),
        ],
      ),
    );
  }
}
