import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/app_colors.dart';
import 'app_logo.dart';

/// Layout base padronizado para as telas de autenticação.
/// Apresenta o cabeçalho amarelo com listras diagonais suaves tom sobre tom,
/// a logo centralizada, botão de voltar elegante e o card branco arredondado no padrão moderno.
class AuthScaffold extends StatelessWidget {
  final Widget child;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  const AuthScaffold({
    super.key,
    required this.child,
    this.showBackButton = false,
    this.onBackPressed,
  });

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
                      // 1. Topo Amarelo com Listras Diagonais Suaves e Logo Centralizada
                      SizedBox(
                        width: double.infinity,
                        height: topPadding + 160,
                        child: Stack(
                          children: [
                            // Fundo com listras diagonais suaves (tom sobre tom)
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

                            // Botão Voltar circular elegante
                            if (showBackButton)
                              Positioned(
                                top: topPadding + 14,
                                left: 16,
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: onBackPressed ?? () => Navigator.of(context).maybePop(),
                                    borderRadius: BorderRadius.circular(24),
                                    child: Container(
                                      width: 42,
                                      height: 42,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withValues(alpha: 0.08),
                                            blurRadius: 10,
                                            offset: const Offset(0, 3),
                                          ),
                                        ],
                                      ),
                                      alignment: Alignment.center,
                                      child: const Icon(
                                        Icons.arrow_back_ios_new_rounded,
                                        size: 18,
                                        color: AppColors.textDark,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      // 2. Card Branco com Bordas Superiores Arredondadas (estilo moderno)
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
                            child: child,
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

    // 1. Fundo base amarelo plano
    final basePaint = Paint()..color = baseColor;
    canvas.drawPaint(basePaint);

    // 2. Listras diagonais em tom sobre tom suave
    final stripePaint = Paint()
      ..color = stripeColor
      ..style = PaintingStyle.fill;

    canvas.translate(size.width / 2, size.height / 2);
    // Rotação negativa faz o eixo x subir em direção ao canto superior direito
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
