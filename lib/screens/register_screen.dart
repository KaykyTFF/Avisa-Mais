import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/app_primary_button.dart';
import '../widgets/app_text_field.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/social_auth_buttons.dart';
import 'register_verify_screen.dart';

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

  void _handleRegister() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa concordar com os Termos e Condições.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 600));
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => RegisterVerifyScreen(
              email: _emailController.text.trim(),
            ),
          ),
        );
      }
    }
  }

  void _showTermsDialog() {
    showDialog(
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
    return AuthScaffold(
      showBackButton: true,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título de boas-vindas do cadastro
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

            // Campo Nome
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

            // Campo E-mail
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

            // Campo Senha
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
                onPressed: () {
                  setState(() => _obscurePassword = !_obscurePassword);
                },
              ),
            ),
            const SizedBox(height: 16),

            // Campo Confirmar Senha
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
                onPressed: () {
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword);
                },
              ),
            ),
            const SizedBox(height: 14),

            // Checkbox Termos e Condições
            InkWell(
              onTap: () {
                setState(() => _agreeToTerms = !_agreeToTerms);
              },
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      height: 24,
                      child: Checkbox(
                        value: _agreeToTerms,
                        activeColor: const Color(0xFFECC013),
                        checkColor: const Color(0xFF1E2229),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(6),
                        ),
                        onChanged: (val) {
                          setState(() => _agreeToTerms = val ?? false);
                        },
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
                            onTap: _showTermsDialog,
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
            ),
            const SizedBox(height: 22),

            // Botão Cadastrar
            AppPrimaryButton(
              text: 'Cadastrar',
              isLoading: _isLoading,
              onPressed: _handleRegister,
            ),
            const SizedBox(height: 22),

            // Divisor "ou"
            Row(
              children: [
                const Expanded(
                  child: Divider(
                    color: Color(0xFFE5E7EB),
                    thickness: 1,
                  ),
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
                  child: Divider(
                    color: Color(0xFFE5E7EB),
                    thickness: 1,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Botões sociais
            const SocialAuthButtons(),
            const SizedBox(height: 22),

            // Rodapé: Já tem uma conta? Entrar
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
