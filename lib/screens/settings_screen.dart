import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../viewmodels/auth_viewmodel.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/app_header_bar.dart';
import 'create_issue_screen.dart';
import 'history_screen.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'profile_screen.dart';

class SettingsScreen extends StatefulWidget {
  final bool isEmbedded;
  final VoidCallback? onBackToHome;

  const SettingsScreen({
    super.key,
    this.isEmbedded = false,
    this.onBackToHome,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthViewModel _authViewModel = AuthViewModel();

  // Preferências
  bool _notifyNewIssues = true;
  bool _notifyStatusChange = true;
  bool _notifyComments = true;
  bool _dataSaver = false;
  bool _soundAndVibration = true;

  final List<String> _campiList = [
    'IFPI - Campus Teresina Central',
    'IFPI - Campus Teresina Zona Sul',
    'IFPI - Campus Parnaíba',
    'IFPI - Campus Picos',
    'IFPI - Campus Floriano',
    'IFPI - Campus Piripiri',
    'IFPI - Campus Campo Maior',
    'IFPI - Campus Angical',
    'IFPI - Campus Corrente',
    'IFPI - Campus São Raimundo Nonato',
  ];

  void _showChangeCampusDialog(String currentCampus) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.school_rounded, color: AppColors.primaryYellowDark),
            SizedBox(width: 10),
            Text(
              'Selecionar Campus',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: _campiList.length,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final campus = _campiList[index];
              final isSelected = campus == currentCampus;
              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                title: Text(
                  campus,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                    color: isSelected ? AppColors.primaryYellowDark : AppColors.textDark,
                  ),
                ),
                trailing: isSelected
                    ? const Icon(
                        Icons.check_circle_rounded,
                        color: AppColors.primaryYellowDark,
                        size: 20,
                      )
                    : null,
                onTap: () {
                  _authViewModel.updateProfile(campus: campus);
                  Navigator.of(ctx).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Campus alterado para: $campus'),
                      backgroundColor: AppColors.textDark,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Fechar', style: TextStyle(color: AppColors.textMuted)),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog() {
    final currentPasswordController = TextEditingController();
    final newPasswordController = TextEditingController();
    final confirmPasswordController = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.lock_reset_rounded, color: AppColors.primaryYellowDark),
            SizedBox(width: 10),
            Text(
              'Alterar Senha',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: currentPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Senha atual',
                  prefixIcon: const Icon(Icons.lock_outline_rounded, size: 20),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Nova senha',
                  prefixIcon: const Icon(Icons.key_rounded, size: 20),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: 'Confirmar nova senha',
                  prefixIcon: const Icon(Icons.check_rounded, size: 20),
                  filled: true,
                  fillColor: AppColors.inputBackground,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              if (newPasswordController.text.trim().isEmpty ||
                  newPasswordController.text != confirmPasswordController.text) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('As senhas não coincidem ou estão vazias.'),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Senha alterada com sucesso!'),
                  backgroundColor: AppColors.statusResolved,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryYellow,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Salvar Senha',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            height: 1.4,
            color: Color(0xFF4B5563),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Entendido',
              style: TextStyle(
                color: AppColors.primaryYellowDark,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Sair do Aplicativo', style: TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
        content: const Text(
          'Deseja realmente desconectar sua conta? Você precisará entrar novamente para enviar ou apoiar ocorrências.',
          style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancelar', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              _authViewModel.logout();
              Navigator.of(ctx).pop();
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Desconectar',
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: widget.isEmbedded ? Colors.transparent : AppColors.backgroundLight,
      appBar: widget.isEmbedded ? null : const AppHeaderBar(),
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: _authViewModel,
            builder: (context, _) {
              final user = _authViewModel.currentUser;
              final campus = user?.campus ?? 'IFPI - Campus Central';

              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 520),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
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
                              'Configurações',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textDark,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Seção: Conta & Campus
                        _buildSectionHeader('CONTA & CAMPUS'),
                        const SizedBox(height: 10),
                        _buildSettingsGroup([
                          _buildListTileItem(
                            icon: Icons.school_outlined,
                            title: 'Campus Atual',
                            subtitle: campus,
                            onTap: () => _showChangeCampusDialog(campus),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildListTileItem(
                            icon: Icons.lock_reset_rounded,
                            title: 'Alterar Senha de Acesso',
                            subtitle: 'Atualizar suas credenciais acadêmicas',
                            onTap: _showChangePasswordDialog,
                          ),
                        ]),
                        const SizedBox(height: 22),

                        // Seção: Notificações
                        _buildSectionHeader('NOTIFICAÇÕES & ALERTAS'),
                        const SizedBox(height: 10),
                        _buildSettingsGroup([
                          _buildSwitchItem(
                            icon: Icons.notifications_active_outlined,
                            title: 'Novas ocorrências no campus',
                            subtitle: 'Avisar quando houver novos relatos no seu campus',
                            value: _notifyNewIssues,
                            onChanged: (val) => setState(() => _notifyNewIssues = val),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildSwitchItem(
                            icon: Icons.check_circle_outline_rounded,
                            title: 'Atualizações de status',
                            subtitle: 'Notificar quando uma demanda for resolvida ou atualizada',
                            value: _notifyStatusChange,
                            onChanged: (val) => setState(() => _notifyStatusChange = val),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildSwitchItem(
                            icon: Icons.comment_outlined,
                            title: 'Comentários e respostas',
                            subtitle: 'Alertas de novas mensagens em suas ocorrências',
                            value: _notifyComments,
                            onChanged: (val) => setState(() => _notifyComments = val),
                          ),
                        ]),
                        const SizedBox(height: 22),

                        // Seção: Preferências e Acessibilidade
                        _buildSectionHeader('PREFERÊNCIAS & SISTEMA'),
                        const SizedBox(height: 10),
                        _buildSettingsGroup([
                          _buildSwitchItem(
                            icon: Icons.data_saver_on_rounded,
                            title: 'Economia de dados móveis',
                            subtitle: 'Carregar imagens em resolução reduzida',
                            value: _dataSaver,
                            onChanged: (val) => setState(() => _dataSaver = val),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildSwitchItem(
                            icon: Icons.volume_up_outlined,
                            title: 'Sons e vibrações',
                            subtitle: 'Feedback háptico ao votar ou relatar',
                            value: _soundAndVibration,
                            onChanged: (val) => setState(() => _soundAndVibration = val),
                          ),
                        ]),
                        const SizedBox(height: 22),

                        // Seção: Suporte & Institucional
                        _buildSectionHeader('INSTITUCIONAL & SUPORTE'),
                        const SizedBox(height: 10),
                        _buildSettingsGroup([
                          _buildListTileItem(
                            icon: Icons.gavel_rounded,
                            title: 'Termos de Uso e Conduta',
                            subtitle: 'Diretrizes éticas e de convivência do IFPI',
                            onTap: () => _showInfoDialog(
                              'Termos de Uso A+ IFPI',
                              'O aplicativo A+ IFPI é uma plataforma oficial destinada exclusivamente à comunicação de demandas estruturais e de convivência dentro dos campi do Instituto Federal do Piauí.\n\nTodo relato deve ser verídico e respeitar as normas da comunidade acadêmica.',
                            ),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildListTileItem(
                            icon: Icons.privacy_tip_outlined,
                            title: 'Política de Privacidade',
                            subtitle: 'Proteção de dados sob a LGPD',
                            onTap: () => _showInfoDialog(
                              'Política de Privacidade',
                              'Os dados dos estudantes e servidores são processados em conformidade com a LGPD e usados exclusivamente para fins de melhoria de infraestrutura e serviços do IFPI.',
                            ),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildListTileItem(
                            icon: Icons.support_agent_rounded,
                            title: 'Ouvidoria & Suporte DTI',
                            subtitle: 'suporte.aplus@ifpi.edu.br',
                            onTap: () => _showInfoDialog(
                              'Suporte e Ouvidoria',
                              'Para dúvidas técnicas, elogios ou suporte sobre a plataforma Avisa+ IFPI, entre em contato diretamente com a equipe do DTI pelo e-mail: suporte.aplus@ifpi.edu.br',
                            ),
                          ),
                          const Divider(height: 1, indent: 60),
                          _buildListTileItem(
                            icon: Icons.info_outline_rounded,
                            title: 'Sobre o Avisa + IFPI',
                            subtitle: 'Versão 1.0.0 (Build 1) • IFPI Digital',
                            trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                            onTap: () => _showInfoDialog(
                              'Avisa + IFPI',
                              'Desenvolvido para conectar a comunidade estudantil e administrativa em prol de um campus melhor e mais eficiente.',
                            ),
                          ),
                        ]),
                        const SizedBox(height: 28),

                        // Botão de Logout
                        OutlinedButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                          label: const Text(
                            'Encerrar Sessão',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Color(0xFFFECACA), width: 1.5),
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(18),
                            ),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Center(
                          child: Text(
                            'Instituto Federal de Educação, Ciência e Tecnologia do Piauí',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.textLight,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
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
                currentTab: AppNavTab.settings,
                onHomeTap: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const HomeScreen()),
                    (route) => false,
                  );
                },
                onHistoryTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const HistoryScreen()),
                  );
                },
                onPlusTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const CreateIssueScreen()),
                  );
                },
                onProfileTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (_) => const ProfileScreen()),
                  );
                },
                onSettingsTap: () {},
              ),
            ),
        ],
      ),
    );
  }



  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w800,
          color: AppColors.textLight,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildSettingsGroup(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildListTileItem({
    required IconData icon,
    required String title,
    String? subtitle,
    Widget? trailing,
    VoidCallback? onTap,
    Color iconColor = AppColors.primaryYellowDark,
  }) {
    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
      leading: Icon(icon, color: iconColor, size: 24),
      title: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: AppColors.textDark,
        ),
      ),
      subtitle: subtitle != null
          ? Text(
              subtitle,
              style: const TextStyle(fontSize: 12, color: AppColors.textMuted),
            )
          : null,
      trailing: trailing ??
          (onTap != null
              ? const Icon(
                  Icons.arrow_forward_ios_rounded,
                  size: 14,
                  color: AppColors.textLight,
                )
              : null),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color iconColor = AppColors.primaryYellowDark,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeThumbColor: AppColors.primaryYellow,
            activeTrackColor: AppColors.primaryYellow.withValues(alpha: 0.35),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
