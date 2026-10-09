import 'package:flutter/material.dart';
import '../models/issue_model.dart';
import '../theme/app_colors.dart';
import '../viewmodels/issue_viewmodel.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_header_bar.dart';
import '../widgets/app_primary_button.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';

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

  final List<String> _sectors = [
    'Sala de Aula 10 / Setor Informática',
    'Sala de Aula 13 / Setor Administrativo',
    'Sala de Aula 20 / Setor Agropecuária',
    'Laboratório 01 / Setor Informática',
    'Laboratório 03 / Setor Eletrotécnica',
    'Biblioteca Central',
    'Auditório Principal',
    'Refeitório / Cantina',
    'Quadra Poliesportiva',
    'Bloco dos Professores',
  ];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _showSectorPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) {
        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.65,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Selecione o Setor e Sala',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 14),
              Expanded(
                child: ListView.separated(
                  itemCount: _sectors.length,
                  separatorBuilder: (_, _) => Divider(
                    height: 1,
                    color: Colors.grey.shade200,
                  ),
                  itemBuilder: (ctx, index) {
                    final sector = _sectors[index];
                    final isSelected = _selectedSector == sector;
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      title: Text(
                        sector,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected ? AppColors.primaryYellowDark : AppColors.textDark,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(Icons.check_circle, color: AppColors.primaryYellow)
                          : const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
                      onTap: () {
                        setState(() {
                          _selectedSector = sector;
                        });
                        Navigator.of(ctx).pop();
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _handleImagePick() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Adicionar foto do problema',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 18),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFEF3C7),
                  child: Icon(Icons.camera_alt_rounded, color: AppColors.primaryYellowDark),
                ),
                title: const Text('Tirar foto com a câmera', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() => _hasImage = true);
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: Color(0xFFFEF3C7),
                  child: Icon(Icons.photo_library_rounded, color: AppColors.primaryYellowDark),
                ),
                title: const Text('Escolher da galeria', style: TextStyle(fontWeight: FontWeight.w600)),
                onTap: () {
                  Navigator.of(ctx).pop();
                  setState(() => _hasImage = true);
                },
              ),
              if (_hasImage)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEE2E2),
                    child: Icon(Icons.delete_outline, color: Colors.redAccent),
                  ),
                  title: const Text('Remover foto', style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w600)),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    setState(() => _hasImage = false);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
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
      await Future.delayed(const Duration(milliseconds: 700));

      if (mounted) {
        setState(() => _isLoading = false);
        final newIssue = IssueModel(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: _titleController.text.trim(),
          location: _selectedSector!,
          status: 'Pendente',
          upvotes: 1,
          downvotes: 0,
          userUpvoted: true,
        );

        IssueViewModel().addIssue(newIssue);

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
    }
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

          // Card Central com scroll e espaçamento inferior para a barra
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
                                // Topo do Card com Botão Voltar e Título
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        color: AppColors.textDark,
                                        size: 22,
                                      ),
                                      splashRadius: 20,
                                      onPressed: () {
                                        if (widget.isEmbedded && widget.onBackToHome != null) {
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

                                // Área de Upload de Foto Moderna
                                GestureDetector(
                                  onTap: _handleImagePick,
                                  child: Container(
                                    height: 170,
                                    decoration: BoxDecoration(
                                      color: _hasImage ? const Color(0xFFFEF9C3) : const Color(0xFFEFEFEF),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: _hasImage ? AppColors.primaryYellow : Colors.grey.shade300,
                                        width: _hasImage ? 2 : 1.2,
                                      ),
                                    ),
                                    child: Center(
                                      child: _hasImage
                                          ? Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 58,
                                                  height: 58,
                                                  decoration: BoxDecoration(
                                                    color: AppColors.primaryYellow.withValues(alpha: 0.2),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.check_circle_rounded,
                                                    color: AppColors.primaryYellowDark,
                                                    size: 36,
                                                  ),
                                                ),
                                                const SizedBox(height: 10),
                                                const Text(
                                                  'Foto anexada com sucesso!',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: AppColors.primaryYellowDark,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  'Toque para alterar ou remover',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                    color: Colors.grey.shade600,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Container(
                                                  width: 64,
                                                  height: 64,
                                                  decoration: BoxDecoration(
                                                    color: Colors.grey.shade400,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(
                                                    Icons.add_rounded,
                                                    color: Colors.white,
                                                    size: 42,
                                                  ),
                                                ),
                                                const SizedBox(height: 12),
                                                Text(
                                                  'Adicionar foto',
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),

                                // Campo: Título
                                _buildLabel('Título'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _titleController,
                                  style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                                  validator: (val) {
                                    if (val == null || val.trim().isEmpty) {
                                      return 'Por favor, digite o título da ocorrência';
                                    }
                                    return null;
                                  },
                                  decoration: _buildInputDecoration(
                                    hintText: 'Digite o título...',
                                    prefixIcon: Icons.edit_note_rounded,
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Campo: Setor (Seletor com Chevron Dourado)
                                _buildLabel('Setor'),
                                const SizedBox(height: 6),
                                InkWell(
                                  onTap: _showSectorPicker,
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    decoration: BoxDecoration(
                                      color: AppColors.inputBackground,
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: _selectedSector != null
                                            ? AppColors.primaryYellow
                                            : Colors.transparent,
                                        width: 1.2,
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          size: 20,
                                          color: AppColors.textMuted,
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            _selectedSector ?? 'Selecione o setor e sala',
                                            style: TextStyle(
                                              fontSize: 14,
                                              color: _selectedSector != null
                                                  ? AppColors.textDark
                                                  : AppColors.textLight,
                                              fontWeight: _selectedSector != null
                                                  ? FontWeight.w600
                                                  : FontWeight.normal,
                                            ),
                                          ),
                                        ),
                                        const Icon(
                                          Icons.arrow_forward_ios_rounded,
                                          color: AppColors.primaryYellow,
                                          size: 18,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Campo: Descrição
                                _buildLabel('Descrição'),
                                const SizedBox(height: 6),
                                TextFormField(
                                  controller: _descriptionController,
                                  maxLines: 3,
                                  style: const TextStyle(fontSize: 14, color: AppColors.textDark),
                                  decoration: InputDecoration(
                                    hintText: 'Digite a descrição...',
                                    hintStyle: const TextStyle(
                                      color: AppColors.textLight,
                                      fontSize: 14,
                                    ),
                                    filled: true,
                                    fillColor: AppColors.inputBackground,
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
                                  ),
                                ),
                                const SizedBox(height: 24),

                                // Botão CONFIRMAR Padronizado
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

          // Barra Inferior Padronizada ancorada no bottom: 0
          if (!widget.isEmbedded)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNavBar(
                currentTab: AppNavTab.create,
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
                onPlusTap: () {},
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

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: AppColors.textDark,
      ),
    );
  }

  InputDecoration _buildInputDecoration({
    required String hintText,
    IconData? prefixIcon,
  }) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: AppColors.textLight,
        fontSize: 14,
      ),
      filled: true,
      fillColor: AppColors.inputBackground,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      prefixIcon: prefixIcon != null
          ? Icon(
              prefixIcon,
              color: AppColors.textMuted,
              size: 20,
            )
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
