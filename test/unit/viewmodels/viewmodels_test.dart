import 'dart:async';

import 'package:a_plus/core/di/app_dependencies.dart';
import 'package:a_plus/core/errors/app_exception.dart';
import 'package:a_plus/core/state/view_state.dart';
import 'package:a_plus/data/models/auth_tokens_model.dart';
import 'package:a_plus/data/models/comment_model.dart';
import 'package:a_plus/data/models/issue_model.dart';
import 'package:a_plus/data/models/user_model.dart';
import 'package:a_plus/data/repositories/auth_repository.dart';
import 'package:a_plus/data/repositories/issue_repository.dart';
import 'package:a_plus/data/services/secure_storage_service.dart';
import 'package:a_plus/features/auth/viewmodels/auth_viewmodel.dart';
import 'package:a_plus/features/issues/viewmodels/issue_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeAuthRepository implements AuthRepository {
  UserModel? _user;
  bool _loggedIn = false;
  int loginCallCount = 0;
  Completer<UserModel>? pendingLogin;
  Object? errorToThrow;

  @override
  UserModel? get currentUser => _user;

  @override
  bool get isLoggedIn => _loggedIn;

  @override
  Future<UserModel> login(String email, String password) async {
    loginCallCount++;
    if (pendingLogin != null) {
      final result = await pendingLogin!.future;
      _user = result;
      _loggedIn = true;
      return result;
    }
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    _user = UserModel(
      id: 'u_fake',
      name: 'Teste',
      email: email,
      matricula: '20260001',
      campus: 'Campus Central',
    );
    _loggedIn = true;
    return _user!;
  }

  @override
  Future<void> logout() async {
    if (errorToThrow != null) throw errorToThrow!;
    _loggedIn = false;
    _user = null;
  }

  @override
  Future<UserModel?> restoreSession() async {
    if (errorToThrow != null) throw errorToThrow!;
    return _user;
  }

  @override
  Future<void> handleSessionExpired() async {
    _loggedIn = false;
    _user = null;
  }

  @override
  void updateProfile({String? name, String? campus, String? avatarUrl}) {
    if (_user == null) return;
    _user = _user!.copyWith(name: name, campus: campus, avatarUrl: avatarUrl);
  }
}

class _FakeIssueRepository extends InMemoryIssueRepository {
  int fetchCallCount = 0;
  Completer<List<IssueModel>>? pendingFetch;
  Object? errorToThrow;

  @override
  Future<List<IssueModel>> fetchIssues({String query = ''}) async {
    fetchCallCount++;
    if (pendingFetch != null) {
      return pendingFetch!.future;
    }
    if (errorToThrow != null) {
      throw errorToThrow!;
    }
    return getIssues(query: query);
  }
}

