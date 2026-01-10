import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/network/interceptors/error_interceptor.dart';

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  group('ErrorInterceptor Tests', () {
    late ErrorInterceptor interceptor;
    late MockErrorInterceptorHandler mockHandler;

    setUp(() {
      interceptor = ErrorInterceptor();
      mockHandler = MockErrorInterceptorHandler();
      
      registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
    });

    test('handles connection timeout', () {
      final err = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionTimeout,
      );

      interceptor.onError(err, mockHandler);

      verify(() => mockHandler.next(any(that: isA<DioException>().having(
        (e) => e.error, 'error', 'Connection timeout. Please try again.'
      )))).called(1);
    });

    test('handles 401 Unauthorized response', () {
      final err = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(err, mockHandler);

      verify(() => mockHandler.next(any(that: isA<DioException>().having(
        (e) => e.error, 'error', 'Unauthorized. Please login again.'
      )))).called(1);
    });

    test('extracts message from response body', () {
      final err = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.badResponse,
        response: Response(
          statusCode: 400,
          data: {'message': 'Custom error message'},
          requestOptions: RequestOptions(path: ''),
        ),
      );

      interceptor.onError(err, mockHandler);

      verify(() => mockHandler.next(any(that: isA<DioException>().having(
        (e) => e.error, 'error', 'Custom error message'
      )))).called(1);
    });

    test('handles connection error', () {
      final err = DioException(
        requestOptions: RequestOptions(path: ''),
        type: DioExceptionType.connectionError,
      );

      interceptor.onError(err, mockHandler);

      verify(() => mockHandler.next(any(that: isA<DioException>().having(
        (e) => e.error, 'error', contains('No internet connection')
      )))).called(1);
    });

    test('handles all various status codes', () {
      final statusCodes = {
        400: 'Bad request. Please check your input.',
        403: 'Access forbidden.',
        404: 'Resource not found.',
        409: 'Conflict. Resource already exists.',
        422: 'Validation error. Please check your input.',
        429: 'Too many requests. Please try again later.',
        500: 'Server error. Please try again later.',
        503: 'Service unavailable. Please try again later.',
        999: 'An error occurred. Please try again.',
      };

      for (final entry in statusCodes.entries) {
        final err = DioException(
          requestOptions: RequestOptions(path: ''),
          type: DioExceptionType.badResponse,
          response: Response(
            statusCode: entry.key,
            requestOptions: RequestOptions(path: ''),
          ),
        );
        final mockH = MockErrorInterceptorHandler();
        interceptor.onError(err, mockH);
        verify(() => mockH.next(any(that: isA<DioException>().having(
          (e) => e.error, 'error', entry.value
        )))).called(1);
      }
    });

    test('handles cancel, badCertificate, unknown types', () {
      final types = {
        DioExceptionType.cancel: 'Request cancelled',
        DioExceptionType.badCertificate: 'Certificate verification failed',
        DioExceptionType.unknown: 'An unexpected error occurred. Please try again.',
      };

      for (final entry in types.entries) {
        final err = DioException(
          requestOptions: RequestOptions(path: ''),
          type: entry.key,
        );
        final mockH = MockErrorInterceptorHandler();
        interceptor.onError(err, mockH);
        verify(() => mockH.next(any(that: isA<DioException>().having(
          (e) => e.error, 'error', entry.value
        )))).called(1);
      }
    });
  });
}
