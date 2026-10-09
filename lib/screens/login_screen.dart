import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../widgets/app_logo.dart';
import '../widgets/social_auth_buttons.dart';
import 'home_screen.dart';
import 'register_screen.dart';
import 'reset_password_screen.dart';

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

  void _handleLogin() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _isLoading = true);
      await Future.delayed(const Duration(milliseconds: 700));
      if (mounted) {
        setState(() => _isLoading = false);
        final userEmail = _emailController.text.trim();
        final displayUser = userEmail.contains('@')
            ? userEmail.split('@').first
            : userEmail;
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => HomeScreen(
              userName: displayUser.isEmpty ? 'Usuário' : displayUser,
            ),
          ),
        );
      }
    }
  }

  void _handleGuestLogin() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => const HomeScreen(userName: 'Convidado'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryYellow = Color(0xFFECC013);
    final topPadding = MediaQuery.of(context).padding.top;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      ),
      child: Scaffold(
        backgroundColor: primaryYellow,
        body: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // 1. Topo Amarelo com listras diagonais suaves e a Logo Centralizada
                      SizedBox(
                        width: double.infinity,
                        height: topPadding + 160,
                        child: Stack(
                          children: [
                            // Fundo com listras diagonais largas subindo da esquerda para a direita
                            Positioned.fill(
                              child: CustomPaint(
                                painter: _DiagonalStripesPainter(
                                  baseColor: primaryYellow,
                                  stripeColor: Colors.white.withValues(alpha: 0.08),
                                  stripeWidth: 52.0,
                                  gap: 64.0,
                                  angleDegrees: 30.0,
                                ),
                              ),
                            ),

                            // Logo centralizada no cabeçalho
                            Positioned(
                              top: topPadding + 16,
                              left: 0,
                              right: 0,
                              child: const Center(
                                child: AppLogo(size: 110),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // 2. Card Branco com Bordas Superiores Arredondadas (estilo da imagem)
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              topRight: Radius.circular(32),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(26, 28, 26, 28),
                            child: Form(
                              key: _formKey,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  // Título de boas-vindas
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

                                  // Campo E-mail
                                  const Text(
                                    'E-mail',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E2229),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Por favor, digite seu e-mail';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      color: Color(0xFF1E2229),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Digite seu e-mail',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: primaryYellow,
                                          width: 1.5,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.2,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.5,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 18),

                                  // Campo Senha
                                  const Text(
                                    'Senha',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF1E2229),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  TextFormField(
                                    controller: _passwordController,
                                    obscureText: _obscurePassword,
                                    validator: (value) {
                                      if (value == null || value.trim().isEmpty) {
                                        return 'Por favor, digite sua senha';
                                      }
                                      if (value.length < 4) {
                                        return 'A senha deve ter pelo menos 4 caracteres';
                                      }
                                      return null;
                                    },
                                    style: const TextStyle(
                                      fontSize: 14.5,
                                      color: Color(0xFF1E2229),
                                      fontWeight: FontWeight.w500,
                                    ),
                                    decoration: InputDecoration(
                                      hintText: 'Digite sua senha',
                                      hintStyle: const TextStyle(
                                        color: Color(0xFF9CA3AF),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                      filled: true,
                                      fillColor: const Color(0xFFF3F4F6),
                                      contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 18,
                                        vertical: 16,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: BorderSide.none,
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: primaryYellow,
                                          width: 1.5,
                                        ),
                                      ),
                                      errorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.2,
                                        ),
                                      ),
                                      focusedErrorBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(14),
                                        borderSide: const BorderSide(
                                          color: Colors.redAccent,
                                          width: 1.5,
                                        ),
                                      ),
                                      suffixIcon: IconButton(
                                        icon: Icon(
                                          _obscurePassword
                                              ? Icons.visibility_outlined
                                              : Icons.visibility_off_outlined,
                                          color: const Color(0xFF6B7280),
                                          size: 22,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            _obscurePassword = !_obscurePassword;
                                          });
                                        },
                                      ),
                                    ),
                                  ),

                                  // Link Esqueceu a Senha
                                  const SizedBox(height: 10),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: GestureDetector(
                                      onTap: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute(
                                            builder: (_) => const ResetPasswordScreen(),
                                          ),
                                        );
                                      },
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

                                  // Botão Entrar (Amarelo com texto escuro, estilo da imagem)
                                  SizedBox(
                                    width: double.infinity,
                                    height: 52,
                                    child: ElevatedButton(
                                      onPressed: _isLoading ? null : _handleLogin,
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: primaryYellow,
                                        foregroundColor: const Color(0xFF1E2229),
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(16),
                                        ),
                                      ),
                                      child: _isLoading
                                          ? const SizedBox(
                                              height: 22,
                                              width: 22,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2.5,
                                                valueColor: AlwaysStoppedAnimation<Color>(
                                                  Color(0xFF1E2229),
                                                ),
                                              ),
                                            )
                                          : const Text(
                                              'Entrar',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w800,
                                                color: Color(0xFF1E2229),
                                              ),
                                            ),
                                    ),
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
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                        ),
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

                                  // Botões sociais (mantidos da forma atual do app)
                                  const SocialAuthButtons(),
                                  const SizedBox(height: 18),

                                  // Acesso como Convidado (mantido da forma atual)
                                  Center(
                                    child: TextButton.icon(
                                      onPressed: _handleGuestLogin,
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

                                  // Rodapé: Ainda não tem uma conta? Cadastre-se
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
                                        onTap: () {
                                          Navigator.of(context).push(
                                            MaterialPageRoute(
                                              builder: (_) => const RegisterScreen(),
                                            ),
                                          );
                                        },
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
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// CustomPainter minimalista e moderno que desenha listras diagonais largas e paralelas
/// subindo da esquerda para a direita em contraste tom sobre tom sutil.
class _DiagonalStripesPainter extends CustomPainter {
  final Color baseColor;
  final Color stripeColor;
  final double stripeWidth;
  final double gap;
  final double angleDegrees;

  const _DiagonalStripesPainter({
    required this.baseColor,
    required this.stripeColor,
    this.stripeWidth = 52.0,
    this.gap = 64.0,
    this.angleDegrees = 30.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.clipRect(Offset.zero & size);

    // 1. Fundo base amarelo plano (sem gradientes ou sombras)
    final basePaint = Paint()..color = baseColor;
    canvas.drawPaint(basePaint);

    // 2. Listras diagonais em tom sobre tom suave
    final stripePaint = Paint()
      ..color = stripeColor
      ..style = PaintingStyle.fill;

    canvas.translate(size.width / 2, size.height / 2);
    // Rotação negativa no plano cartesiano do Flutter faz as linhas subirem da esquerda para a direita
    final angleRad = -angleDegrees * math.pi / 180.0;
    canvas.rotate(angleRad);

    final diagonal = math.sqrt(size.width * size.width + size.height * size.height) * 1.5;
    final step = stripeWidth + gap;

    for (double y = -diagonal; y <= diagonal; y += step) {
      canvas.drawRect(
        Rect.fromLTRB(-diagonal, y, diagonal, y + stripeWidth),
        stripePaint,
      );
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _DiagonalStripesPainter oldDelegate) {
    return oldDelegate.baseColor != baseColor ||
        oldDelegate.stripeColor != stripeColor ||
        oldDelegate.stripeWidth != stripeWidth ||
        oldDelegate.gap != gap ||
        oldDelegate.angleDegrees != angleDegrees;
  }
}
