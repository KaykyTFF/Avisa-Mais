import 'dart:developer' as developer;

import 'package:flutter/foundation.dart';

/// Níveis de severidade suportados pelo mecanismo centralizado de logging.
enum AppLogLevel { debug, info, warning, error }

/// Logger centralizado sem dependências externas (`dart:developer`).
///
/// - Em produção (`kReleaseMode`), suprime logs de nível `debug` e `info`.
/// - Redige automaticamente tokens JWT, Bearer tokens e campos sensíveis.
/// - Nunca exibe stack traces na interface do usuário.
abstract final class AppLogger {
  static final RegExp _jwtPattern = RegExp(
    r'eyJ[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+\.[A-Za-z0-9_-]+',
  );
  static final RegExp _bearerPattern = RegExp(
    r'Bearer\s+[A-Za-z0-9._-]+',
    caseSensitive: false,
  );
  static final RegExp _sensitivePairPattern = RegExp(
    r'(password|senha|token|refreshToken|accessToken|secret|authorization|otp)\s*[:=]\s*[^\s,;]+',
    caseSensitive: false,
  );

  /// Sanitiza uma mensagem removendo possíveis credenciais ou tokens.
  static String sanitize(String message) {
    return message
        .replaceAll(_bearerPattern, 'Bearer [REDACTED]')
        .replaceAll(_jwtPattern, '[REDACTED_JWT]')
        .replaceAllMapped(
          _sensitivePairPattern,
          (match) => '${match.group(1)}=[REDACTED]',
        );
  }

  static void debug(String message, {String tag = 'App'}) {
    _write(AppLogLevel.debug, message, tag: tag);
  }

  static void info(String message, {String tag = 'App'}) {
    _write(AppLogLevel.info, message, tag: tag);
  }

  static void warning(
    String message, {
    String tag = 'App',
    Object? error,
  }) {
    _write(AppLogLevel.warning, message, tag: tag, error: error);
  }

  static void error(
    String message, {
    String tag = 'App',
    Object? error,
    StackTrace? stackTrace,
  }) {
    _write(
      AppLogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
    );
  }

  static bool shouldLog(
    AppLogLevel level, {
    bool isRelease = kReleaseMode,
  }) {
    if (!isRelease) return true;
    return level == AppLogLevel.warning || level == AppLogLevel.error;
  }

  static void _write(
    AppLogLevel level,
    String message, {
    required String tag,
    Object? error,
    StackTrace? stackTrace,
  }) {
    if (!shouldLog(level)) return;

    final safeMessage = sanitize(message);
    final safeError = error != null ? sanitize(error.toString()) : null;

    developer.log(
      safeMessage,
      name: 'A+/$tag',
      level: _toDeveloperLevel(level),
      error: safeError,
      stackTrace: kReleaseMode ? null : stackTrace,
    );
  }

  static int _toDeveloperLevel(AppLogLevel level) {
    return switch (level) {
      AppLogLevel.debug => 500,
      AppLogLevel.info => 800,
      AppLogLevel.warning => 900,
      AppLogLevel.error => 1000,
    };
  }
}
