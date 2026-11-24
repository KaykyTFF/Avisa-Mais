import 'package:flutter/material.dart';

import '../core/logging/app_logger.dart';
import '../features/auth/views/login_screen.dart';
import '../features/auth/views/register_screen.dart';
import '../features/auth/views/register_verify_screen.dart';
import '../features/auth/views/reset_password_screen.dart';
import '../features/auth/views/splash_screen.dart';
import '../features/issues/views/issue_detail_screen.dart';
import '../widgets/app_bottom_nav_bar.dart';
import 'app_routes.dart';
import 'home_screen.dart';

/// Parâmetros tipados para a rota [AppRoutes.issueDetail].
class IssueDetailRouteArgs {
  final String issueId;

  const IssueDetailRouteArgs({required this.issueId});
}

/// Parâmetros tipados para a rota [AppRoutes.registerVerify].
class RegisterVerifyRouteArgs {
  final String email;

  const RegisterVerifyRouteArgs({required this.email});
}

/// Gerenciador centralizado de geração de rotas do aplicativo (`Navigator 1.0`).
abstract final class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);
      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);
      case AppRoutes.register:
        return _buildRoute(const RegisterScreen(), settings);
      case AppRoutes.resetPassword:
        return _buildRoute(const ResetPasswordScreen(), settings);
      case AppRoutes.home:
        final userName = settings.arguments is String &&
                (settings.arguments as String).trim().isNotEmpty
            ? (settings.arguments as String).trim()
            : 'Usuário';
        return _buildRoute(HomeScreen(userName: userName), settings);
      case AppRoutes.createIssue:
        return _buildRoute(
          const HomeScreen(initialTab: AppNavTab.create),
          settings,
        );
      case AppRoutes.profile:
        return _buildRoute(
          const HomeScreen(initialTab: AppNavTab.profile),
          settings,
        );
      case AppRoutes.history:
        return _buildRoute(
          const HomeScreen(initialTab: AppNavTab.history),
          settings,
        );
      case AppRoutes.settings:
        return _buildRoute(
          const HomeScreen(initialTab: AppNavTab.settings),
          settings,
        );
      case AppRoutes.registerVerify:
        return _buildRegisterVerifyRoute(settings);
      case AppRoutes.issueDetail:
        return _buildIssueDetailRoute(settings);
      default:
        AppLogger.warning(
          'Unknown route requested: ${settings.name}',
          tag: 'AppRouter',
        );
        return _buildRoute(
          _InvalidRouteScreen(routeName: settings.name),
          settings,
        );
    }
  }

  static Route<dynamic> _buildRegisterVerifyRoute(RouteSettings settings) {
    final args = settings.arguments;
    final email = switch (args) {
      RegisterVerifyRouteArgs(:final email) => email.trim(),
      final String rawEmail => rawEmail.trim(),
      _ => '',
    };

    if (email.isEmpty || !email.contains('@')) {
      AppLogger.warning(
        'Invalid arguments for ${AppRoutes.registerVerify}',
        tag: 'AppRouter',
      );
      return _buildRoute(const RegisterScreen(), settings);
    }

    return _buildRoute(RegisterVerifyScreen(email: email), settings);
  }

  static Route<dynamic> _buildIssueDetailRoute(RouteSettings settings) {
    final args = settings.arguments;
    final issueId = switch (args) {
      IssueDetailRouteArgs(:final issueId) => issueId.trim(),
      final String rawId => rawId.trim(),
      _ => '',
    };

    if (issueId.isEmpty) {
      AppLogger.warning(
        'Invalid arguments for ${AppRoutes.issueDetail}',
        tag: 'AppRouter',
      );
      return _buildRoute(
        const _InvalidRouteScreen(routeName: AppRoutes.issueDetail),
        settings,
      );
    }

    return _buildRoute(IssueDetailScreen(issueId: issueId), settings);
  }

  static MaterialPageRoute<dynamic> _buildRoute(
    Widget page,
    RouteSettings settings,
  ) {
    return MaterialPageRoute<dynamic>(
      builder: (_) => page,
      settings: settings,
    );
  }
}

class _InvalidRouteScreen extends StatelessWidget {
  final String? routeName;

  const _InvalidRouteScreen({this.routeName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tela indisponível')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline_rounded, size: 48),
              const SizedBox(height: 12),
              Text(
                'Não foi possível abrir a rota solicitada${routeName != null ? ' ($routeName)' : ''}.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.home,
                  (route) => false,
                ),
                child: const Text('Voltar ao início'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
