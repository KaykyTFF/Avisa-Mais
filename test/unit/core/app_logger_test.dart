import 'package:a_plus/core/logging/app_logger.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppLogger', () {
    test('redacts Bearer tokens, JWTs, passwords, and OTP values', () {
      const sampleJwt =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjMifQ.signature_part';

      final sanitized = AppLogger.sanitize(
        'Auth failed with Bearer abc.def.123 jwt=$sampleJwt password=minhasenha otp=1234',
      );

      expect(sanitized, isNot(contains('abc.def.123')));
      expect(sanitized, isNot(contains(sampleJwt)));
      expect(sanitized, isNot(contains('minhasenha')));
      expect(sanitized, isNot(contains('1234')));
      expect(sanitized, contains('Bearer [REDACTED]'));
      expect(sanitized, contains('[REDACTED_JWT]'));
    });

    test('filters debug and info logs in release mode while keeping warnings/errors', () {
      expect(AppLogger.shouldLog(AppLogLevel.debug, isRelease: false), isTrue);
      expect(AppLogger.shouldLog(AppLogLevel.info, isRelease: false), isTrue);

      expect(AppLogger.shouldLog(AppLogLevel.debug, isRelease: true), isFalse);
      expect(AppLogger.shouldLog(AppLogLevel.info, isRelease: true), isFalse);
      expect(AppLogger.shouldLog(AppLogLevel.warning, isRelease: true), isTrue);
      expect(AppLogger.shouldLog(AppLogLevel.error, isRelease: true), isTrue);
    });
  });
}
