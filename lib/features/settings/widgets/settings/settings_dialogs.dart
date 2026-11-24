import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const List<String> kDefaultCampiList = [
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

void showChangeCampusDialog({
  required BuildContext context,
  required String currentCampus,
  required ValueChanged<String> onSelected,
}) {
  showDialog<void>(
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
          itemCount: kDefaultCampiList.length,
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            final campus = kDefaultCampiList[index];
            final isSelected = campus == currentCampus;
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 2,
              ),
              title: Text(
                campus,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                  color: isSelected
                      ? AppColors.primaryYellowDark
                      : AppColors.textDark,
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
                onSelected(campus);
                Navigator.of(ctx).pop();
              },
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text(
            'Fechar',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
      ],
    ),
  );
}

void showSettingsInfoDialog(
  BuildContext context, {
  required String title,
  required String content,
}) {
  showDialog<void>(
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

void showLogoutConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) {
  showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      title: const Row(
        children: [
          Icon(Icons.logout_rounded, color: Colors.redAccent),
          SizedBox(width: 8),
          Text(
            'Sair do Aplicativo',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
        ],
      ),
      content: const Text(
        'Deseja realmente desconectar sua conta? Você precisará entrar novamente para enviar ou apoiar ocorrências.',
        style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text(
            'Cancelar',
            style: TextStyle(color: AppColors.textMuted),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            onConfirm();
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
