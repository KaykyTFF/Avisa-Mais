import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/otp_code_input.dart';

class RegisterVerifyScreen extends StatefulWidget {
  final String email;

  const RegisterVerifyScreen({
    super.key,
    this.email = '',
  });

  @override
  State<RegisterVerifyScreen> createState() => _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends State<RegisterVerifyScreen> {
  String _enteredCode = '';
  bool _isLoading = false;

  void _handleConfirm() async {
    if (_enteredCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, digite os 4 dígitos do código de confirmação.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 800));

    if (mounted) {
      setState(() => _isLoading = false);
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Row(
            children: [
              Icon(Icons.check_circle, color: AppColors.primaryYellowDark, size: 28),
              SizedBox(width: 10),
              Text('Cadastro Ativado!'),
            ],
          ),
          content: const Text(
            'Sua conta foi verificada com sucesso. Faça login para continuar.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'IR PARA O LOGIN',
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
  }

  void _handleResendCode() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: const Row(
          children: [
            Icon(Icons.mail_outline, color: Colors.white),
            SizedBox(width: 10),
            Text('Novo código reenviado com sucesso!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Título de verificação
          const Text(
            'Verificar Código',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Por favor, digite o código de 4 dígitos enviado para ${widget.email.isEmpty ? "seu e-mail" : widget.email}.',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 28),

          // 4 caixas OTP de código
          OtpCodeInput(
            length: 4,
            onChanged: (code) => _enteredCode = code,
            onCompleted: (code) => _enteredCode = code,
          ),
          const SizedBox(height: 28),

          // Link Reenviar código
          Center(
            child: Column(
              children: [
                const Text(
                  'Não recebeu o código?',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: _handleResendCode,
                  child: const Text(
                    'Reenviar código',
                    style: TextStyle(
                      color: Color(0xFF8B6B00),
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 28),

          // Botão Verificar
          AppPrimaryButton(
            text: 'Verificar Código',
            isLoading: _isLoading,
            onPressed: _handleConfirm,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
