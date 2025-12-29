import 'environment.dart';

/// App Configuration
class AppConfig {
  // API Configuration
  static String get apiBaseUrl {
    switch (AppEnvironment.environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'http://localhost:3000',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://staging-api.speakpal.com',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'API_BASE_URL',
          defaultValue: 'https://api.speakpal.com',
        );
    }
  }

  // WebSocket URL
  static String get wsUrl {
    switch (AppEnvironment.environment) {
      case Environment.development:
        return const String.fromEnvironment(
          'WS_URL',
          defaultValue: 'ws://localhost:3000',
        );
      case Environment.staging:
        return const String.fromEnvironment(
          'WS_URL',
          defaultValue: 'wss://staging-api.speakpal.com',
        );
      case Environment.production:
        return const String.fromEnvironment(
          'WS_URL',
          defaultValue: 'wss://api.speakpal.com',
        );
    }
  }

  // App Configuration
  static const String appName = 'SpeakPal AI';
  static const String appVersion = '1.0.0';
  static const int buildNumber = 1;

  // Timeout Configuration
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  // Logging
  static bool get enableLogging {
    return AppEnvironment.isDevelopment || AppEnvironment.isStaging;
  }

  // Feature Flags
  static bool get enableAnalytics => AppEnvironment.isProduction;
  static bool get enableCrashReporting => AppEnvironment.isProduction;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Audio Configuration
  static const int audioSampleRate = 16000;
  static const int audioChannels = 1;
  static const String audioFormat = 'pcm16';

  // Cache Configuration
  static const Duration cacheExpiration = Duration(hours: 24);
  static const int maxCacheSize = 100; // MB
}
