import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/network/interceptors/logging_interceptor.dart';

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  late LoggingInterceptor interceptor;

  setUpAll(() {
    registerFallbackValue(RequestOptions(path: ''));
    registerFallbackValue(Response(requestOptions: RequestOptions(path: ''), statusCode: 200));
    registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
  });

  setUp(() {
    interceptor = LoggingInterceptor();
  });

  group('LoggingInterceptor Tests', () {
    test('onRequest logs and calls next', () {
      final options = RequestOptions(
        path: '/test',
        method: 'GET',
        headers: {'auth': 'token'},
        data: {'key': 'value'},
      );
      final handler = MockRequestInterceptorHandler();

      interceptor.onRequest(options, handler);

      verify(() => handler.next(options)).called(1);
    });

    test('onResponse logs and calls next', () {
      final response = Response(
        requestOptions: RequestOptions(path: '/test'),
        statusCode: 200,
        data: {'success': true},
      );
      final handler = MockResponseInterceptorHandler();

      interceptor.onResponse(response, handler);

      verify(() => handler.next(response)).called(1);
    });

    test('onError logs and calls next', () {
      final err = DioException(
        requestOptions: RequestOptions(path: '/test', method: 'GET'),
        error: 'Timeout',
        response: Response(
          requestOptions: RequestOptions(path: '/test'),
          statusCode: 500,
          data: 'Internal error',
        ),
      );
      final handler = MockErrorInterceptorHandler();

      interceptor.onError(err, handler);

      verify(() => handler.next(err)).called(1);
    });
  });
}
