import 'package:flutter/material.dart';
import 'app_colors.dart';
import 'app_typography.dart';

/// Tema Material 3 centralizado do aplicativo Avisa Mais (A+ IFPI).
abstract final class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: AppColors.backgroundLight,
      textTheme: AppTypography.textTheme,
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primaryYellow,
        primary: AppColors.primaryYellow,
        surface: AppColors.backgroundLight,
        error: AppColors.error,
      ),
    );
  }
}
