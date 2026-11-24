import 'package:flutter/material.dart';

import '../../../core/di/app_dependencies.dart';
import '../../../core/theme/app_colors.dart';
import '../../../routes/app_routes.dart';
import '../../../widgets/app_bottom_nav_bar.dart';
import '../../../widgets/app_header_bar.dart';
import '../widgets/settings/change_password_dialog.dart';
import '../widgets/settings/settings_components.dart';
import '../widgets/settings/settings_dialogs.dart';
import '../widgets/settings/settings_institutional_section.dart';

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
  final _authViewModel = AppDependencies.instance.authViewModel;

  bool _notifyNewIssues = true;
  bool _notifyStatusChange = true;
  bool _notifyComments = true;
  bool _dataSaver = false;
  bool _soundAndVibration = true;

  void _handleLogout() {
    showLogoutConfirmationDialog(
      context: context,
      onConfirm: () async {
        await _authViewModel.logout();
        if (!mounted) return;
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.login,
          (route) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          widget.isEmbedded ? Colors.transparent : AppColors.backgroundLight,
      appBar: widget.isEmbedded ? null : const AppHeaderBar(),
      body: Stack(
        children: [
          ListenableBuilder(
            listenable: _authViewModel,
            builder: (context, _) {
              final campus =
                  _authViewModel.currentUser?.campus ?? 'IFPI - Campus Central';

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
                        const SettingsSectionHeader(title: 'CONTA & CAMPUS'),
                        const SizedBox(height: 10),
                        SettingsGroupCard(
                          children: [
                            SettingsTileItem(
                              icon: Icons.school_outlined,
                              title: 'Campus Atual',
                              subtitle: campus,
                              onTap: () => showChangeCampusDialog(
                                context: context,
                                currentCampus: campus,
                                onSelected: (selected) {
                                  _authViewModel.updateProfile(
                                    campus: selected,
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Campus alterado para: $selected',
                                      ),
                                      backgroundColor: AppColors.textDark,
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ),
                            const Divider(height: 1, indent: 60),
                            SettingsTileItem(
                              icon: Icons.lock_reset_rounded,
                              title: 'Alterar Senha de Acesso',
                              subtitle: 'Atualizar suas credenciais acadêmicas',
                              onTap: () => showChangePasswordDialog(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const SettingsSectionHeader(
                          title: 'NOTIFICAÇÕES & ALERTAS',
                        ),
                        const SizedBox(height: 10),
                        SettingsGroupCard(
                          children: [
                            SettingsSwitchItem(
                              icon: Icons.notifications_active_outlined,
                              title: 'Novas ocorrências no campus',
                              subtitle:
                                  'Avisar quando houver novos relatos no seu campus',
                              value: _notifyNewIssues,
                              onChanged: (val) =>
                                  setState(() => _notifyNewIssues = val),
                            ),
                            const Divider(height: 1, indent: 60),
                            SettingsSwitchItem(
                              icon: Icons.check_circle_outline_rounded,
                              title: 'Atualizações de status',
                              subtitle:
                                  'Notificar quando uma demanda for resolvida ou atualizada',
                              value: _notifyStatusChange,
                              onChanged: (val) =>
                                  setState(() => _notifyStatusChange = val),
                            ),
                            const Divider(height: 1, indent: 60),
                            SettingsSwitchItem(
                              icon: Icons.comment_outlined,
                              title: 'Comentários e respostas',
                              subtitle:
                                  'Alertas de novas mensagens em suas ocorrências',
                              value: _notifyComments,
                              onChanged: (val) =>
                                  setState(() => _notifyComments = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const SettingsSectionHeader(
                          title: 'PREFERÊNCIAS & SISTEMA',
                        ),
                        const SizedBox(height: 10),
                        SettingsGroupCard(
                          children: [
                            SettingsSwitchItem(
                              icon: Icons.data_saver_on_rounded,
                              title: 'Economia de dados móveis',
                              subtitle:
                                  'Carregar imagens em resolução reduzida',
                              value: _dataSaver,
                              onChanged: (val) =>
                                  setState(() => _dataSaver = val),
                            ),
                            const Divider(height: 1, indent: 60),
                            SettingsSwitchItem(
                              icon: Icons.volume_up_outlined,
                              title: 'Sons e vibrações',
                              subtitle:
                                  'Feedback háptico ao votar ou relatar',
                              value: _soundAndVibration,
                              onChanged: (val) =>
                                  setState(() => _soundAndVibration = val),
                            ),
                          ],
                        ),
                        const SizedBox(height: 22),
                        const SettingsInstitutionalSection(),
                        const SizedBox(height: 28),
                        OutlinedButton.icon(
                          onPressed: _handleLogout,
                          icon: const Icon(
                            Icons.logout_rounded,
                            color: Colors.redAccent,
                          ),
                          label: const Text(
                            'Encerrar Sessão',
                            style: TextStyle(
                              color: Colors.redAccent,
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(
                              color: Color(0xFFFECACA),
                              width: 1.5,
                            ),
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
                onHomeTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
                onHistoryTap: () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.history),
                onPlusTap: () =>
                    Navigator.of(context).pushNamed(AppRoutes.createIssue),
                onProfileTap: () => Navigator.of(context)
                    .pushReplacementNamed(AppRoutes.profile),
                onSettingsTap: () {},
              ),
            ),
        ],
      ),
    );
  }
}
