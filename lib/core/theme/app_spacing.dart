import 'package:flutter/material.dart';

/// Tokens de espaçamento e raios de borda do Design System A+.
abstract final class AppSpacing {
  static const double xxs = 4;
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 24;
  static const double xl = 32;

  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: 20,
    vertical: 16,
  );
  static const EdgeInsets cardPadding = EdgeInsets.all(16);
}

/// Raios de borda padronizados do Design System A+.
abstract final class AppRadius {
  static const double sm = 8;
  static const double md = 14;
  static const double lg = 16;
  static const double xl = 24;
  static const double xxl = 28;
}
