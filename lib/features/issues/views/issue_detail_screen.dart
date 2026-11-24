import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/issue_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../../widgets/app_header_bar.dart';
import '../widgets/detail/issue_comments_section.dart';
import '../widgets/detail/issue_detail_header.dart';
import '../widgets/detail/issue_detail_vote_bar.dart';

class IssueDetailScreen extends StatefulWidget {
  final String issueId;
  final bool isEmbedded;
  final VoidCallback? onBack;

  const IssueDetailScreen({
    super.key,
    required this.issueId,
    this.isEmbedded = false,
    this.onBack,
  });

  @override
  State<IssueDetailScreen> createState() => _IssueDetailScreenState();
}

class _IssueDetailScreenState extends State<IssueDetailScreen> {
  final _issueViewModel = AppDependencies.instance.issueViewModel;
  final _authViewModel = AppDependencies.instance.authViewModel;
  final TextEditingController _commentController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _commentController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendComment() {
    final text = _commentController.text.trim();
    if (text.isEmpty) return;

    final user = _authViewModel.currentUser;
    _issueViewModel.addComment(
      widget.issueId,
      text,
      userName: user?.name ?? 'Kayky Rocha',
      userRole: 'Aluno - Campus Central',
    );

    _commentController.clear();
    FocusScope.of(context).unfocus();

    Future<void>.delayed(const Duration(milliseconds: 200), () {
      if (!mounted || !_scrollController.hasClients) return;
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isEmbedded ? Colors.transparent : AppColors.backgroundGray,
      appBar: widget.isEmbedded ? null : const AppHeaderBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(child: Container(color: AppColors.backgroundGray)),
          ListenableBuilder(
            listenable: _issueViewModel,
            builder: (context, _) {
              final issue = _issueViewModel.getIssue(widget.issueId) ??
                  IssueModel(
                    id: widget.issueId,
                    title: 'Ocorrência',
                    location: 'IFPI',
                    status: 'Pendente',
                    upvotes: 0,
                    downvotes: 0,
                  );
              final comments = _issueViewModel.getComments(widget.issueId);

              return SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 110),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(28),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.12),
                            blurRadius: 24,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.fromLTRB(18, 16, 18, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                tooltip: 'Voltar',
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.textDark,
                                  size: 24,
                                ),
                                splashRadius: 22,
                                onPressed: () {
                                  if (widget.isEmbedded &&
                                      widget.onBack != null) {
                                    widget.onBack!();
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              const Expanded(
                                child: Text(
                                  'Ocorrência',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w900,
                                    color: AppColors.textDark,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 48),
                            ],
                          ),
                          const SizedBox(height: 14),
                          IssueDetailPhoto(issue: issue),
                          const SizedBox(height: 18),
                          IssueDetailInfoCard(issue: issue),
                          const SizedBox(height: 14),
                          IssueDetailVoteBar(
                            issue: issue,
                            commentsCount: comments.length,
                            onUpvote: () =>
                                _issueViewModel.toggleUpvote(issue.id),
                            onDownvote: () =>
                                _issueViewModel.toggleDownvote(issue.id),
                          ),
                          const SizedBox(height: 24),
                          IssueCommentsSection(
                            comments: comments,
                            commentController: _commentController,
                            onSendComment: _sendComment,
                          ),
                        ],
                      ),
                    ),
                  ),
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
                currentTab: AppNavTab.none,
                onHomeTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
                onHistoryTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.history),
                onPlusTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.createIssue),
                onProfileTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.profile),
                onSettingsTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.settings),
              ),
            ),
        ],
      ),
    );
  }
}
