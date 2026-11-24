import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/issue_model.dart';

class IssueDetailVoteBar extends StatelessWidget {
  final IssueModel issue;
  final int commentsCount;
  final VoidCallback onUpvote;
  final VoidCallback onDownvote;

  const IssueDetailVoteBar({
    super.key,
    required this.issue,
    required this.commentsCount,
    required this.onUpvote,
    required this.onDownvote,
  });

  @override
  Widget build(BuildContext context) {
    final netScore = issue.upvotes - issue.downvotes;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.grey.shade300, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  tooltip: 'Upvote',
                  splashRadius: 20,
                  icon: Icon(
                    Icons.arrow_upward_rounded,
                    size: 22,
                    color: issue.userUpvoted
                        ? const Color(0xFFFF4500)
                        : Colors.grey.shade700,
                  ),
                  onPressed: onUpvote,
                ),
                Text(
                  '$netScore',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w900,
                    color: issue.userUpvoted
                        ? const Color(0xFFFF4500)
                        : (issue.userDownvoted
                            ? const Color(0xFF7193FF)
                            : AppColors.textDark),
                  ),
                ),
                IconButton(
                  tooltip: 'Downvote',
                  splashRadius: 20,
                  icon: Icon(
                    Icons.arrow_downward_rounded,
                    size: 22,
                    color: issue.userDownvoted
                        ? const Color(0xFF7193FF)
                        : Colors.grey.shade700,
                  ),
                  onPressed: onDownvote,
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4F6),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.mode_comment_outlined,
                    size: 18,
                    color: AppColors.textDark,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$commentsCount',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textDark,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              tooltip: 'Compartilhar',
              splashRadius: 20,
              icon: const Icon(
                Icons.share_outlined,
                size: 20,
                color: AppColors.textDark,
              ),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Link da ocorrência copiado!'),
                    duration: Duration(milliseconds: 1500),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
