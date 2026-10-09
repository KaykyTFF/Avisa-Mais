import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum AppNavTab {
  home,
  history,
  create,
  profile,
  settings,
  none,
}

class AppBottomNavBar extends StatelessWidget {
  final AppNavTab currentTab;
  final VoidCallback onHomeTap;
  final VoidCallback? onHistoryTap;
  final VoidCallback onPlusTap;
  final VoidCallback onProfileTap;
  final VoidCallback? onSettingsTap;

  const AppBottomNavBar({
    super.key,
    required this.currentTab,
    required this.onHomeTap,
    this.onHistoryTap,
    required this.onPlusTap,
    required this.onProfileTap,
    this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return SizedBox(
      height: 74 + bottomPadding,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // Barra de Fundo Amarela Padronizada (estende até o final da tela)
          Container(
            height: 60 + bottomPadding,
            padding: EdgeInsets.only(bottom: bottomPadding),
            decoration: const BoxDecoration(
              color: AppColors.primaryYellow,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(26),
                topRight: Radius.circular(26),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Bloco da Esquerda (Início e Histórico)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Ícone Home
                      IconButton(
                        tooltip: 'Início',
                        icon: Icon(
                          currentTab == AppNavTab.home
                              ? Icons.home_rounded
                              : Icons.home_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: onHomeTap,
                      ),
                      // Ícone Histórico
                      IconButton(
                        tooltip: 'Histórico',
                        icon: const Icon(
                          Icons.history_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: onHistoryTap,
                      ),
                    ],
                  ),
                ),

                // Espaço central reservado para o botão + flutuante
                const SizedBox(width: 64),

                // Bloco da Direita (Perfil e Configurações)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Ícone Perfil
                      IconButton(
                        tooltip: 'Perfil',
                        icon: Icon(
                          currentTab == AppNavTab.profile
                              ? Icons.account_circle
                              : Icons.account_circle_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: onProfileTap,
                      ),
                      // Ícone Configurações
                      IconButton(
                        tooltip: 'Configurações',
                        icon: Icon(
                          currentTab == AppNavTab.settings
                              ? Icons.settings_rounded
                              : Icons.settings_outlined,
                          color: Colors.white,
                          size: 28,
                        ),
                        onPressed: onSettingsTap,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Botão Central Flutuante Padronizado (+)
          Positioned(
            top: 0,
            child: GestureDetector(
              onTap: onPlusTap,
              child: Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: AppColors.primaryYellow,
                    width: 3.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.15),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_rounded,
                    color: AppColors.primaryYellow,
                    size: 38,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
