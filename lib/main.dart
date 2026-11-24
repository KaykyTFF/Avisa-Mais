import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'core/config/app_env.dart';
import 'core/di/app_dependencies.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/views/splash_screen.dart';
import 'routes/app_router.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AppEnv.validate();
  AppDependencies.initialize();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'A+ IFPI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const SplashScreen(),
      onGenerateRoute: AppRouter.onGenerateRoute,
    );
  }
}
