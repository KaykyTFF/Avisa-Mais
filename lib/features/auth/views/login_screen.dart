import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../widgets/auth_scaffold.dart';
import '../widgets/login/login_form.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoading = true);
    await Future<void>.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;

    setState(() => _isLoading = false);
    final userEmail = _emailController.text.trim();
    final displayUser =
        userEmail.contains('@') ? userEmail.split('@').first : userEmail;

    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
      arguments: displayUser.isEmpty ? 'Usuário' : displayUser,
    );
  }

  void _handleGuestLogin() {
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.home,
      (route) => false,
      arguments: 'Convidado',
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      showBackButton: false,
      child: LoginForm(
        formKey: _formKey,
        emailController: _emailController,
        passwordController: _passwordController,
        obscurePassword: _obscurePassword,
        isLoading: _isLoading,
        onTogglePassword: () =>
            setState(() => _obscurePassword = !_obscurePassword),
        onForgotPassword: () =>
            Navigator.of(context).pushNamed(AppRoutes.resetPassword),
        onSubmit: _handleLogin,
        onGuestLogin: _handleGuestLogin,
        onOpenRegister: () =>
            Navigator.of(context).pushNamed(AppRoutes.register),
      ),
    );
  }
}
