import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class IssuePhotoPicker extends StatelessWidget {
  final bool hasImage;
  final ValueChanged<bool> onChanged;

  const IssuePhotoPicker({
    super.key,
    required this.hasImage,
    required this.onChanged,
  });

  void _openPickerModal(BuildContext context) {
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
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.primaryYellowDark,
                  ),
                ),
                title: const Text(
                  'Tirar foto com a câmera',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                onTap: () {
                  Navigator.of(ctx).pop();
                  onChanged(true);
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
                  onChanged(true);
                },
              ),
              if (hasImage)
                ListTile(
                  leading: const CircleAvatar(
                    backgroundColor: Color(0xFFFEE2E2),
                    child: Icon(Icons.delete_outline, color: Colors.redAccent),
                  ),
                  title: const Text(
                    'Remover foto',
                    style: TextStyle(
                      color: Colors.redAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  onTap: () {
                    Navigator.of(ctx).pop();
                    onChanged(false);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _openPickerModal(context),
      child: Container(
        height: 170,
        decoration: BoxDecoration(
          color: hasImage ? const Color(0xFFFEF9C3) : const Color(0xFFEFEFEF),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: hasImage ? AppColors.primaryYellow : Colors.grey.shade300,
            width: hasImage ? 2 : 1.2,
          ),
        ),
        child: Center(
          child: hasImage
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
    );
  }
}
