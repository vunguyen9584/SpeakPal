import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/network/interceptors/retry_interceptor.dart';
import 'package:mobile/core/network/network_info.dart';

class MockDio extends Mock implements Dio {}
class MockNetworkInfo extends Mock implements NetworkInfo {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  group('RetryInterceptor', () {
    late RetryInterceptor retryInterceptor;
    late MockDio mockDio;
    late MockNetworkInfo mockNetworkInfo;
    late MockErrorInterceptorHandler mockHandler;

    setUp(() {
      mockDio = MockDio();
      mockNetworkInfo = MockNetworkInfo();
      mockHandler = MockErrorInterceptorHandler();
      
      retryInterceptor = RetryInterceptor(
        dio: mockDio,
        networkInfo: mockNetworkInfo,
        maxRetries: 2,
        retryDelays: [Duration.zero, Duration.zero], // zero delay for tests
      );

      // Default network to connected
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      
      registerFallbackValue(RequestOptions(path: 'test'));
      registerFallbackValue(Response(requestOptions: RequestOptions(path: 'test')));
    });

    test('should retry on connection timeout', () async {
      final error = DioException(
        requestOptions: RequestOptions(path: 'test'),
        type: DioExceptionType.connectionTimeout,
      );

      when(() => mockDio.fetch(any())).thenAnswer((_) async => 
        Response(requestOptions: RequestOptions(path: 'test'), statusCode: 200)
      );

      await retryInterceptor.onError(error, mockHandler);

      verify(() => mockDio.fetch(any())).called(1);
      verify(() => mockHandler.resolve(any())).called(1);
    });

    test('should NOT retry if network is disconnected', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);
      
      final error = DioException(
        requestOptions: RequestOptions(path: 'test'),
        type: DioExceptionType.connectionTimeout,
      );

      await retryInterceptor.onError(error, mockHandler);

      verifyNever(() => mockDio.fetch(any()));
      // We expect super.onError to call handler.next(err)
      verify(() => mockHandler.next(error)).called(1);
    });

    test('should stop retrying after maxRetries', () async {
      final error = DioException(
        requestOptions: RequestOptions(path: 'test', extra: {'retries': 2}), 
        type: DioExceptionType.connectionTimeout,
      );

      await retryInterceptor.onError(error, mockHandler);

      verifyNever(() => mockDio.fetch(any()));
      verify(() => mockHandler.next(error)).called(1);
    });
    
    test('should pass through non-retriable errors', () async {
      final error = DioException(
        requestOptions: RequestOptions(path: 'test'), 
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: 'test'), statusCode: 400),
      );

      await retryInterceptor.onError(error, mockHandler);

      verifyNever(() => mockDio.fetch(any()));
      verify(() => mockHandler.next(error)).called(1);
    });

     test('should retry on 500 server error', () async {
      final error = DioException(
        requestOptions: RequestOptions(path: 'test'),
        type: DioExceptionType.badResponse,
        response: Response(requestOptions: RequestOptions(path: 'test'), statusCode: 500),
      );

      when(() => mockDio.fetch(any())).thenAnswer((_) async => 
        Response(requestOptions: RequestOptions(path: 'test'), statusCode: 200)
      );

      await retryInterceptor.onError(error, mockHandler);

      verify(() => mockDio.fetch(any())).called(1);
    });
  });
}
