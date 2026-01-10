import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashReporter {
  static Future<void> initialize() async {
    if (kDebugMode) {
      // Disable in debug mode
      await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
      return;
    }

    // Enable in release
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);

    // Pass uncaught errors to Crashlytics
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    // Pass async errors to Crashlytics
    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };
  }

  static Future<void> recordError(
    Object error,
    StackTrace stackTrace, {
    String? reason,
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stackTrace,
      reason: reason,
      fatal: fatal,
    );
  }

  static Future<void> log(String message) async {
    await FirebaseCrashlytics.instance.log(message);
  }
}
