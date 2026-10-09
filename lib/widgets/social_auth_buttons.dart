import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class SocialAuthButtons extends StatelessWidget {
  final VoidCallback? onAppleTap;
  final VoidCallback? onGoogleTap;
  final VoidCallback? onFacebookTap;

  const SocialAuthButtons({
    super.key,
    this.onAppleTap,
    this.onGoogleTap,
    this.onFacebookTap,
  });

  void _showComingSoon(BuildContext context, String provider) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Login com $provider em desenvolvimento.'),
        backgroundColor: AppColors.textDark,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialCircle(
          icon: const Icon(Icons.apple, color: Colors.black, size: 28),
          onTap: () {
            if (onAppleTap != null) {
              onAppleTap!();
            } else {
              _showComingSoon(context, 'Apple');
            }
          },
        ),
        const SizedBox(width: 20),
        _buildSocialCircle(
          customWidget: _buildGoogleIcon(),
          onTap: () {
            if (onGoogleTap != null) {
              onGoogleTap!();
            } else {
              _showComingSoon(context, 'Google');
            }
          },
        ),
        const SizedBox(width: 20),
        _buildSocialCircle(
          icon: const Icon(Icons.facebook, color: Color(0xFF1877F2), size: 28),
          onTap: () {
            if (onFacebookTap != null) {
              onFacebookTap!();
            } else {
              _showComingSoon(context, 'Facebook');
            }
          },
        ),
      ],
    );
  }

  Widget _buildSocialCircle({
    Widget? icon,
    Widget? customWidget,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: const Color(0xFFE5E7EB), width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: customWidget ?? icon,
      ),
    );
  }

  Widget _buildGoogleIcon() {
    return SizedBox(
      width: 24,
      height: 24,
      child: CustomPaint(
        painter: _GoogleIconPainter(),
      ),
    );
  }
}

class _GoogleIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final center = Offset(w / 2, h / 2);
    final radius = w / 2;

    // Desenha o 'G' de quatro cores clássico do Google
    final paintBlue = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    final paintGreen = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.fill;
    final paintYellow = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.fill;
    final paintRed = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.fill;

    final strokeWidth = w * 0.22;
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final rect = Rect.fromCircle(center: center, radius: radius - strokeWidth / 2);

    // Amarelo (esquerda inferior e superior)
    paint.color = paintYellow.color;
    canvas.drawArc(rect, 2.35, 1.57, false, paint);

    // Vermelho (topo)
    paint.color = paintRed.color;
    canvas.drawArc(rect, 3.92, 1.57, false, paint);

    // Verde (base)
    paint.color = paintGreen.color;
    canvas.drawArc(rect, 0.78, 1.57, false, paint);

    // Azul (arco direito e traço horizontal)
    paint.color = paintBlue.color;
    canvas.drawArc(rect, -0.4, 1.18, false, paint);

    final barPaint = Paint()
      ..color = paintBlue.color
      ..style = PaintingStyle.fill;

    final barRect = RRect.fromRectAndRadius(
      Rect.fromLTRB(w * 0.45, h * 0.40, w, h * 0.60),
      const Radius.circular(2),
    );
    canvas.drawRRect(barRect, barPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
