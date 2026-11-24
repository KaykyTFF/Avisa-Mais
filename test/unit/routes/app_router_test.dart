import 'package:a_plus/core/di/app_dependencies.dart';
import 'package:a_plus/data/services/secure_storage_service.dart';
import 'package:a_plus/features/issues/views/issue_detail_screen.dart';
import 'package:a_plus/routes/app_router.dart';
import 'package:a_plus/routes/app_routes.dart';
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

  group('AppRouter', () {
    testWidgets('navigates to valid typed issueDetail route', (
      WidgetTester tester,
    ) async {
      final route = AppRouter.onGenerateRoute(
        const RouteSettings(
          name: AppRoutes.issueDetail,
          arguments: IssueDetailRouteArgs(issueId: '1'),
        ),
      );

      expect(route, isA<MaterialPageRoute<dynamic>>());
      late Widget builtPage;
      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              builtPage = (route as MaterialPageRoute<dynamic>).builder(context);
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      expect(builtPage, isA<IssueDetailScreen>());
      expect((builtPage as IssueDetailScreen).issueId, equals('1'));
    });

    testWidgets('renders safe fallback when issueDetail arguments are invalid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.issueDetail,
                arguments: const IssueDetailRouteArgs(issueId: '   '),
              ),
              child: const Text('Open Invalid'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Invalid'));
      await tester.pumpAndSettle();

      expect(find.text('Tela indisponível'), findsOneWidget);
      expect(find.text('Voltar ao início'), findsOneWidget);
    });

    testWidgets('redirects to RegisterScreen when registerVerify email is invalid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed(
                AppRoutes.registerVerify,
                arguments: 'email-invalido',
              ),
              child: const Text('Verify'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Verify'));
      await tester.pumpAndSettle();

      expect(find.text('Criar Conta'), findsOneWidget);
    });

    testWidgets('renders safe fallback on unknown route name', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          onGenerateRoute: AppRouter.onGenerateRoute,
          home: Builder(
            builder: (context) => ElevatedButton(
              onPressed: () => Navigator.of(context).pushNamed('/nao-existe'),
              child: const Text('Unknown'),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Unknown'));
      await tester.pumpAndSettle();

      expect(find.text('Tela indisponível'), findsOneWidget);
    });
  });
}
