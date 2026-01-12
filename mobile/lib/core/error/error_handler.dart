import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
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

  /// Handle error with optional UI feedback
  Future<void> handleError(
    Object error, {
    BuildContext? context,
    bool showDialog = false,
  }) async {
    final appError = error is AppError ? error : handle(error);
    
    // Log the error
    logger.error(appError.message, error: appError.cause, stackTrace: appError.stackTrace);
    
    // Show UI feedback if context provided
    if (context != null && context.mounted) {
      if (showDialog) {
        await _showErrorDialog(context, appError);
      } else {
        _showErrorSnackBar(context, appError);
      }
    }
  }

  void _showErrorSnackBar(BuildContext context, AppError error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_getUserMessage(error)),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _showErrorDialog(BuildContext context, AppError error) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(_getErrorTitle(error)),
        content: Text(_getUserMessage(error)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String _getErrorTitle(AppError error) {
    return switch (error) {
      NetworkError() => 'Connection Error',
      AuthError() => 'Authentication Error',
      ValidationError() => 'Validation Error',
      MediaError() => 'Media Error',
      ServerError() => 'Server Error',
      _ => 'Error',
    };
  }

  String _getUserMessage(AppError error) {
    if (error is MediaError && error.userMessage != null) {
      return error.userMessage!;
    }
    return error.message;
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

// Global instance for convenience
final errorHandler = ErrorHandler();
