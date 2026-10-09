import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/otp_code_input.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _emailController = TextEditingController();
  final _emailFormKey = GlobalKey<FormState>();

  bool _codeSent = false;
  String _enteredCode = '';
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendCode() async {
    if (_emailFormKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() {
          _isLoading = false;
          _codeSent = true;
        });
      }
    }
  }

  void _handleVerifyCode() async {
    if (_enteredCode.length < 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, informe os 4 dígitos do código recebido.'),
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
              Text('Código Validado!'),
            ],
          ),
          content: const Text(
            'Código confirmado com sucesso. Um link seguro para redefinição de senha foi enviado para seu e-mail.',
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
              child: const Text(
                'VOLTAR AO LOGIN',
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
            Text('Código reenviado com sucesso!'),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      onBackPressed: () {
        if (_codeSent) {
          setState(() => _codeSent = false);
        } else {
          Navigator.of(context).pop();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!_codeSent) ...[
            // Etapa 1: Enviar email
            const Text(
              'Recuperar Senha',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Digite seu e-mail para receber o código de verificação.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            Form(
              key: _emailFormKey,
              child: AppTextField(
                label: 'E-mail',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                hintText: 'Digite seu e-mail',
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Por favor, digite seu e-mail';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(height: 24),
            AppPrimaryButton(
              text: 'Enviar Código',
              isLoading: _isLoading,
              onPressed: _handleSendCode,
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Lembrou a senha? ',
                  style: TextStyle(
                    color: Color(0xFF6B7280),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Entrar',
                    style: TextStyle(
                      color: Color(0xFF8B6B00),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
          ] else ...[
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
              'Digite o código enviado para ${_emailController.text.trim().isEmpty ? "seu e-mail" : _emailController.text.trim()}.',
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
              onPressed: _handleVerifyCode,
            ),
            const SizedBox(height: 24),
          ],
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
