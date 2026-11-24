import 'package:a_plus/data/models/comment_model.dart';
import 'package:a_plus/data/models/issue_model.dart';
import 'package:a_plus/data/models/user_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Data Models Serialization & Immutability', () {
    test('UserModel round-trips JSON and supports copyWith', () {
      const user = UserModel(
        id: 'u1',
        name: 'Kayky Rocha',
        email: 'kayky@aluno.ifpi.edu.br',
        matricula: '2024001',
        campus: 'Campus Teresina Central',
      );

      final restored = UserModel.fromJson(user.toJson());
      expect(restored.id, equals(user.id));
      expect(restored.email, equals(user.email));

      final updated = user.copyWith(name: 'Kayky Silva');
      expect(updated.name, equals('Kayky Silva'));
      expect(updated.email, equals(user.email));
    });

    test('UserModel throws FormatException on invalid JSON', () {
      expect(
        () => UserModel.fromJson({'id': 'u1'}),
        throwsFormatException,
      );
    });

    test('IssueModel computes score and validates JSON', () {
      const issue = IssueModel(
        id: 'i1',
        title: 'Projetor sem sinal',
        location: 'Sala 10',
        status: 'Pendente',
        upvotes: 9,
        downvotes: 2,
      );

      expect(issue.score, equals(7));
      final restored = IssueModel.fromJson(issue.toJson());
      expect(restored.score, equals(7));
      expect(
        () => IssueModel.fromJson({'id': 'i1'}),
        throwsFormatException,
      );
    });

    test('CommentModel round-trips JSON and respects isOfficial default', () {
      final createdAt = DateTime.utc(2026, 11, 24, 15, 0);
      final comment = CommentModel(
        id: 'c1',
        userName: 'Suporte TI',
        userRole: 'Equipe Técnica',
        content: 'Projetor substituído.',
        createdAt: createdAt,
        isOfficial: true,
      );

      final restored = CommentModel.fromJson(comment.toJson());
      expect(restored.id, equals('c1'));
      expect(restored.isOfficial, isTrue);
      expect(restored.createdAt.toUtc(), equals(createdAt));
    });
  });
}
