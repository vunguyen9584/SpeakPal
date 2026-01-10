import 'package:dio/dio.dart';

/// Error Interceptor - Handles API errors
class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    String errorMessage;

    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        errorMessage = 'Connection timeout. Please try again.';
        break;

      case DioExceptionType.badResponse:
        errorMessage = _handleStatusCode(err.response?.statusCode);

        // Try to extract error message from response
        if (err.response?.data != null) {
          try {
            final data = err.response!.data;
            if (data is Map && data.containsKey('message')) {
              errorMessage = data['message'] as String;
            } else if (data is Map && data.containsKey('error')) {
              final error = data['error'];
              if (error is String) {
                errorMessage = error;
              } else if (error is Map && error.containsKey('message')) {
                errorMessage = error['message'] as String;
              }
            }
          } catch (e) {
            // Use default error message
          }
        }
        break;

      case DioExceptionType.cancel:
        errorMessage = 'Request cancelled';
        break;

      case DioExceptionType.connectionError:
        errorMessage = 'No internet connection. Please check your network.';
        break;

      case DioExceptionType.badCertificate:
        errorMessage = 'Certificate verification failed';
        break;

      case DioExceptionType.unknown:
        errorMessage = 'An unexpected error occurred. Please try again.';
        break;
    }

    // Create custom DioException with formatted error
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
    );

    handler.next(customError);
  }

  String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Bad request. Please check your input.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access forbidden.';
      case 404:
        return 'Resource not found.';
      case 409:
        return 'Conflict. Resource already exists.';
      case 422:
        return 'Validation error. Please check your input.';
      case 429:
        return 'Too many requests. Please try again later.';
      case 500:
        return 'Server error. Please try again later.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}

