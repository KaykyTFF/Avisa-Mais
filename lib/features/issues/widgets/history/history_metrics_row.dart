import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class HistoryMetricsRow extends StatelessWidget {
  final int total;
  final int resolved;
  final int pending;
  final int votes;

  const HistoryMetricsRow({
    super.key,
    required this.total,
    required this.resolved,
    required this.pending,
    required this.votes,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _MetricTile(
            label: 'Total',
            value: '$total',
            icon: Icons.assignment_rounded,
            color: AppColors.textDark,
            bgColor: AppColors.backgroundGray,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricTile(
            label: 'Resolvidos',
            value: '$resolved',
            icon: Icons.check_circle_rounded,
            color: AppColors.statusResolved,
            bgColor: AppColors.statusResolvedBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricTile(
            label: 'Pendentes',
            value: '$pending',
            icon: Icons.hourglass_top_rounded,
            color: AppColors.statusPending,
            bgColor: AppColors.statusPendingBg,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _MetricTile(
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
}

class _MetricTile extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color bgColor;

  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
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
            decoration: BoxDecoration(color: bgColor, shape: BoxShape.circle),
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
}
