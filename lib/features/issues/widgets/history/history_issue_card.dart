import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/issue_model.dart';

class HistoryIssueCard extends StatelessWidget {
  final IssueModel item;
  final VoidCallback onTap;

  const HistoryIssueCard({
    super.key,
    required this.item,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
          color: isResolved ? Colors.green.shade100 : Colors.grey.shade200,
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
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                if (item.description != null &&
                    item.description!.isNotEmpty) ...[
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
                Row(
                  children: [
                    _VoteBadge(
                      icon: Icons.arrow_upward_rounded,
                      count: item.upvotes,
                      color: const Color(0xFF16A34A),
                      bgColor: const Color(0xFFF0FDF4),
                    ),
                    const SizedBox(width: 8),
                    _VoteBadge(
                      icon: Icons.arrow_downward_rounded,
                      count: item.downvotes,
                      color: const Color(0xFFDC2626),
                      bgColor: const Color(0xFFFEF2F2),
                    ),
                    const Spacer(),
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
}

class _VoteBadge extends StatelessWidget {
  final IconData icon;
  final int count;
  final Color color;
  final Color bgColor;

  const _VoteBadge({
    required this.icon,
    required this.count,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
