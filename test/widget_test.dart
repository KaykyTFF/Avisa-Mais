import 'package:a_plus/core/di/app_dependencies.dart';
import 'package:a_plus/core/errors/app_exception.dart';
import 'package:a_plus/core/errors/error_feedback.dart';
import 'package:a_plus/data/models/issue_model.dart';
import 'package:a_plus/data/repositories/issue_repository.dart';
import 'package:a_plus/data/services/secure_storage_service.dart';
import 'package:a_plus/features/auth/views/login_screen.dart';
import 'package:a_plus/features/issues/viewmodels/issue_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  setUp(() {
    AppDependencies.initialize(
      AppDependencies.create(
        secureStorage: InMemorySecureStorageService(),
      ),
    );
  });

  tearDown(AppDependencies.resetForTesting);

  group('Widget Smoke Tests', () {
    testWidgets('Login screen renders expected fields and actions', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.text('Entrar'), findsWidgets);
      expect(find.text('E-mail'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Acessar como Convidado'), findsOneWidget);
    });

    testWidgets('ErrorFeedback displays safe user-friendly message in SnackBar', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () => ErrorFeedback.showSnackBar(
                  context,
                  AppException.sessionExpired(),
                ),
                child: const Text('Trigger'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Trigger'));
      await tester.pump();

      expect(find.text('Sua sessão expirou. Faça login novamente.'), findsOneWidget);
    });
  });

  group('Repository & ViewModel Smoke Tests', () {
    test('InMemoryIssueRepository initializes with default issues', () {
      final repo = InMemoryIssueRepository();
      expect(repo.getIssues().isNotEmpty, isTrue);
    });

    test('IssueViewModel handles adding issues and voting with explicit DI', () {
      final repo = InMemoryIssueRepository();
      final viewModel = IssueViewModel(repository: repo);
      final initialCount = viewModel.totalCount;

      const newIssue = IssueModel(
        id: 'test_1',
        title: 'Teste de Lâmpada',
        location: 'Sala 1',
        status: 'Pendente',
        upvotes: 0,
        downvotes: 0,
      );

      viewModel.addIssue(newIssue);
      expect(viewModel.totalCount, equals(initialCount + 1));

      viewModel.toggleUpvote('test_1');
      final issue = viewModel.issues.firstWhere((e) => e.id == 'test_1');
      expect(issue.upvotes, equals(1));
      expect(issue.userUpvoted, isTrue);
      viewModel.dispose();
    });
  });
}
