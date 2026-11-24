import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

Future<void> showEditProfileNameDialog({
  required BuildContext context,
  required String currentName,
  required ValueChanged<String> onSave,
}) async {
  final textController = TextEditingController(text: currentName);
  await showDialog<void>(
    context: context,
    builder: (ctx) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: const Text(
        'Editar Nome',
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: TextField(
        controller: textController,
        decoration: InputDecoration(
          labelText: 'Nome completo',
          filled: true,
          fillColor: AppColors.inputBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
        ),
        ElevatedButton(
          onPressed: () {
            final updated = textController.text.trim();
            if (updated.isNotEmpty) {
              onSave(updated);
              Navigator.of(ctx).pop();
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryYellow,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Salvar',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
  textController.dispose();
}

void showChangeProfilePhotoModal(BuildContext context) {
  showModalBottomSheet<void>(
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
              'Alterar foto de perfil',
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
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.primaryYellowDark,
                ),
              ),
              title: const Text(
                'Tirar foto agora',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foto atualizada com sucesso!')),
                );
              },
            ),
            ListTile(
              leading: const CircleAvatar(
                backgroundColor: Color(0xFFFEF3C7),
                child: Icon(
                  Icons.photo_library_rounded,
                  color: AppColors.primaryYellowDark,
                ),
              ),
              title: const Text(
                'Escolher da galeria',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Foto atualizada com sucesso!')),
                );
              },
            ),
          ],
        ),
      ),
    ),
  );
}
