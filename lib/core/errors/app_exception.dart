import 'dart:async';

import 'error_message_mapper.dart';

/// Exceção padronizada do app alinhada ao contrato `ApiErrorResponse`
/// retornado pela `avisa-mais-api` (`statusCode`, `code`, `message`, `details`, `requestId`).
class AppException implements Exception {
  final int statusCode;
  final String code;
  final String message;
  final List<String> details;
  final String? requestId;

  const AppException({
    required this.statusCode,
    required this.code,
    required this.message,
    this.details = const [],
    this.requestId,
  });

  bool get isNetworkError => code == 'NETWORK_ERROR';
  bool get isTimeout => code == 'REQUEST_TIMEOUT';
  bool get isUnauthorized => statusCode == 401;
  bool get isSessionExpired => code == 'SESSION_EXPIRED';
  bool get isForbidden => statusCode == 403;
  bool get isNotFound => statusCode == 404;
  bool get isConflict => statusCode == 409;
  bool get isValidationError => statusCode == 400 && code == 'VALIDATION_ERROR';
  bool get isRateLimited => statusCode == 429;
  bool get isServerError => statusCode >= 500;
  bool get isStorageError => code == 'SECURE_STORAGE_ERROR';

  /// Mensagem segura e amigável pronta para exibição na interface.
  String get userMessage => ErrorMessageMapper.toUserMessage(this);

  /// Faz parse seguro do JSON `ApiErrorResponse` vindo da API.
  factory AppException.fromApiJson(
    Map<String, dynamic> json, {
    int fallbackStatusCode = 500,
  }) {
    final statusCode = json['statusCode'] is int
        ? json['statusCode'] as int
        : fallbackStatusCode;
    final code = json['code'] is String && (json['code'] as String).isNotEmpty
        ? json['code'] as String
        : 'UNKNOWN_ERROR';
    final message =
        json['message'] is String && (json['message'] as String).isNotEmpty
            ? json['message'] as String
            : 'Unexpected error response from server.';
    final rawDetails = json['details'];
    final details = rawDetails is List
        ? rawDetails.map((item) => item.toString()).toList(growable: false)
        : const <String>[];
    final requestId = json['requestId'] is String
        ? json['requestId'] as String
        : null;

    return AppException(
      statusCode: statusCode,
      code: code,
      message: message,
      details: details,
      requestId: requestId,
    );
  }

  /// Converte qualquer exceção desconhecida em uma [AppException] segura,
  /// sem vazar mensagens técnicas ou stack traces para a UI.
  factory AppException.fromError(Object error) {
    if (error is AppException) {
      return error;
    }
    if (error is TimeoutException) {
      return AppException.timeout();
    }
    if (error is FormatException) {
      return const AppException(
        statusCode: 500,
        code: 'INVALID_RESPONSE_FORMAT',
        message: 'Invalid payload format received.',
      );
    }
    return AppException.serverError();
  }

  factory AppException.network([
    String message = 'Network connection failure.',
  ]) {
    return AppException(
      statusCode: 0,
      code: 'NETWORK_ERROR',
      message: message,
    );
  }

  factory AppException.timeout([
    String message = 'Request timed out.',
  ]) {
    return AppException(
      statusCode: 408,
      code: 'REQUEST_TIMEOUT',
      message: message,
    );
  }

  factory AppException.unauthorized([
    String message = 'Authentication required.',
  ]) {
    return AppException(
      statusCode: 401,
      code: 'UNAUTHORIZED',
      message: message,
    );
  }

  factory AppException.sessionExpired([
    String message = 'Session expired.',
  ]) {
    return AppException(
      statusCode: 401,
      code: 'SESSION_EXPIRED',
      message: message,
    );
  }

  factory AppException.validation({
    String message = 'Validation failed.',
    List<String> details = const [],
  }) {
    return AppException(
      statusCode: 400,
      code: 'VALIDATION_ERROR',
      message: message,
      details: details,
    );
  }

  factory AppException.notFound([
    String message = 'Resource not found.',
  ]) {
    return AppException(
      statusCode: 404,
      code: 'RESOURCE_NOT_FOUND',
      message: message,
    );
  }

  factory AppException.serverError([
    String message = 'Unexpected server error.',
  ]) {
    return AppException(
      statusCode: 500,
      code: 'INTERNAL_SERVER_ERROR',
      message: message,
    );
  }

  factory AppException.storage([
    String message = 'Secure storage operation failed.',
  ]) {
    return AppException(
      statusCode: 0,
      code: 'SECURE_STORAGE_ERROR',
      message: message,
    );
  }

  @override
  String toString() => 'AppException($statusCode, $code, requestId: $requestId)';
}
