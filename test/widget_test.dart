import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:a_plus/screens/login_screen.dart';
import 'package:a_plus/data/models/issue_model.dart';
import 'package:a_plus/data/repositories/issue_repository.dart';
import 'package:a_plus/viewmodels/issue_viewmodel.dart';

void main() {
  group('Smoke Tests', () {
    testWidgets('Login screen smoke test', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: LoginScreen()));

      expect(find.text('Entrar'), findsWidgets);
      expect(find.text('Email'), findsOneWidget);
      expect(find.text('Senha'), findsOneWidget);
      expect(find.text('Acessar como Convidado'), findsOneWidget);
    });
  });

  group('Architecture & Repository Unit Tests', () {
    test('IssueRepository initializes with default issues', () {
      final repo = IssueRepository();
      expect(repo.getIssues().isNotEmpty, isTrue);
    });

    test('IssueViewModel handles adding issues and voting', () {
      final viewModel = IssueViewModel();
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
    });

    test('IssueModel serialization and deserialization', () {
      const issue = IssueModel(
        id: '10',
        title: 'Cadeira quebrada',
        location: 'Auditório',
        status: 'Pendente',
        upvotes: 3,
        downvotes: 0,
      );

      final json = issue.toJson();
      final deserialized = IssueModel.fromJson(json);

      expect(deserialized.id, equals(issue.id));
      expect(deserialized.title, equals(issue.title));
      expect(deserialized.upvotes, equals(3));
    });
  });
}
