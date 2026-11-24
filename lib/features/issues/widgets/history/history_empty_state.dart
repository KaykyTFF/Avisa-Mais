import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HistoryEmptyState extends StatelessWidget {
  final VoidCallback onResetFilters;

  const HistoryEmptyState({super.key, required this.onResetFilters});

  @override
  Widget build(BuildContext context) {
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
              style: TextStyle(fontSize: 13, color: AppColors.textMuted),
            ),
            const SizedBox(height: 18),
            ElevatedButton.icon(
              onPressed: onResetFilters,
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
