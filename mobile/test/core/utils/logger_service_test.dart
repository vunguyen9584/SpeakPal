import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/utils/logger_service.dart';

void main() {
  group('LoggerService Tests', () {
    test('logs debug message', () {
      logger.debug('Debug message');
    });

    test('logs info message', () {
      logger.info('Info message');
    });

    test('logs warning message', () {
      logger.warning('Warning message');
    });

    test('logs warning message with error', () {
      logger.warning('Warning message', error: 'Some error');
    });

    test('logs error message with stacktrace', () {
      logger.error('Error message', error: 'Some error', stackTrace: StackTrace.current);
    });

    test('logs error message without stacktrace', () {
      logger.error('Error message', error: 'Some error');
    });
    
    test('logs fatal message', () {
       logger.fatal('Fatal error', error: 'Fatal', stackTrace: StackTrace.current);
    });
  });
}
