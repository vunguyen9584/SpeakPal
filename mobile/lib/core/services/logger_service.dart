import 'package:flutter/foundation.dart';

class LoggerService {
  static const String _tag = '[SpeakPal]';

  static void d(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('$_tag 🐛 $message');
    if (error != null) _printError(error, stackTrace);
  }

  static void i(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('$_tag ℹ️ $message');
    if (error != null) _printError(error, stackTrace);
  }

  static void w(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('$_tag ⚠️ $message');
    if (error != null) _printError(error, stackTrace);
  }

  static void e(String message, [dynamic error, StackTrace? stackTrace]) {
    debugPrint('$_tag ❌ $message');
    if (error != null) _printError(error, stackTrace);
  }

  static void _printError(dynamic error, StackTrace? stackTrace) {
    debugPrint('  Error: $error');
    if (stackTrace != null) {
      debugPrint('  StackTrace: $stackTrace');
    }
  }
}
