import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

const List<String> kDefaultCampusSectors = [
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

class IssueSectorPicker extends StatelessWidget {
  final String? selectedSector;
  final ValueChanged<String> onSelected;

  const IssueSectorPicker({
    super.key,
    required this.selectedSector,
    required this.onSelected,
  });

  void _openPicker(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (ctx) => Container(
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
                itemCount: kDefaultCampusSectors.length,
                separatorBuilder: (_, _) => Divider(
                  height: 1,
                  color: Colors.grey.shade200,
                ),
                itemBuilder: (_, index) {
                  final sector = kDefaultCampusSectors[index];
                  final isSelected = selectedSector == sector;
                  return ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 4,
                    ),
                    title: Text(
                      sector,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight:
                            isSelected ? FontWeight.w700 : FontWeight.w500,
                        color: isSelected
                            ? AppColors.primaryYellowDark
                            : AppColors.textDark,
                      ),
                    ),
                    trailing: isSelected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryYellow,
                          )
                        : const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 16,
                            color: Colors.grey,
                          ),
                    onTap: () {
                      onSelected(sector);
                      Navigator.of(ctx).pop();
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _openPicker(context),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.inputBackground,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selectedSector != null
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
                selectedSector ?? 'Selecione o setor e sala',
                style: TextStyle(
                  fontSize: 14,
                  color: selectedSector != null
                      ? AppColors.textDark
                      : AppColors.textLight,
                  fontWeight: selectedSector != null
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
    );
  }
}
