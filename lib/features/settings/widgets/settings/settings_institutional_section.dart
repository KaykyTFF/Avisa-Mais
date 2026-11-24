import 'package:flutter/material.dart';

import 'settings_components.dart';
import 'settings_dialogs.dart';

class SettingsInstitutionalSection extends StatelessWidget {
  const SettingsInstitutionalSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SettingsSectionHeader(title: 'INSTITUCIONAL & SUPORTE'),
        const SizedBox(height: 10),
        SettingsGroupCard(
          children: [
            SettingsTileItem(
              icon: Icons.gavel_rounded,
              title: 'Termos de Uso e Conduta',
              subtitle: 'Diretrizes éticas e de convivência do IFPI',
              onTap: () => showSettingsInfoDialog(
                context,
                title: 'Termos de Uso A+ IFPI',
                content:
                    'O aplicativo A+ IFPI é uma plataforma oficial destinada exclusivamente à comunicação de demandas estruturais e de convivência dentro dos campi do Instituto Federal do Piauí.\n\nTodo relato deve ser verídico e respeitar as normas da comunidade acadêmica.',
              ),
            ),
            const Divider(height: 1, indent: 60),
            SettingsTileItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Política de Privacidade',
              subtitle: 'Proteção de dados sob a LGPD',
              onTap: () => showSettingsInfoDialog(
                context,
                title: 'Política de Privacidade',
                content:
                    'Os dados dos estudantes e servidores são processados em conformidade com a LGPD e usados exclusivamente para fins de melhoria de infraestrutura e serviços do IFPI.',
              ),
            ),
            const Divider(height: 1, indent: 60),
            SettingsTileItem(
              icon: Icons.support_agent_rounded,
              title: 'Ouvidoria & Suporte DTI',
              subtitle: 'suporte.aplus@ifpi.edu.br',
              onTap: () => showSettingsInfoDialog(
                context,
                title: 'Suporte e Ouvidoria',
                content:
                    'Para dúvidas técnicas, elogios ou suporte sobre a plataforma Avisa+ IFPI, entre em contato diretamente com a equipe do DTI pelo e-mail: suporte.aplus@ifpi.edu.br',
              ),
            ),
            const Divider(height: 1, indent: 60),
            SettingsTileItem(
              icon: Icons.info_outline_rounded,
              title: 'Sobre o Avisa + IFPI',
              subtitle: 'Versão 1.0.0 (Build 1) • IFPI Digital',
              trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 14),
              onTap: () => showSettingsInfoDialog(
                context,
                title: 'Avisa + IFPI',
                content:
                    'Desenvolvido para conectar a comunidade estudantil e administrativa em prol de um campus melhor e mais eficiente.',
              ),
            ),
          ],
        ),
      ],
    );
  }
}
