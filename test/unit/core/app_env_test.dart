import 'package:a_plus/core/config/app_env.dart';
import 'package:a_plus/core/network/api_endpoints.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppEnv & ApiEndpoints', () {
    test('parses development, staging, and production environments safely', () {
      expect(AppEnv.parseEnvironment('development'), equals(AppEnvironment.development));
      expect(AppEnv.parseEnvironment('staging'), equals(AppEnvironment.staging));
      expect(AppEnv.parseEnvironment('homologacao'), equals(AppEnvironment.staging));
      expect(AppEnv.parseEnvironment('production'), equals(AppEnvironment.production));
      expect(AppEnv.parseEnvironment('unknown'), equals(AppEnvironment.development));
    });

    test('validates required environment settings and enforces HTTPS in production', () {
      expect(
        () => AppEnv.validate(
          envOverride: 'development',
          baseUrlOverride: 'http://10.0.2.2:3000',
          timeoutSecondsOverride: 15,
        ),
        returnsNormally,
      );

      expect(
        () => AppEnv.validate(
          envOverride: 'production',
          baseUrlOverride: 'https://api.avisamais.ifpi.edu.br',
          timeoutSecondsOverride: 15,
        ),
        returnsNormally,
      );

      expect(
        () => AppEnv.validate(
          envOverride: 'production',
          baseUrlOverride: 'http://api.avisamais.ifpi.edu.br',
        ),
        throwsStateError,
      );

      expect(
        () => AppEnv.validate(
          envOverride: 'development',
          baseUrlOverride: '',
        ),
        throwsStateError,
      );

      expect(
        () => AppEnv.validate(
          envOverride: 'development',
          baseUrlOverride: 'http://localhost:3000',
          timeoutSecondsOverride: 0,
        ),
        throwsStateError,
      );
    });

    test('normalizes trailing slashes in base URL', () {
      expect(
        AppEnv.normalizeBaseUrl('http://localhost:3000///'),
        equals('http://localhost:3000'),
      );
      expect(
        AppEnv.normalizeBaseUrl(' https://api.avisamais.ifpi.edu.br/ '),
        equals('https://api.avisamais.ifpi.edu.br'),
      );
    });

    test('builds versioned URI with and without query parameters', () {
      final simpleUri = AppEnv.buildUri(
        ApiEndpoints.healthReady,
        baseUrlOverride: 'http://10.0.2.2:3000/',
      );
      expect(
        simpleUri.toString(),
        equals('http://10.0.2.2:3000/api/v1/health/ready'),
      );

      final paginatedUri = AppEnv.buildUri(
        ApiEndpoints.issues,
        baseUrlOverride: 'http://localhost:3000',
        queryParameters: {'page': '1', 'limit': '20'},
      );
      expect(
        paginatedUri.toString(),
        equals('http://localhost:3000/api/v1/issues?page=1&limit=20'),
      );
    });

    test('keeps all dynamic endpoints under /api/v1 prefix', () {
      expect(ApiEndpoints.issueById('abc'), equals('/api/v1/issues/abc'));
      expect(ApiEndpoints.issueStatus('abc'), equals('/api/v1/issues/abc/status'));
      expect(ApiEndpoints.issueVotes('abc'), equals('/api/v1/issues/abc/votes'));
      expect(
        ApiEndpoints.issueComments('abc'),
        equals('/api/v1/issues/abc/comments'),
      );
      expect(
        ApiEndpoints.campusSectors('c1'),
        equals('/api/v1/campuses/c1/sectors'),
      );
    });
  });
}
