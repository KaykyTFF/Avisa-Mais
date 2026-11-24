import 'dart:async';

import 'package:a_plus/core/errors/app_exception.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppException & ErrorMessageMapper (ApiErrorResponse contract)', () {
    test('parses validation error payload returned by avisa-mais-api', () {
      final error = AppException.fromApiJson({
        'statusCode': 400,
        'code': 'VALIDATION_ERROR',
        'message': 'Validation failed for request payload.',
        'details': ['email must be an email', 'password is too short'],
        'requestId': 'req-001',
      });

      expect(error.statusCode, equals(400));
      expect(error.code, equals('VALIDATION_ERROR'));
      expect(error.isValidationError, isTrue);
      expect(error.userMessage, equals('email must be an email'));
      expect(error.requestId, equals('req-001'));
    });

    test('maps connection, timeout, auth, session expired, not found, and server errors', () {
      final network = AppException.network();
      expect(network.isNetworkError, isTrue);
      expect(network.userMessage, contains('Sem conexão'));

      final timeout = AppException.fromError(TimeoutException('raw socket timeout'));
      expect(timeout.isTimeout, isTrue);
      expect(timeout.userMessage, contains('demorou'));
      expect(timeout.userMessage, isNot(contains('raw socket')));

      final unauthorized = AppException.unauthorized();
      expect(unauthorized.isUnauthorized, isTrue);
      expect(unauthorized.userMessage, contains('Autenticação necessária'));

      final sessionExpired = AppException.sessionExpired();
      expect(sessionExpired.isSessionExpired, isTrue);
      expect(sessionExpired.isUnauthorized, isTrue);
      expect(sessionExpired.userMessage, contains('sessão expirou'));

      final notFound = AppException.notFound();
      expect(notFound.isNotFound, isTrue);
      expect(notFound.userMessage, contains('não foi encontrado'));

      final conflict = AppException.fromApiJson({
        'statusCode': 409,
        'code': 'RESOURCE_CONFLICT',
        'message': 'Unique constraint failed on users_email_key',
      });
      expect(conflict.isConflict, isTrue);
      expect(conflict.userMessage, isNot(contains('users_email_key')));

      final throttled = AppException.fromApiJson({
        'statusCode': 429,
        'code': 'TOO_MANY_REQUESTS',
        'message': 'ThrottlerException',
      });
      expect(throttled.isRateLimited, isTrue);
      expect(throttled.userMessage, contains('Muitas tentativas'));
    });

    test('never leaks raw internal exception messages or stack traces to UI', () {
      final unknown = AppException.fromError(
        StateError('SELECT * FROM users WHERE password_hash = secret'),
      );

      expect(unknown.isServerError, isTrue);
      expect(unknown.userMessage, isNot(contains('SELECT')));
      expect(unknown.userMessage, isNot(contains('password_hash')));
      expect(unknown.toString(), isNot(contains('password_hash')));
    });

    test('falls back safely when API error JSON is incomplete or malformed', () {
      final error = AppException.fromApiJson(
        const <String, dynamic>{},
        fallbackStatusCode: 503,
      );

      expect(error.statusCode, equals(503));
      expect(error.code, equals('UNKNOWN_ERROR'));
      expect(error.isServerError, isTrue);
      expect(error.userMessage, contains('erro inesperado no servidor'));
    });
  });
}
