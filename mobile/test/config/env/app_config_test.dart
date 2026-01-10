import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/config/env/app_config.dart';
import 'package:mobile/config/env/environment.dart';

void main() {
  group('AppEnvironment Tests', () {
    test('default environment is development', () {
      expect(AppEnvironment.environment, Environment.development);
      expect(AppEnvironment.isDevelopment, true);
    });

    test('setting environment works', () {
      AppEnvironment.setEnvironment(Environment.production);
      expect(AppEnvironment.environment, Environment.production);
      expect(AppEnvironment.isProduction, true);
      expect(AppEnvironment.environmentName, 'Production');
      
      // Reset for other tests
      AppEnvironment.setEnvironment(Environment.development);
    });
  });

  group('AppConfig Tests', () {
    test('apiBaseUrl returns correct default for development', () {
      AppEnvironment.setEnvironment(Environment.development);
      expect(AppConfig.apiBaseUrl, 'http://localhost:3000');
    });

    test('apiBaseUrl returns correct default for production', () {
      AppEnvironment.setEnvironment(Environment.production);
      expect(AppConfig.apiBaseUrl, 'https://api.speakpal.com');
    });

    test('apiBaseUrl returns correct default for staging', () {
      AppEnvironment.setEnvironment(Environment.staging);
      expect(AppConfig.apiBaseUrl, 'https://staging-api.speakpal.com');
    });

    test('wsUrl returns correct values', () {
      AppEnvironment.setEnvironment(Environment.development);
      expect(AppConfig.wsUrl, 'ws://localhost:3000');
      
      AppEnvironment.setEnvironment(Environment.staging);
      expect(AppConfig.wsUrl, 'wss://staging-api.speakpal.com');
      
      AppEnvironment.setEnvironment(Environment.production);
      expect(AppConfig.wsUrl, 'wss://api.speakpal.com');
    });

    test('enableLogging is true in development and staging', () {
      AppEnvironment.setEnvironment(Environment.development);
      expect(AppConfig.enableLogging, true);
      
      AppEnvironment.setEnvironment(Environment.staging);
      expect(AppConfig.enableLogging, true);
      
      AppEnvironment.setEnvironment(Environment.production);
      expect(AppConfig.enableLogging, false);
    });

    test('feature flags and app constants', () {
      expect(AppConfig.appName, 'SpeakPal AI');
      
      AppEnvironment.setEnvironment(Environment.production);
      expect(AppConfig.enableAnalytics, true);
      expect(AppConfig.enableCrashReporting, true);
      
      AppEnvironment.setEnvironment(Environment.development);
      expect(AppConfig.enableAnalytics, false);
    });

    test('audio and cache config', () {
      expect(AppConfig.audioSampleRate, 16000);
      expect(AppConfig.cacheExpiration.inHours, 24);
    });
  });
}
