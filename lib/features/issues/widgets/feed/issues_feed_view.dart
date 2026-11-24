import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../viewmodels/issue_viewmodel.dart';
import '../issue_card.dart';

class IssuesFeedView extends StatelessWidget {
  final String userName;
  final IssueViewModel viewModel;
  final TextEditingController searchController;
  final ValueChanged<String> onOpenIssue;

  const IssuesFeedView({
    super.key,
    required this.userName,
    required this.viewModel,
    required this.searchController,
    required this.onOpenIssue,
  });

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: viewModel,
      builder: (context, _) {
        final issues = viewModel.issues;
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
                      'Olá, $userName!',
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
                    _FeedSearchBar(
                      controller: searchController,
                      onSearch: () => viewModel.search(searchController.text),
                    ),
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
                        onTap: () => onOpenIssue(issue.id),
                        onUpvote: () => viewModel.toggleUpvote(issue.id),
                        onDownvote: () => viewModel.toggleDownvote(issue.id),
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
}

class _FeedSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onSearch;

  const _FeedSearchBar({
    required this.controller,
    required this.onSearch,
  });

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
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
            tooltip: 'Filtrar por setor',
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
          Container(height: 22, width: 1, color: Colors.grey.shade300),
          IconButton(
            tooltip: 'Pesquisar',
            icon: const Icon(
              Icons.search_rounded,
              color: AppColors.primaryYellow,
              size: 26,
            ),
            splashRadius: 20,
            onPressed: onSearch,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
