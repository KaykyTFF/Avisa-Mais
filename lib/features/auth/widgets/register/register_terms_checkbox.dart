import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

class RegisterTermsCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const RegisterTermsCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  void _showTermsDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Termos e Condições'),
        content: const SingleChildScrollView(
          child: Text(
            'Ao criar sua conta no aplicativo A+, você concorda em utilizar a plataforma para relatar demandas, melhorias e acompanhar o progresso de soluções institucionais de forma respeitosa e ética, em conformidade com as diretrizes do IFPI.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'ENTENDI',
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

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onChanged(!value),
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: value,
                activeColor: const Color(0xFFECC013),
                checkColor: const Color(0xFF1E2229),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                onChanged: (val) => onChanged(val ?? false),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Wrap(
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  const Text(
                    'Concordo com os ',
                    style: TextStyle(
                      fontSize: 13,
                      color: Color(0xFF374151),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _showTermsDialog(context),
                    child: const Text(
                      'Termos e Condições',
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF8B6B00),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
