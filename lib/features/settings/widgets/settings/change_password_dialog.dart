import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

Future<void> showChangePasswordDialog(BuildContext context) async {
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  await showDialog<void>(
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
            _PasswordField(
              controller: currentPasswordController,
              label: 'Senha atual',
              icon: Icons.lock_outline_rounded,
            ),
            const SizedBox(height: 12),
            _PasswordField(
              controller: newPasswordController,
              label: 'Nova senha',
              icon: Icons.key_rounded,
            ),
            const SizedBox(height: 12),
            _PasswordField(
              controller: confirmPasswordController,
              label: 'Confirmar nova senha',
              icon: Icons.check_rounded,
            ),
          ],
        ),
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

  currentPasswordController.dispose();
  newPasswordController.dispose();
  confirmPasswordController.dispose();
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;

  const _PasswordField({
    required this.controller,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, size: 20),
        filled: true,
        fillColor: AppColors.inputBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
