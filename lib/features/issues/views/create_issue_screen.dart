import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/issue_model.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../../widgets/app_header_bar.dart';
import '../../../widgets/app_primary_button.dart';
import '../widgets/create/issue_photo_picker.dart';
import '../widgets/create/issue_sector_picker.dart';

class CreateIssueScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onBackToHome;

  const CreateIssueScreen({
    super.key,
    this.isEmbedded = false,
    this.onBackToHome,
  });

  @override
  State<CreateIssueScreen> createState() => _CreateIssueScreenState();
}

class _CreateIssueScreenState extends State<CreateIssueScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String? _selectedSector;
  bool _hasImage = false;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    if (_selectedSector == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, selecione o setor e sala da ocorrência.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _isLoading = false);
    final newIssue = IssueModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: _titleController.text.trim(),
      location: _selectedSector!,
      description: _descriptionController.text.trim().isEmpty
          ? null
          : _descriptionController.text.trim(),
      status: 'Pendente',
      upvotes: 1,
      downvotes: 0,
      userUpvoted: true,
    );

    AppDependencies.instance.issueViewModel.addIssue(newIssue);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.primaryYellowDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Ocorrência criada com sucesso!'),
          ],
        ),
      ),
    );

    if (widget.isEmbedded && widget.onBackToHome != null) {
      widget.onBackToHome!();
    } else {
      Navigator.of(context).pop(newIssue);
    }
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
          SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.cardBackground,
                    borderRadius: BorderRadius.circular(28),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.10),
                        blurRadius: 28,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 18, 22, 24),
                    child: Form(
                      key: _formKey,
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
                                  size: 22,
                                ),
                                splashRadius: 20,
                                onPressed: () {
                                  if (widget.isEmbedded &&
                                      widget.onBackToHome != null) {
                                    widget.onBackToHome!();
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                              const SizedBox(width: 8),
                              const Text(
                                'Criar ocorrência',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w900,
                                  color: AppColors.textDark,
                                  letterSpacing: -0.3,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 18),
                          IssuePhotoPicker(
                            hasImage: _hasImage,
                            onChanged: (value) =>
                                setState(() => _hasImage = value),
                          ),
                          const SizedBox(height: 20),
                          const _FieldLabel('Título'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _titleController,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                            validator: (val) {
                              if (val == null || val.trim().isEmpty) {
                                return 'Por favor, digite o título da ocorrência';
                              }
                              return null;
                            },
                            decoration: _inputDecoration(
                              hintText: 'Digite o título...',
                              prefixIcon: Icons.edit_note_rounded,
                            ),
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Setor'),
                          const SizedBox(height: 6),
                          IssueSectorPicker(
                            selectedSector: _selectedSector,
                            onSelected: (sector) =>
                                setState(() => _selectedSector = sector),
                          ),
                          const SizedBox(height: 16),
                          const _FieldLabel('Descrição'),
                          const SizedBox(height: 6),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: 3,
                            style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.textDark,
                            ),
                            decoration: _inputDecoration(
                              hintText: 'Digite a descrição...',
                            ),
                          ),
                          const SizedBox(height: 24),
                          AppPrimaryButton(
                            text: 'CONFIRMAR',
                            isLoading: _isLoading,
                            onPressed: _handleSubmit,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          if (!widget.isEmbedded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab: AppNavTab.create,
                onHomeTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
                onHistoryTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.history),
                onPlusTap: () {},
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

  InputDecoration _inputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: prefixIcon != null
          ? Icon(prefixIcon, color: AppColors.textMuted, size: 20)
          : null,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(
          color: AppColors.inputBorderFocus,
          width: 1.5,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.2),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;

  const _FieldLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }
}