void main() {
  group('AuthViewModel (Explicit DI & ViewState)', () {
    test('transitions Initial -> Loading -> Success on login and prevents duplicate calls', () async {
      final fakeRepo = _FakeAuthRepository();
      final completer = Completer<UserModel>();
      fakeRepo.pendingLogin = completer;

      final viewModel = AuthViewModel(repository: fakeRepo);
      final statuses = <ViewStatus>[];
      viewModel.addListener(() => statuses.add(viewModel.state.status));

      expect(viewModel.state.isInitial, isTrue);

      final firstCall = viewModel.login('aluno@ifpi.edu.br', '123456');
      final duplicateCall = viewModel.login('aluno@ifpi.edu.br', '123456');

      expect(viewModel.isLoading, isTrue);
      expect(await duplicateCall, isFalse);
      expect(fakeRepo.loginCallCount, equals(1));

      completer.complete(
        const UserModel(
          id: 'u1',
          name: 'Aluno IFPI',
          email: 'aluno@ifpi.edu.br',
          matricula: '2026001',
          campus: 'Campus Central',
        ),
      );

      expect(await firstCall, isTrue);
      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.isLoggedIn, isTrue);
      expect(statuses, equals([ViewStatus.loading, ViewStatus.success]));
      viewModel.dispose();
    });

    test('transitions to Error without getting stuck in Loading on failures', () async {
      final fakeRepo = _FakeAuthRepository()..errorToThrow = AppException.network();
      final viewModel = AuthViewModel(repository: fakeRepo);

      final ok = await viewModel.login('aluno@ifpi.edu.br', '123456');

      expect(ok, isFalse);
      expect(viewModel.isLoading, isFalse);
      expect(viewModel.state.hasError, isTrue);
      expect(viewModel.error?.isNetworkError, isTrue);
      expect(viewModel.errorMessage, contains('Sem conexão'));

      viewModel.clearError();
      expect(viewModel.state.hasError, isFalse);
      viewModel.dispose();
    });

    test('clears secure tokens on logout and expired session restore', () async {
      final storage = InMemorySecureStorageService();
      final repo = InMemoryAuthRepository(
        secureStorage: storage,
        startAuthenticated: false,
      );
      final viewModel = AuthViewModel(repository: repo);

      await viewModel.login('kayky@aluno.ifpi.edu.br', 'senha123');
      expect(await storage.readTokens(), isNotNull);

      await viewModel.logout();
      expect(await storage.readTokens(), isNull);
      expect(viewModel.isLoggedIn, isFalse);

      await storage.saveTokens(
        AuthTokensModel(
          accessToken: 'expired-access',
          refreshToken: 'expired-refresh',
          expiresAt: DateTime.now().toUtc().subtract(const Duration(minutes: 1)),
        ),
      );
      await viewModel.restoreSession();

      expect(viewModel.state.hasError, isTrue);
      expect(viewModel.error?.isSessionExpired, isTrue);
      expect(await storage.readTokens(), isNull);
      viewModel.dispose();
    });

    test('does not notify listeners after dispose()', () async {
      final fakeRepo = _FakeAuthRepository();
      final completer = Completer<UserModel>();
      fakeRepo.pendingLogin = completer;

      final viewModel = AuthViewModel(repository: fakeRepo);
      var notifications = 0;
      viewModel.addListener(() => notifications++);

      final future = viewModel.login('aluno@ifpi.edu.br', '123456');
      expect(notifications, equals(1));

      viewModel.dispose();
      completer.complete(
        const UserModel(
          id: 'u1',
          name: 'Aluno',
          email: 'aluno@ifpi.edu.br',
          matricula: '1',
          campus: 'Central',
        ),
      );

      await future;
      expect(notifications, equals(1));
    });
  });

  group('IssueViewModel (Explicit DI & ViewState)', () {
    test('transitions Initial -> Loading -> Success and blocks duplicate refresh()', () async {
      final fakeRepo = _FakeIssueRepository();
      final completer = Completer<List<IssueModel>>();
      fakeRepo.pendingFetch = completer;

      final viewModel = IssueViewModel(repository: fakeRepo);
      expect(viewModel.state.isInitial, isTrue);

      final firstRefresh = viewModel.refresh();
      final duplicateRefresh = viewModel.refresh();

      expect(viewModel.isLoading, isTrue);
      await duplicateRefresh;
      expect(fakeRepo.fetchCallCount, equals(1));

      completer.complete(fakeRepo.getIssues());
      await firstRefresh;

      expect(viewModel.state.isSuccess, isTrue);
      expect(viewModel.isLoading, isFalse);
      viewModel.dispose();
    });

    test('handles fetch errors cleanly and exposes safe errorMessage', () async {
      final fakeRepo = _FakeIssueRepository()
        ..errorToThrow = TimeoutException('internal timeout');
      final viewModel = IssueViewModel(repository: fakeRepo);

      await viewModel.refresh();

      expect(viewModel.isLoading, isFalse);
      expect(viewModel.state.hasError, isTrue);
      expect(viewModel.error?.isTimeout, isTrue);
      expect(viewModel.errorMessage, contains('demorou'));
      viewModel.dispose();
    });

    test('toggles upvote/downvote mutually exclusively and ignores blank comments', () {
      final repo = InMemoryIssueRepository(seedDefaults: false);
      final viewModel = IssueViewModel(repository: repo);
      const testId = 'vote_toggle_1';

      viewModel.addIssue(
        const IssueModel(
          id: testId,
          title: 'Ventilador parado',
          location: 'Sala 02',
          status: 'Pendente',
          upvotes: 0,
          downvotes: 0,
        ),
      );

      viewModel.toggleUpvote(testId);
      var item = viewModel.getIssue(testId)!;
      expect(item.upvotes, equals(1));
      expect(item.userUpvoted, isTrue);

      viewModel.toggleDownvote(testId);
      item = viewModel.getIssue(testId)!;
      expect(item.upvotes, equals(0));
      expect(item.downvotes, equals(1));
      expect(item.userUpvoted, isFalse);
      expect(item.userDownvoted, isTrue);

      viewModel.addComment(testId, '   ');
      expect(viewModel.getComments(testId), isEmpty);

      viewModel.addComment(testId, '  Comentário válido  ');
      final comments = viewModel.getComments(testId);
      expect(comments, hasLength(1));
      expect(comments.first, isA<CommentModel>());
      expect(comments.first.content, equals('Comentário válido'));
      viewModel.dispose();
    });
  });

  group('AppDependencies (Composition Root)', () {
    tearDown(AppDependencies.resetForTesting);

    test('creates isolated dependency graphs with injected fakes', () {
      final deps = AppDependencies.create(
        secureStorage: InMemorySecureStorageService(),
        issueRepository: InMemoryIssueRepository(seedDefaults: false),
      );

      expect(deps.issueViewModel.totalCount, equals(0));
      AppDependencies.initialize(deps);
      expect(identical(AppDependencies.instance, deps), isTrue);
    });
  });
}
