import 'package:flutter/material.dart';

import '../../../../widgets/app_primary_button.dart';
import '../../../../widgets/app_text_field.dart';
import '../social_auth_buttons.dart';

class LoginForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool obscurePassword;
  final bool isLoading;
  final VoidCallback onTogglePassword;
  final VoidCallback onForgotPassword;
  final VoidCallback onSubmit;
  final VoidCallback onGuestLogin;
  final VoidCallback onOpenRegister;

  const LoginForm({
    super.key,
    required this.formKey,
    required this.emailController,
    required this.passwordController,
    required this.obscurePassword,
    required this.isLoading,
    required this.onTogglePassword,
    required this.onForgotPassword,
    required this.onSubmit,
    required this.onGuestLogin,
    required this.onOpenRegister,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text(
            'Bem-vindo(a)!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w900,
              color: Color(0xFF111827),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Entre na sua conta para continuar.',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          AppTextField(
            label: 'E-mail',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            hintText: 'Digite seu e-mail',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor, digite seu e-mail';
              }
              return null;
            },
          ),
          const SizedBox(height: 18),
          AppTextField(
            label: 'Senha',
            controller: passwordController,
            obscureText: obscurePassword,
            hintText: 'Digite sua senha',
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Por favor, digite sua senha';
              }
              if (value.length < 4) {
                return 'A senha deve ter pelo menos 4 caracteres';
              }
              return null;
            },
            suffixIcon: IconButton(
              tooltip: obscurePassword ? 'Mostrar senha' : 'Ocultar senha',
              icon: Icon(
                obscurePassword
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: const Color(0xFF6B7280),
                size: 22,
              ),
              onPressed: onTogglePassword,
            ),
          ),
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: onForgotPassword,
              child: const Text(
                'Esqueceu sua senha?',
                style: TextStyle(
                  color: Color(0xFF8B6B00),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 22),
          AppPrimaryButton(
            text: 'Entrar',
            isLoading: isLoading,
            onPressed: onSubmit,
          ),
          const SizedBox(height: 22),
          Row(
            children: [
              const Expanded(
                child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Text(
                  'ou',
                  style: TextStyle(
                    color: Colors.grey.shade500,
                    fontSize: 12.5,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              const Expanded(
                child: Divider(color: Color(0xFFE5E7EB), thickness: 1),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const SocialAuthButtons(),
          const SizedBox(height: 18),
          Center(
            child: TextButton.icon(
              onPressed: onGuestLogin,
              icon: const Icon(
                Icons.person_outline,
                size: 20,
                color: Color(0xFF6B7280),
              ),
              label: const Text(
                'Acessar como Convidado',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 18),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Ainda não tem uma conta? ',
                style: TextStyle(
                  color: Color(0xFF6B7280),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
              GestureDetector(
                onTap: onOpenRegister,
                child: const Text(
                  'Cadastre-se',
                  style: TextStyle(
                    color: Color(0xFF8B6B00),
                    fontSize: 13.5,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
