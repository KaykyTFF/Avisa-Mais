import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/issue_model.dart';

class IssueDetailPhoto extends StatelessWidget {
  final IssueModel issue;

  const IssueDetailPhoto({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    final isResolved = issue.status.toLowerCase() == 'resolvido';

    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color:
              isResolved ? const Color(0xFF10B981) : AppColors.primaryYellow,
          width: 2.2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              color: const Color(0xFFF3F4F6),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      issue.title.toLowerCase().contains('datashow')
                          ? Icons.videocam_rounded
                          : (issue.title
                                  .toLowerCase()
                                  .contains('ar condicionado')
                              ? Icons.ac_unit_rounded
                              : Icons.image_outlined),
                      size: 68,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        issue.title,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isResolved
                    ? const Color(0xFF10B981)
                    : AppColors.primaryYellow,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Text(
                issue.status,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.4,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class IssueDetailInfoCard extends StatelessWidget {
  final IssueModel issue;

  const IssueDetailInfoCard({super.key, required this.issue});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.inputBackground,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade200, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            issue.title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.textDark,
              letterSpacing: -0.2,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.location_on_outlined,
                size: 16,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  issue.location,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(height: 1, color: Colors.grey.shade300),
          const SizedBox(height: 12),
          Text(
            issue.description ?? 'Nenhuma observação adicional informada.',
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF4B5563),
              height: 1.4,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
