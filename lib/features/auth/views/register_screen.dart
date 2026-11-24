import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../../../widgets/app_primary_button.dart';
import '../../../widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/register/register_terms_checkbox.dart';
import '../widgets/social_auth_buttons.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _agreeToTerms = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa concordar com os Termos e Condições.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;

    setState(() => _isLoading = false);
    Navigator.of(context).pushNamed(
      AppRoutes.registerVerify,
      arguments: _emailController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Criar Conta',
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111827),
                letterSpacing: -0.5,
              ),
            ),
            const SizedBox(height: 6),
            const Text(
              'Preencha os dados abaixo para se cadastrar.',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 24),
            AppTextField(
              label: 'Nome',
              controller: _nameController,
              hintText: 'Digite seu nome completo',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, informe seu nome completo';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'E-mail',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              hintText: 'Digite seu e-mail',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, informe seu e-mail';
                }
                if (!value.contains('@') || !value.contains('.')) {
                  return 'Digite um e-mail válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Senha',
              controller: _passwordController,
              obscureText: _obscurePassword,
              hintText: 'Digite sua senha',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, digite uma senha';
                }
                if (value.length < 6) {
                  return 'A senha deve ter pelo menos 6 caracteres';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF6B7280),
                  size: 20,
                ),
                onPressed: () =>
                    setState(() => _obscurePassword = !_obscurePassword),
              ),
            ),
            const SizedBox(height: 16),
            AppTextField(
              label: 'Confirmar Senha',
              controller: _confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              hintText: 'Confirme sua senha',
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Por favor, confirme sua senha';
                }
                if (value != _passwordController.text) {
                  return 'As senhas não coincidem';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  _obscureConfirmPassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  color: const Color(0xFF6B7280),
                  size: 20,
                ),
                onPressed: () => setState(
                  () => _obscureConfirmPassword = !_obscureConfirmPassword,
                ),
              ),
            ),
            const SizedBox(height: 14),
            RegisterTermsCheckbox(
              value: _agreeToTerms,
              onChanged: (val) => setState(() => _agreeToTerms = val),
            ),
            const SizedBox(height: 22),
            AppPrimaryButton(
              text: 'Cadastrar',
              isLoading: _isLoading,
              onPressed: _handleRegister,
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
            const SizedBox(height: 22),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'Já tem uma conta? ',
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
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
