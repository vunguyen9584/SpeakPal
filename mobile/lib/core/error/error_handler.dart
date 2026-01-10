import 'package:dio/dio.dart';
import '../utils/logger_service.dart';
import 'app_error.dart';

class ErrorHandler {
  static AppError handle(Object error, [StackTrace? stackTrace]) {
    // Log the raw error first
    logger.error('Error occurred', error: error, stackTrace: stackTrace);

    if (error is AppError) {
      return error;
    }

    if (error is DioException) {
      return _handleDioError(error);
    }

    return UnknownError(
      'An unexpected error occurred',
      error,
      stackTrace,
    );
  }

  static AppError _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkError('Connection timed out', error);
      
      case DioExceptionType.connectionError:
        return NetworkError('No internet connection', error);
        
      case DioExceptionType.badResponse:
        return _handleBadResponse(error);
        
      case DioExceptionType.cancel:
        return UnknownError('Request cancelled', error);
        
      default:
        return UnknownError('Network error occurred', error);
    }
  }

  static AppError _handleBadResponse(DioException error) {
    final statusCode = error.response?.statusCode;
    final data = error.response?.data;
    
    String message = 'Server error';
    
    if (data is Map<String, dynamic>) {
      if (data['message'] is String) {
        message = data['message'];
      } else if (data['error'] is String) {
        message = data['error'];
      }
    }

    if (statusCode == 401 || statusCode == 403) {
      return AuthError(message, error);
    }
    
    if (statusCode == 422) {
      // Assuming validation errors might be in 'errors' field
      final errors = data is Map<String, dynamic> ? data['errors'] : null;
      Map<String, String>? validationErrors;
      if (errors is Map<String, dynamic>) {
        validationErrors = errors.map((key, value) => MapEntry(key, value.toString()));
      }
      return ValidationError(message, fields: validationErrors, cause: error);
    }

    return ServerError(message, statusCode: statusCode, cause: error);
  }
}
