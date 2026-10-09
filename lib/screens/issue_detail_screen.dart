import 'package:flutter/material.dart';
import '../data/models/comment_model.dart';
import '../data/models/issue_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../viewmodels/issue_viewmodel.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_header_bar.dart';
import 'create_issue_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

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
  final IssueViewModel _issueViewModel = IssueViewModel();
  final AuthViewModel _authViewModel = AuthViewModel();
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

    // Scroll suave para o final
    Future.delayed(const Duration(milliseconds: 200), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isEmbedded ? Colors.transparent : AppColors.backgroundGray,
      appBar: widget.isEmbedded ? null : const AppHeaderBar(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Fundo Branco Acinzentado
          Positioned.fill(
            child: Container(
              color: AppColors.backgroundGray,
            ),
          ),

          // Conteúdo rolável com espaçamento para a barra inferior
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
                          // Topo do card: Botão Voltar e Título "Ocorrência"
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  color: AppColors.textDark,
                                  size: 24,
                                ),
                                splashRadius: 22,
                                onPressed: () {
                                  if (widget.isEmbedded && widget.onBack != null) {
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
                              const SizedBox(width: 48), // Espaço de equilíbrio
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Foto da Ocorrência com Tag de Status
                          _buildIssuePhoto(issue),
                          const SizedBox(height: 18),

                          // Card com Título, Setor e Descrição
                          _buildDetailsCard(issue),
                          const SizedBox(height: 14),

                          // Barra de Votação Estilo Reddit (Upvote, Score, Downvote, Comentários, Compartilhar)
                          _buildRedditVoteBar(issue, comments.length),
                          const SizedBox(height: 24),

                          // Divisor da Seção de Chat / Discussão
                          Row(
                            children: [
                              const Icon(
                                Icons.forum_rounded,
                                color: AppColors.primaryYellowDark,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Discussão da Comunidade',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.textDark,
                                ),
                              ),
                              const Spacer(),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
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

                          // Lista de Mensagens do Chat / Comentários
                          _buildCommentsList(comments),
                          const SizedBox(height: 18),

                          // Campo de Envio de Mensagem no Chat
                          _buildChatInputField(),
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
                onHomeTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                onHistoryTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
                onPlusTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const CreateIssueScreen(),
                    ),
                  );
                },
                onProfileTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => const ProfileScreen(),
                    ),
                  );
                },
                onSettingsTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const SettingsScreen()),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  // Foto / Imagem do Problema
  Widget _buildIssuePhoto(IssueModel issue) {
    final isResolved = issue.status.toLowerCase() == 'resolvido';

    return Container(
      height: 210,
      decoration: BoxDecoration(
        color: const Color(0xFFE5E7EB),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isResolved ? const Color(0xFF10B981) : AppColors.primaryYellow,
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
                          : (issue.title.toLowerCase().contains('ar condicionado')
                              ? Icons.ac_unit_rounded
                              : Icons.image_outlined),
                      size: 68,
                      color: Colors.grey.shade400,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      issue.title,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Badge de Status flutuante no canto inferior direito
          Positioned(
            right: 14,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: isResolved ? const Color(0xFF10B981) : AppColors.primaryYellow,
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

  // Card com Título, Setor e Descrição
  Widget _buildDetailsCard(IssueModel issue) {
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
          Container(
            height: 1,
            color: Colors.grey.shade300,
          ),
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

  // Barra de Votação Reddit (Upvote, Score, Downvote)
  Widget _buildRedditVoteBar(IssueModel issue, int commentsCount) {
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
          // Pílula Reddit de Votação
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFF3F4F6),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Upvote (Laranja estilo Reddit quando ativo)
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
                  onPressed: () => _issueViewModel.toggleUpvote(issue.id),
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
                // Downvote (Azul estilo Reddit quando ativo)
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
                  onPressed: () => _issueViewModel.toggleDownvote(issue.id),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Pílula de Comentários
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

          // Botão Compartilhar
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

  // Lista de Comentários do Chat
  Widget _buildCommentsList(List<CommentModel> comments) {
    if (comments.isEmpty) {
      return Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
        decoration: BoxDecoration(
          color: const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          children: [
            Icon(Icons.chat_bubble_outline_rounded,
                size: 38, color: Colors.grey.shade400),
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
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade500,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: comments.length,
      separatorBuilder: (_, _) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final comment = comments[index];
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: comment.isOfficial
                ? const Color(0xFFFEF9C3) // Amarelo suave para suporte oficial
                : const Color(0xFFF9FAFB),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: comment.isOfficial
                  ? AppColors.primaryYellow
                  : Colors.grey.shade200,
              width: comment.isOfficial ? 1.4 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho do comentário (Nome, Tag, Tempo)
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
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Conteúdo da mensagem
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
      },
    );
  }

  // Campo de Envio de Mensagem no Chat
  Widget _buildChatInputField() {
    return Container(
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
              controller: _commentController,
              textCapitalization: TextCapitalization.sentences,
              style: const TextStyle(fontSize: 14, color: AppColors.textDark),
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
              onSubmitted: (_) => _sendComment(),
            ),
          ),
          const SizedBox(width: 6),
          Material(
            color: AppColors.primaryYellow,
            shape: const CircleBorder(),
            child: InkWell(
              onTap: _sendComment,
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
    );
  }
}
