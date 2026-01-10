import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/network/interceptors/auth_interceptor.dart';
import 'package:mobile/core/storage/secure_storage.dart';

class MockDio extends Mock implements Dio {}
class MockSecureStorage extends Mock implements SecureStorage {}
class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}
class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

void main() {
  group('AuthInterceptor Tests', () {
    late AuthInterceptor interceptor;
    late MockDio mockDio;
    late MockSecureStorage mockSecureStorage;
    late MockRequestInterceptorHandler mockRequestHandler;

    setUp(() {
      mockDio = MockDio();
      mockSecureStorage = MockSecureStorage();
      SecureStorage.setMockInstance(mockSecureStorage);
      interceptor = AuthInterceptor(mockDio);
      mockRequestHandler = MockRequestInterceptorHandler();
      
      registerFallbackValue(RequestOptions(path: ''));
      registerFallbackValue(DioException(requestOptions: RequestOptions(path: '')));
      registerFallbackValue(Response(requestOptions: RequestOptions(path: '')));
    });

    test('adds Authorization header if token exists', () async {
      final options = RequestOptions(path: '/test');
      when(() => mockSecureStorage.getAccessToken())
          .thenAnswer((_) async => 'fake_token');

      await interceptor.onRequest(options, mockRequestHandler);

      expect(options.headers['Authorization'], 'Bearer fake_token');
      verify(() => mockRequestHandler.next(options)).called(1);
    });

    test('does not add Authorization header if token is missing', () async {
      final options = RequestOptions(path: '/test');
      when(() => mockSecureStorage.getAccessToken())
          .thenAnswer((_) async => null);

      await interceptor.onRequest(options, mockRequestHandler);

      expect(options.headers.containsKey('Authorization'), false);
      verify(() => mockRequestHandler.next(options)).called(1);
    });

    test('performs token refresh on 401 response', () async {
      final mockErrorHandler = MockErrorInterceptorHandler();
      final err = DioException(
        requestOptions: RequestOptions(path: '/test'),
        response: Response(
          statusCode: 401,
          requestOptions: RequestOptions(path: '/test'),
        ),
      );

      when(() => mockSecureStorage.getRefreshToken())
          .thenAnswer((_) async => 'fake_refresh_token');
      
      when(() => mockDio.post('/auth/refresh', data: any(named: 'data')))
          .thenAnswer((_) async => Response(
                data: {
                  'accessToken': 'new_access',
                  'refreshToken': 'new_refresh'
                },
                statusCode: 200,
                requestOptions: RequestOptions(path: ''),
              ));
      
      when(() => mockSecureStorage.saveTokens(
            accessToken: 'new_access',
            refreshToken: 'new_refresh',
          )).thenAnswer((_) async => Future.value());

      when(() => mockDio.fetch(any())).thenAnswer((_) async => Response(
            data: {'success': true},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      await interceptor.onError(err, mockErrorHandler);

      verify(() => mockSecureStorage.getRefreshToken()).called(1);
      verify(() => mockDio.post('/auth/refresh', data: any(named: 'data'))).called(1);
      verify(() => mockSecureStorage.saveTokens(accessToken: 'new_access', refreshToken: 'new_refresh')).called(1);
      verify(() => mockErrorHandler.resolve(any())).called(1);
    });
  });
}
