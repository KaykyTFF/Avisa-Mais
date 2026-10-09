import 'package:flutter/foundation.dart';
import '../data/models/user_model.dart';
import '../data/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  static final AuthViewModel _instance = AuthViewModel._internal();
  factory AuthViewModel({AuthRepository? repository}) {
    if (repository != null) {
      _instance._repository = repository;
    }
    return _instance;
  }

  AuthViewModel._internal() : _repository = AuthRepository();

  AuthRepository _repository;
  bool _isLoading = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _repository.isLoggedIn;
  UserModel? get currentUser => _repository.currentUser;

  Future<void> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.login(email, password);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void updateProfile({String? name, String? campus, String? avatarUrl}) {
    _repository.updateProfile(name: name, campus: campus, avatarUrl: avatarUrl);
    notifyListeners();
  }
}
