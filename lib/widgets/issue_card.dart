import 'package:flutter/material.dart';
import '../data/models/issue_model.dart';
import '../theme/app_colors.dart';

class IssueCard extends StatelessWidget {
  final IssueModel issue;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;
  final VoidCallback? onTap;

  const IssueCard({
    super.key,
    required this.issue,
    required this.onUpvote,
    required this.onDownvote,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isResolved = issue.status.toLowerCase().startsWith('resolv');

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 18,
              offset: const Offset(0, 6),
            ),
          ],
          border: Border.all(color: Colors.grey.shade200, width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Thumbnail / Foto ilustrativa da ocorrência
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 84,
                  height: 84,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: issue.imageUrl != null && issue.imageUrl!.isNotEmpty
                      ? Image.network(
                          issue.imageUrl!,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Center(
                            child: Icon(
                              Icons.image_outlined,
                              size: 32,
                              color: Colors.grey.shade400,
                            ),
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 32,
                            color: Colors.grey.shade400,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 14),

              // Detalhes da ocorrência (Título, Localização, Votos e Status)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      issue.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      issue.location,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textMuted,
                      ),
                    ),
                    const SizedBox(height: 10),

                    // Linha inferior: Votos à esquerda e Status à direita
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Pílulas de Votos (Idênticas ao Histórico)
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Upvote
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onUpvote,
                                borderRadius: BorderRadius.circular(8),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: issue.userUpvoted
                                        ? const Color(0xFFDCFCE7)
                                        : const Color(0xFFF0FDF4),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: issue.userUpvoted
                                          ? const Color(0xFF16A34A).withValues(alpha: 0.5)
                                          : const Color(0xFF16A34A).withValues(alpha: 0.15),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_upward_rounded,
                                        size: 14,
                                        color: issue.userUpvoted
                                            ? const Color(0xFF15803D)
                                            : const Color(0xFF16A34A),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${issue.upvotes}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: issue.userUpvoted
                                              ? const Color(0xFF15803D)
                                              : const Color(0xFF16A34A),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),

                            // Downvote
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                onTap: onDownvote,
                                borderRadius: BorderRadius.circular(8),
                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 150),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: issue.userDownvoted
                                        ? const Color(0xFFFEE2E2)
                                        : const Color(0xFFFEF2F2),
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(
                                      color: issue.userDownvoted
                                          ? const Color(0xFFDC2626).withValues(alpha: 0.5)
                                          : const Color(0xFFDC2626).withValues(alpha: 0.15),
                                      width: 1,
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.arrow_downward_rounded,
                                        size: 14,
                                        color: issue.userDownvoted
                                            ? const Color(0xFFB91C1C)
                                            : const Color(0xFFDC2626),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        '${issue.downvotes}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w700,
                                          color: issue.userDownvoted
                                              ? const Color(0xFFB91C1C)
                                              : const Color(0xFFDC2626),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        // Badge de Status (compacto, posicionado na direita embaixo)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 9,
                            vertical: 3.5,
                          ),
                          decoration: BoxDecoration(
                            color: isResolved
                                ? const Color(0xFF10B981)
                                : AppColors.primaryYellow,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: (isResolved
                                        ? const Color(0xFF10B981)
                                        : AppColors.primaryYellow)
                                    .withValues(alpha: 0.25),
                                blurRadius: 4,
                                offset: const Offset(0, 1.5),
                              ),
                            ],
                          ),
                          child: Text(
                            issue.status,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
