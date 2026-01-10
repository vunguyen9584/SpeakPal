import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/services/logger_service.dart';

void main() {
  group('LoggerService Tests', () {
    test('logs debug message', () {
      LoggerService.d('Debug message');
      // debugPrint doesn't throw, we just verify it runs
    });

    test('logs info message', () {
      LoggerService.i('Info message');
    });

    test('logs warning message', () {
      LoggerService.w('Warning message');
    });

    test('logs error message with stacktrace', () {
      LoggerService.e('Error message', 'Some error', StackTrace.current);
    });

    test('logs error message without stacktrace', () {
      LoggerService.e('Error message', 'Some error');
    });
  });
}
