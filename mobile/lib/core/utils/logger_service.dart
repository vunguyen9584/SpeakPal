import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

enum LogLevel {
  debug,
  info,
  warning,
  error,
  fatal,
}

class LoggerService {
  static const String _defaultTag = 'SpeakPal';

  // Singleton
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;
  LoggerService._internal();

  // Optional: Sentry/Crashlytics integration
  Function(String message, Object error, StackTrace stackTrace)? _errorReporter;

  void setErrorReporter(Function(String, Object, StackTrace) reporter) {
    _errorReporter = reporter;
  }

  void debug(String message, {String? tag, Object? data}) {
    if (kDebugMode) {
      _log(LogLevel.debug, message, tag: tag, data: data);
    }
  }

  void info(String message, {String? tag, Object? data}) {
    _log(LogLevel.info, message, tag: tag, data: data);
  }

  void warning(String message, {String? tag, Object? error, Object? data}) {
    _log(LogLevel.warning, message, tag: tag, error: error, data: data);
  }

  void error(
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    _log(
      LogLevel.error,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );

    // Report to crash analytics
    if (error != null && stackTrace != null && _errorReporter != null) {
      _errorReporter!(message, error, stackTrace);
    }
  }

  void fatal(
    String message, {
    String? tag,
    required Object error,
    required StackTrace stackTrace,
    Object? data,
  }) {
    _log(
      LogLevel.fatal,
      message,
      tag: tag,
      error: error,
      stackTrace: stackTrace,
      data: data,
    );

    // Always report fatal errors
    _errorReporter?.call(message, error, stackTrace);
  }

  void _log(
    LogLevel level,
    String message, {
    String? tag,
    Object? error,
    StackTrace? stackTrace,
    Object? data,
  }) {
    final effectiveTag = tag ?? _defaultTag;
    final emoji = _getEmoji(level);
    final logLevel = _getLogLevel(level);

    final buffer = StringBuffer();
    buffer.write('[$emoji ${level.name.toUpperCase()}] $message');

    if (data != null) {
      buffer.write('\n📦 Data: $data');
    }

    developer.log(
      buffer.toString(),
      name: effectiveTag,
      level: logLevel,
      error: error,
      stackTrace: stackTrace,
    );
  }

  String _getEmoji(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return '🐛';
      case LogLevel.info:
        return 'ℹ️';
      case LogLevel.warning:
        return '⚠️';
      case LogLevel.error:
        return '🔥';
      case LogLevel.fatal:
        return '💥';
    }
  }

  int _getLogLevel(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.fatal:
        return 1200;
    }
  }
}

// Convenience global instances
final logger = LoggerService();
