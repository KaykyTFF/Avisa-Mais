import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../data/models/comment_model.dart';

class IssueCommentsSection extends StatelessWidget {
  final List<CommentModel> comments;
  final TextEditingController commentController;
  final VoidCallback onSendComment;

  const IssueCommentsSection({
    super.key,
    required this.comments,
    required this.commentController,
    required this.onSendComment,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            const Icon(
              Icons.forum_rounded,
              color: AppColors.primaryYellowDark,
              size: 20,
            ),
            const SizedBox(width: 8),
            const Expanded(
              child: Text(
                'Discussão da Comunidade',
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.inputBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${comments.length} msgs',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textMuted,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        if (comments.isEmpty)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FAFB),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Icon(
                  Icons.chat_bubble_outline_rounded,
                  size: 38,
                  color: Colors.grey.shade400,
                ),
                const SizedBox(height: 8),
                Text(
                  'Nenhum comentário ainda.',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey.shade600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Seja o primeiro a enviar uma atualização!',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                ),
              ],
            ),
          )
        else
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: comments.length,
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, index) => _CommentTile(comment: comments[index]),
          ),
        const SizedBox(height: 18),
        Container(
          decoration: BoxDecoration(
            color: AppColors.inputBackground,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.grey.shade300, width: 1.2),
          ),
          padding: const EdgeInsets.only(left: 16, right: 6, top: 4, bottom: 4),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: commentController,
                  textCapitalization: TextCapitalization.sentences,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textDark,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Escreva um comentário ou atualização...',
                    hintStyle: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 13,
                    ),
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.symmetric(vertical: 10),
                  ),
                  onSubmitted: (_) => onSendComment(),
                ),
              ),
              const SizedBox(width: 6),
              Material(
                color: AppColors.primaryYellow,
                shape: const CircleBorder(),
                child: InkWell(
                  onTap: onSendComment,
                  customBorder: const CircleBorder(),
                  child: const Padding(
                    padding: EdgeInsets.all(10),
                    child: Icon(
                      Icons.send_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _CommentTile extends StatelessWidget {
  final CommentModel comment;

  const _CommentTile({required this.comment});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: comment.isOfficial
            ? const Color(0xFFFEF9C3)
            : const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color:
              comment.isOfficial ? AppColors.primaryYellow : Colors.grey.shade200,
          width: comment.isOfficial ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: comment.isOfficial
                    ? AppColors.primaryYellow
                    : const Color(0xFF4B5563),
                child: Text(
                  comment.userName.isNotEmpty
                      ? comment.userName[0].toUpperCase()
                      : 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.userName,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    Text(
                      comment.userRole,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: comment.isOfficial
                            ? AppColors.primaryYellowDark
                            : AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                'Agora',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            comment.content,
            style: const TextStyle(
              fontSize: 13,
              color: AppColors.textDark,
              height: 1.35,
            ),
          ),
        ],
      ),
    );
  }
}
