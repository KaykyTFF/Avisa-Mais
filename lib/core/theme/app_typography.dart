import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Tokens tipográficos do Design System A+.
abstract final class AppTypography {
  static const TextStyle headlineLarge = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
    letterSpacing: -0.5,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w900,
    color: AppColors.textDark,
    letterSpacing: -0.3,
  );

  static const TextStyle titleMedium = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle labelLarge = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMuted,
    height: 1.4,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12.5,
    fontWeight: FontWeight.w500,
    color: AppColors.textMuted,
  );

  static TextTheme get textTheme => const TextTheme(
        headlineLarge: headlineLarge,
        headlineMedium: headlineMedium,
        titleMedium: titleMedium,
        labelLarge: labelLarge,
        bodyMedium: bodyMedium,
        bodySmall: bodySmall,
      );
}
