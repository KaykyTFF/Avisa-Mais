import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../core/errors/app_exception.dart';
import '../models/auth_tokens_model.dart';

/// Contrato de armazenamento seguro de credenciais de autenticação.
///
/// Nunca utilize `SharedPreferences` ou texto aberto para tokens JWT ou senhas.
abstract interface class SecureStorageService {
  Future<void> saveTokens(AuthTokensModel tokens);
  Future<AuthTokensModel?> readTokens();
  Future<void> clearTokens();
}

/// Implementação baseada em `flutter_secure_storage` (KeyStore / Keychain).
class FlutterSecureStorageService implements SecureStorageService {
  static const String _tokensKey = 'avisa_mais_auth_tokens_v1';

  final FlutterSecureStorage _storage;

  FlutterSecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ??
            const FlutterSecureStorage(
              aOptions: AndroidOptions(),
              iOptions: IOSOptions(
                accessibility: KeychainAccessibility.first_unlock_this_device,
              ),
            );

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    try {
      final encoded = jsonEncode(tokens.toJson());
      await _storage.write(key: _tokensKey, value: encoded);
    } catch (_) {
      throw AppException.storage('Failed to persist authentication tokens.');
    }
  }

  @override
  Future<AuthTokensModel?> readTokens() async {
    try {
      final raw = await _storage.read(key: _tokensKey);
      if (raw == null || raw.isEmpty) {
        return null;
      }

      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) {
        await clearTokens();
        throw AppException.storage('Corrupted authentication tokens payload.');
      }

      return AuthTokensModel.fromJson(decoded);
    } on AppException {
      rethrow;
    } on FormatException {
      await clearTokens();
      throw AppException.storage('Corrupted authentication tokens payload.');
    } catch (_) {
      throw AppException.storage('Failed to read authentication tokens.');
    }
  }

  @override
  Future<void> clearTokens() async {
    try {
      await _storage.delete(key: _tokensKey);
    } catch (_) {
      throw AppException.storage('Failed to clear authentication tokens.');
    }
  }
}

/// Implementação em memória para testes isolados sem canais nativos.
class InMemorySecureStorageService implements SecureStorageService {
  AuthTokensModel? _tokens;

  @override
  Future<void> saveTokens(AuthTokensModel tokens) async {
    _tokens = tokens;
  }

  @override
  Future<AuthTokensModel?> readTokens() async => _tokens;

  @override
  Future<void> clearTokens() async {
    _tokens = null;
  }
}
