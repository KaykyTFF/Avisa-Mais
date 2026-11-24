import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

enum HistoryFilter { all, myIssues, resolved, pending }

enum HistorySort { recent, mostVoted }

class HistorySearchSortBar extends StatelessWidget {
  final TextEditingController controller;
  final HistorySort currentSort;
  final ValueChanged<HistorySort> onSortChanged;

  const HistorySearchSortBar({
    super.key,
    required this.controller,
    required this.currentSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
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
              controller: controller,
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
                suffixIcon: controller.text.isNotEmpty
                    ? IconButton(
                        tooltip: 'Limpar busca',
                        icon: const Icon(Icons.clear_rounded, size: 18),
                        onPressed: controller.clear,
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
          initialValue: currentSort,
          onSelected: onSortChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          itemBuilder: (_) => const [
            PopupMenuItem(
              value: HistorySort.recent,
              child: Row(
                children: [
                  Icon(Icons.schedule_rounded, size: 18, color: AppColors.textDark),
                  SizedBox(width: 8),
                  Text(
                    'Mais recentes',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: HistorySort.mostVoted,
              child: Row(
                children: [
                  Icon(Icons.thumb_up_outlined, size: 18, color: AppColors.textDark),
                  SizedBox(width: 8),
                  Text(
                    'Mais votados',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                  ),
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
}

class HistoryFilterChips extends StatelessWidget {
  final HistoryFilter currentFilter;
  final ValueChanged<HistoryFilter> onFilterChanged;

  const HistoryFilterChips({
    super.key,
    required this.currentFilter,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _FilterChipItem(
            label: 'Todas',
            icon: Icons.list_alt_rounded,
            isSelected: currentFilter == HistoryFilter.all,
            onTap: () => onFilterChanged(HistoryFilter.all),
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: 'Minhas Atividades',
            icon: Icons.person_outline_rounded,
            isSelected: currentFilter == HistoryFilter.myIssues,
            onTap: () => onFilterChanged(HistoryFilter.myIssues),
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: 'Resolvidas',
            icon: Icons.check_circle_outline_rounded,
            isSelected: currentFilter == HistoryFilter.resolved,
            onTap: () => onFilterChanged(HistoryFilter.resolved),
          ),
          const SizedBox(width: 8),
          _FilterChipItem(
            label: 'Pendentes',
            icon: Icons.hourglass_empty_rounded,
            isSelected: currentFilter == HistoryFilter.pending,
            onTap: () => onFilterChanged(HistoryFilter.pending),
          ),
        ],
      ),
    );
  }
}

class _FilterChipItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChipItem({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
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
}
