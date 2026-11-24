import '../../../core/errors/app_exception.dart';
import '../../../core/state/safe_change_notifier.dart';
import '../../../core/state/view_state.dart';
import '../../../data/models/user_model.dart';
import '../../../data/repositories/auth_repository.dart';

/// ViewModel de autenticação e perfil com injeção explícita de [AuthRepository]
/// e estados padronizados (`initial`, `loading`, `success`, `error`).
class AuthViewModel extends SafeChangeNotifier {
  final AuthRepository _repository;
  ViewState<UserModel?> _state;

  AuthViewModel({required AuthRepository repository})
      : _repository = repository,
        _state = ViewState<UserModel?>.initial(data: repository.currentUser);

  ViewState<UserModel?> get state => _state;
  bool get isLoading => _state.isLoading;
  bool get isLoggedIn => _repository.isLoggedIn;
  UserModel? get currentUser => _repository.currentUser;
  AppException? get error => _state.error;
  String? get errorMessage => _state.errorMessage;

  Future<bool> login(String email, String password) async {
    if (_state.isLoading) return false;

    _emit(ViewState<UserModel?>.loading(data: currentUser));
    try {
      final user = await _repository.login(email, password);
      _emit(ViewState<UserModel?>.success(user));
      return true;
    } catch (error) {
      final appError = AppException.fromError(error);
      _emit(ViewState<UserModel?>.error(appError, data: currentUser));
      return false;
    }
  }

  Future<bool> logout() async {
    if (_state.isLoading) return false;

    _emit(ViewState<UserModel?>.loading(data: currentUser));
    try {
      await _repository.logout();
      _emit(const ViewState<UserModel?>.success(null));
      return true;
    } catch (error) {
      final appError = AppException.fromError(error);
      _emit(ViewState<UserModel?>.error(appError, data: currentUser));
      return false;
    }
  }

  Future<void> restoreSession() async {
    if (_state.isLoading) return;

    _emit(ViewState<UserModel?>.loading(data: currentUser));
    try {
      final user = await _repository.restoreSession();
      _emit(ViewState<UserModel?>.success(user));
    } catch (error) {
      final appError = AppException.fromError(error);
      _emit(ViewState<UserModel?>.error(appError, data: null));
    }
  }

  Future<void> handleSessionExpired() async {
    await _repository.handleSessionExpired();
    _emit(
      ViewState<UserModel?>.error(
        AppException.sessionExpired(),
        data: null,
      ),
    );
  }

  void updateProfile({String? name, String? campus, String? avatarUrl}) {
    _repository.updateProfile(name: name, campus: campus, avatarUrl: avatarUrl);
    _emit(ViewState<UserModel?>.success(_repository.currentUser));
  }

  void clearError() {
    if (!_state.hasError) return;
    _emit(ViewState<UserModel?>.initial(data: currentUser));
  }

  void _emit(ViewState<UserModel?> nextState) {
    if (isDisposed) return;
    _state = nextState;
    safeNotifyListeners();
  }
}
