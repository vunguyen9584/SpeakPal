import 'package:dio/dio.dart';
import 'dart:developer' as developer;

/// Logging Interceptor - Logs HTTP requests and responses
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    developer.log(
      '🚀 ${options.method} ${options.uri}',
      name: 'API Request',
    );
    developer.log(
      'Headers: ${options.headers}',
      name: 'API Request',
    );
    if (options.data != null) {
      developer.log(
        'Body: ${options.data}',
        name: 'API Request',
      );
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    developer.log(
      '✅ ${response.statusCode} ${response.requestOptions.uri}',
      name: 'API Response',
    );
    developer.log(
      'Data: ${response.data}',
      name: 'API Response',
    );

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    developer.log(
      '❌ ${err.requestOptions.method} ${err.requestOptions.uri}',
      name: 'API Error',
      error: err.error,
    );
    if (err.response != null) {
      developer.log(
        'Status: ${err.response?.statusCode}',
        name: 'API Error',
      );
      developer.log(
        'Data: ${err.response?.data}',
        name: 'API Error',
      );
    }

    handler.next(err);
  }
}

