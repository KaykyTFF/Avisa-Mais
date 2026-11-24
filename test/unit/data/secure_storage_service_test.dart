import 'package:a_plus/core/errors/app_exception.dart';
import 'package:a_plus/data/models/auth_tokens_model.dart';
import 'package:a_plus/data/services/secure_storage_service.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';

class _FailingFlutterSecureStorage extends FlutterSecureStorage {
  const _FailingFlutterSecureStorage();

  @override
  Future<void> write({
    required String key,
    required String? value,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    throw StateError('keystore locked');
  }

  @override
  Future<String?> read({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    throw StateError('keychain unavailable');
  }

  @override
  Future<void> delete({
    required String key,
    AppleOptions? iOptions,
    AndroidOptions? aOptions,
    LinuxOptions? lOptions,
    WebOptions? webOptions,
    AppleOptions? mOptions,
    WindowsOptions? wOptions,
  }) async {
    throw StateError('delete failed');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthTokensModel', () {
    test('detects expiration and redacts tokens in toString()', () {
      final expired = AuthTokensModel(
        accessToken: 'secret-access-jwt',
        refreshToken: 'secret-refresh-jwt',
        expiresAt: DateTime.now().toUtc().subtract(const Duration(minutes: 5)),
      );
      final valid = AuthTokensModel(
        accessToken: 'valid-access-jwt',
        refreshToken: 'valid-refresh-jwt',
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
      );

      expect(expired.isExpired, isTrue);
      expect(valid.isExpired, isFalse);
      expect(expired.toString(), isNot(contains('secret-access-jwt')));
      expect(expired.toString(), isNot(contains('secret-refresh-jwt')));
      expect(expired.toString(), contains('[REDACTED]'));
    });
  });

  group('FlutterSecureStorageService', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues(<String, String>{});
    });

    test('saves, reads, and clears authentication tokens securely', () async {
      final service = FlutterSecureStorageService();
      final tokens = AuthTokensModel(
        accessToken: 'access-123',
        refreshToken: 'refresh-456',
        expiresAt: DateTime.utc(2027, 1, 1),
      );

      expect(await service.readTokens(), isNull);

      await service.saveTokens(tokens);
      final restored = await service.readTokens();
      expect(restored?.accessToken, equals('access-123'));
      expect(restored?.refreshToken, equals('refresh-456'));

      await service.clearTokens();
      expect(await service.readTokens(), isNull);
    });

    test('clears corrupted payload and throws AppException.storage', () async {
      FlutterSecureStorage.setMockInitialValues({
        'avisa_mais_auth_tokens_v1': '{not-valid-json',
      });
      final service = FlutterSecureStorageService();

      await expectLater(
        service.readTokens(),
        throwsA(
          isA<AppException>().having((e) => e.isStorageError, 'isStorageError', isTrue),
        ),
      );
      expect(await service.readTokens(), isNull);
    });

    test('converts platform read/write/delete failures into AppException.storage', () async {
      final failingService = FlutterSecureStorageService(
        storage: const _FailingFlutterSecureStorage(),
      );
      const tokens = AuthTokensModel(
        accessToken: 'a',
        refreshToken: 'b',
      );

      await expectLater(
        failingService.saveTokens(tokens),
        throwsA(
          isA<AppException>().having((e) => e.isStorageError, 'isStorageError', isTrue),
        ),
      );
      await expectLater(
        failingService.readTokens(),
        throwsA(
          isA<AppException>().having((e) => e.isStorageError, 'isStorageError', isTrue),
        ),
      );
      await expectLater(
        failingService.clearTokens(),
        throwsA(
          isA<AppException>().having((e) => e.isStorageError, 'isStorageError', isTrue),
        ),
      );
    });
  });
}
