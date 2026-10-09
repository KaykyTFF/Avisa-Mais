import '../models/user_model.dart';

class AuthRepository {
  static final AuthRepository _instance = AuthRepository._internal();
  factory AuthRepository() => _instance;

  AuthRepository._internal() {
    _currentUser = const UserModel(
      id: 'usr_01',
      name: 'Kayky Rocha',
      email: 'kayky.rocha@aluno.ifpi.edu.br',
      matricula: '20241014040055',
      campus: 'Campus Teresina Central',
    );
  }

  UserModel? _currentUser;
  bool _isLoggedIn = true;

  UserModel? get currentUser => _currentUser;
  bool get isLoggedIn => _isLoggedIn;

  Future<void> login(String email, String password) async {
    _isLoggedIn = true;
    _currentUser = const UserModel(
      id: 'usr_01',
      name: 'Kayky Rocha',
      email: 'kayky.rocha@aluno.ifpi.edu.br',
      matricula: '20241014040055',
      campus: 'Campus Teresina Central',
    );
  }

  Future<void> logout() async {
    _isLoggedIn = false;
  }

  void updateProfile({String? name, String? campus, String? avatarUrl}) {
    if (_currentUser == null) return;
    _currentUser = _currentUser!.copyWith(
      name: name,
      campus: campus,
      avatarUrl: avatarUrl,
    );
  }
}
