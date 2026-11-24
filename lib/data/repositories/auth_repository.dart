import '../../core/errors/app_exception.dart';
import '../models/auth_tokens_model.dart';
import '../models/user_model.dart';
import '../services/secure_storage_service.dart';

/// Contrato do repositório de autenticação e perfil do usuário.
abstract interface class AuthRepository {
  UserModel? get currentUser;
  bool get isLoggedIn;

  Future<UserModel> login(String email, String password);
  Future<void> logout();
  Future<UserModel?> restoreSession();
  Future<void> handleSessionExpired();
  void updateProfile({String? name, String? campus, String? avatarUrl});
}

/// Implementação local de [AuthRepository] integrada ao [SecureStorageService]
/// até a conexão HTTP definitiva com a `avisa-mais-api`.
class InMemoryAuthRepository implements AuthRepository {
  final SecureStorageService _storage;

  UserModel? _currentUser;
  bool _isLoggedIn;

  InMemoryAuthRepository({
    required SecureStorageService secureStorage,
    bool startAuthenticated = true,
  })  : _storage = secureStorage,
        _isLoggedIn = startAuthenticated,
        _currentUser = startAuthenticated ? _defaultUser : null;

  static const UserModel _defaultUser = UserModel(
    id: 'usr_01',
    name: 'Kayky Rocha',
    email: 'kayky.rocha@aluno.ifpi.edu.br',
    matricula: '20241014040055',
    campus: 'Campus Teresina Central',
  );

  @override
  UserModel? get currentUser => _currentUser;

  @override
  bool get isLoggedIn => _isLoggedIn;

  @override
  Future<UserModel> login(String email, String password) async {
    final normalizedEmail = email.trim();
    if (normalizedEmail.isEmpty || password.trim().isEmpty) {
      throw AppException.validation(
        details: const ['Informe e-mail e senha para entrar.'],
      );
    }

    try {
      final tokens = AuthTokensModel(
        accessToken: 'local_access_${DateTime.now().millisecondsSinceEpoch}',
        refreshToken: 'local_refresh_${DateTime.now().millisecondsSinceEpoch}',
        expiresAt: DateTime.now().toUtc().add(const Duration(minutes: 15)),
      );
      await _storage.saveTokens(tokens);

      _currentUser = _defaultUser.copyWith(email: normalizedEmail);
      _isLoggedIn = true;
      return _currentUser!;
    } catch (error) {
      throw AppException.fromError(error);
    }
  }

  @override
  Future<void> logout() async {
    try {
      await _storage.clearTokens();
      _isLoggedIn = false;
      _currentUser = null;
    } catch (error) {
      throw AppException.fromError(error);
    }
  }

  @override
  Future<UserModel?> restoreSession() async {
    try {
      final tokens = await _storage.readTokens();
      if (tokens == null) {
        _isLoggedIn = false;
        _currentUser = null;
        return null;
      }

      if (tokens.isExpired) {
        await _storage.clearTokens();
        _isLoggedIn = false;
        _currentUser = null;
        throw AppException.sessionExpired();
      }

      _currentUser ??= _defaultUser;
      _isLoggedIn = true;
      return _currentUser;
    } catch (error) {
      throw AppException.fromError(error);
    }
  }

  @override
  Future<void> handleSessionExpired() async {
    try {
      await _storage.clearTokens();
    } finally {
      _isLoggedIn = false;
      _currentUser = null;
    }
  }

  @override
  void updateProfile({String? name, String? campus, String? avatarUrl}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      campus: campus,
      avatarUrl: avatarUrl,
    );
  }
}
