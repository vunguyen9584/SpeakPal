/// Base class for all application errors
sealed class AppError {
  final String message;
  final dynamic cause;
  final StackTrace? stackTrace;

  const AppError(this.message, [this.cause, this.stackTrace]);
  
  @override
  String toString() => 'AppError: $message, Cause: $cause';
}

/// Network related errors (No internet, timeout, etc)
class NetworkError extends AppError {
  const NetworkError(super.message, [super.cause, super.stackTrace]);
}

/// Server side errors (5xx, 4xx, invalid response)
class ServerError extends AppError {
  final int? statusCode;
  const ServerError(String message, {this.statusCode, dynamic cause, StackTrace? stackTrace}) 
      : super(message, cause, stackTrace);
}

/// Authentication/Authorization errors
class AuthError extends AppError {
  const AuthError(super.message, [super.cause, super.stackTrace]);
}

/// Data parsing/mapping errors
class ParseError extends AppError {
  const ParseError(super.message, [super.cause, super.stackTrace]);
}

/// Local storage/cache errors
class CacheError extends AppError {
  const CacheError(super.message, [super.cause, super.stackTrace]);
}

/// Input validation errors
class ValidationError extends AppError {
  final Map<String, String>? fields;
  const ValidationError(String message, {this.fields, dynamic cause, StackTrace? stackTrace})
      : super(message, cause, stackTrace);
}

/// Unknown/Unexpected errors
class UnknownError extends AppError {
  const UnknownError(super.message, [super.cause, super.stackTrace]);
}

/// Audio/Media related errors
class MediaError extends AppError {
  final String? userMessage;
  const MediaError(String message, {this.userMessage, dynamic originalError, StackTrace? stackTrace})
      : super(message, originalError, stackTrace);
}
