import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'app_exception.dart';

/// Utilitário padronizado para exibição segura de mensagens de erro na UI.
abstract final class ErrorFeedback {
  static void showSnackBar(BuildContext context, AppException error) {
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger == null) return;

    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(error.userMessage),
          backgroundColor: AppColors.error,
          behavior: SnackBarBehavior.floating,
        ),
      );
  }
}
