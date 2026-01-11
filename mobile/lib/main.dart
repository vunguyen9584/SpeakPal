import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'config/router/app_router.dart';
import 'config/theme/app_theme.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/core/utils/crash_reporter.dart';
import 'package:mobile/core/utils/logger_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await CrashReporter.initialize();
  _setupLogging();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    // Wrap the app with ProviderScope to enable Riverpod
    ProviderScope(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(sharedPreferences),
      ],
      child: const MyApp(),
    ),
  );
}

void _setupLogging() {
  logger.setErrorReporter((message, error, stackTrace) {
    CrashReporter.recordError(error, stackTrace, reason: message);
  });
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = AppRouter.createRouter();

    return MaterialApp.router(
      title: 'SpeakPal AI',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}

