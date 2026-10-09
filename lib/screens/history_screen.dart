import 'package:flutter/material.dart';
import '../data/models/issue_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/issue_viewmodel.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_header_bar.dart';
import 'create_issue_screen.dart';
import 'home_screen.dart';
import 'issue_detail_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

enum HistoryFilter {
  all,
  myIssues,
  resolved,
  pending,
}

enum HistorySort {
  recent,
  mostVoted,
}

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
  final IssueViewModel _viewModel = IssueViewModel();
  final TextEditingController _searchController = TextEditingController();

  HistoryFilter _currentFilter = HistoryFilter.all;
  HistorySort _currentSort = HistorySort.recent;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<IssueModel> _getFilteredIssues(List<IssueModel> allIssues) {
    final query = _searchController.text.trim().toLowerCase();

    var list = allIssues.where((issue) {
      // Filtro de texto
      final matchesQuery = query.isEmpty ||
          issue.title.toLowerCase().contains(query) ||
          issue.location.toLowerCase().contains(query) ||
          (issue.description?.toLowerCase().contains(query) ?? false);

      if (!matchesQuery) return false;

      // Filtro por categoria/status
      switch (_currentFilter) {
        case HistoryFilter.all:
          return true;
        case HistoryFilter.myIssues:
          // Consideramos os criados recentemente ou apoiados
          return issue.userUpvoted || issue.id == '1' || issue.id == '2';
        case HistoryFilter.resolved:
          return issue.status.toLowerCase() == 'resolvido';
        case HistoryFilter.pending:
          return issue.status.toLowerCase() == 'pendente';
      }
    }).toList();

    // Ordenação
    if (_currentSort == HistorySort.mostVoted) {
      list.sort((a, b) => b.score.compareTo(a.score));
    } else {
      // Por id / recente
      list.sort((a, b) => b.id.compareTo(a.id));
    }

    return list;
  }

  void _openIssueDetail(String issueId) {
    if (widget.isEmbedded && widget.onOpenIssue != null) {
      widget.onOpenIssue!(issueId);
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => IssueDetailScreen(issueId: issueId),
        ),
      );
    }
  }

  void _openCreateIssue() {
    if (widget.isEmbedded && widget.onOpenCreateIssue != null) {
      widget.onOpenCreateIssue!();
    } else {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => const CreateIssueScreen(),
        ),
      );
    }
  }

  void _openProfile() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const ProfileScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isEmbedded ? Colors.transparent : AppColors.backgroundLight,
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
                onRefresh: () => _viewModel.refresh(),
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
                                  icon: const Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    color: AppColors.textDark,
                                    size: 22,
                                  ),
                                  splashRadius: 20,
                                  onPressed: () {
                                    if (widget.isEmbedded && widget.onBackToHome != null) {
                                      widget.onBackToHome!();
                                    } else {
                                      Navigator.of(context).pop();
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Histórico de Demandas',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
                            _buildStatCardsRow(
                              total: allIssues.length,
                              resolved: totalResolved,
                              pending: totalPending,
                              votes: totalVotes,
                            ),
                            const SizedBox(height: 18),
                            _buildSearchAndSortBar(),
                            const SizedBox(height: 14),
                            _buildFilterChips(),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                    ),
                    if (filtered.isEmpty)
                      SliverToBoxAdapter(
                        child: _buildEmptyState(),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 0, 20, 100),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              final item = filtered[index];
                              return _buildHistoryCard(item);
                            },
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
                onHomeTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                onHistoryTap: () {},
                onPlusTap: _openCreateIssue,
                onProfileTap: _openProfile,
                onSettingsTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildStatCardsRow({
    required int total,
    required int resolved,
    required int pending,
    required int votes,
  }) {
    return Row(
      children: [
        Expanded(
          child: _buildMetricTile(
            label: 'Total',
            value: '$total',
            icon: Icons.assignment_rounded,
            color: AppColors.textDark,
            bgColor: AppColors.backgroundGray,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Resolvidos',
            value: '$resolved',
            icon: Icons.check_circle_rounded,
            color: AppColors.statusResolved,
            bgColor: AppColors.statusResolvedBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Pendentes',
            value: '$pending',
            icon: Icons.hourglass_top_rounded,
            color: AppColors.statusPending,
            bgColor: AppColors.statusPendingBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricTile(
            label: 'Apoios',
            value: '$votes',
            icon: Icons.thumb_up_alt_rounded,
            color: AppColors.primaryYellowDark,
            bgColor: const Color(0xFFFFFBEB),
          ),
        ),
      ],
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color bgColor,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bgColor,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: color),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: color,
              height: 1.1,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: AppColors.textMuted,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndSortBar() {
    return Row(
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              style: const TextStyle(fontSize: 13, color: AppColors.textDark),
              decoration: InputDecoration(
                hintText: 'Filtrar histórico...',
                hintStyle: const TextStyle(
                  fontSize: 13,
                  color: AppColors.textLight,
                ),
                prefixIcon: const Icon(
                  Icons.search_rounded,
                  color: AppColors.primaryYellow,
                  size: 20,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: () => _searchController.clear(),
                      )
                    : null,
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        PopupMenuButton<HistorySort>(
          initialValue: _currentSort,
          onSelected: (sort) {
            setState(() {
              _currentSort = sort;
            });
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: HistorySort.recent,
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 18, color: AppColors.textDark),
                  SizedBox(width: 8),
                  Text('Mais recentes', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
            const PopupMenuItem(
              value: HistorySort.mostVoted,
              child: Row(
                children: [
                  Icon(Icons.thumb_up_outlined, size: 18, color: AppColors.textDark),
                  SizedBox(width: 8),
                  Text('Mais votados', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ],
          child: Container(
            padding: const EdgeInsets.all(11),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 10,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: const Icon(
              Icons.swap_vert_rounded,
              color: AppColors.primaryYellowDark,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip(
            label: 'Todas',
            filter: HistoryFilter.all,
            icon: Icons.list_alt_rounded,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Minhas Atividades',
            filter: HistoryFilter.myIssues,
            icon: Icons.person_outline_rounded,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Resolvidas',
            filter: HistoryFilter.resolved,
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(width: 8),
          _buildChip(
            label: 'Pendentes',
            filter: HistoryFilter.pending,
            icon: Icons.hourglass_empty_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required HistoryFilter filter,
    required IconData icon,
  }) {
    final isSelected = _currentFilter == filter;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentFilter = filter;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryYellow : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? AppColors.primaryYellow : Colors.grey.shade300,
            width: 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryYellow.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 15,
              color: isSelected ? Colors.white : AppColors.textMuted,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? Colors.white : AppColors.textDark,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHistoryCard(IssueModel item) {
    final isResolved = item.status.toLowerCase() == 'resolvido';
    final statusColor =
        isResolved ? AppColors.statusResolved : AppColors.statusPending;
    final statusBgColor =
        isResolved ? AppColors.statusResolvedBg : AppColors.statusPendingBg;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isResolved
              ? Colors.green.shade100
              : Colors.grey.shade200,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => _openIssueDetail(item.id),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Topo do card: Categoria / Local e Tag de Status
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEF3C7),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            size: 14,
                            color: AppColors.primaryYellowDark,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Ocorrência #${item.id}',
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: statusBgColor,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: statusColor.withValues(alpha: 0.3),
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            isResolved
                                ? Icons.check_circle_rounded
                                : Icons.schedule_rounded,
                            size: 13,
                            color: statusColor,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            item.status,
                            style: TextStyle(
                              color: statusColor,
                              fontSize: 11,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Título da ocorrência
                Text(
                  item.title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                    letterSpacing: -0.2,
                  ),
                ),
                const SizedBox(height: 4),

                // Localização
                Row(
                  children: [
                    const Icon(
                      Icons.location_on_outlined,
                      size: 14,
                      color: AppColors.textLight,
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        item.location,
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                if (item.description != null && item.description!.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    item.description!,
                    style: const TextStyle(
                      fontSize: 13,
                      color: Color(0xFF4B5563),
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 14),
                const Divider(height: 1, color: Color(0xFFF3F4F6)),
                const SizedBox(height: 12),

                // Rodapé com votos, comentários e CTA
                Row(
                  children: [
                    // Upvotes
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_upward_rounded,
                            size: 14,
                            color: Color(0xFF16A34A),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.upvotes}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF16A34A),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Downvotes
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_downward_rounded,
                            size: 14,
                            color: Color(0xFFDC2626),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${item.downvotes}',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFDC2626),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    // Botão Acessar
                    const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Ver detalhes',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryYellowDark,
                          ),
                        ),
                        SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward_rounded,
                          size: 14,
                          color: AppColors.primaryYellowDark,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 24),
      child: Center(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7).withValues(alpha: 0.6),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.assignment_late_outlined,
                size: 48,
                color: AppColors.primaryYellowDark,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Nenhum registro encontrado',
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Tente ajustar o termo pesquisado ou selecione outro filtro de categoria.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _searchController.clear();
                  _currentFilter = HistoryFilter.all;
                });
              },
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text('Limpar Filtros'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryYellow,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
