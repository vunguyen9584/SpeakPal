import 'package:dio/dio.dart';
import '../../storage/secure_storage.dart';

/// Auth Interceptor - Adds JWT token to requests
class AuthInterceptor extends Interceptor {
  final Dio dio;
  final SecureStorage _secureStorage = SecureStorage();

  AuthInterceptor(this.dio);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Get access token from secure storage
    final accessToken = await _secureStorage.getAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Handle 401 Unauthorized - Token expired
    if (err.response?.statusCode == 401) {
      try {
        // Try to refresh token
        final newAccessToken = await _refreshToken();

        if (newAccessToken != null) {
          // Retry the request with new token
          err.requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';

          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        }
      } catch (e) {
        // Refresh failed, clear tokens and redirect to login
        await _secureStorage.clearTokens();
        // Navigate to login screen
        // Note: Navigation should be handled by the app layer
        // This interceptor will throw the error and let the app handle it
        // The app can listen to 401 errors and navigate accordingly
      }
    }

    handler.next(err);
  }

  Future<String?> _refreshToken() async {
    try {
      final refreshToken = await _secureStorage.getRefreshToken();

      if (refreshToken == null) return null;

      final response = await dio.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );

      final newAccessToken = response.data['accessToken'] as String?;
      final newRefreshToken = response.data['refreshToken'] as String?;

      if (newAccessToken != null && newRefreshToken != null) {
        await _secureStorage.saveTokens(
          accessToken: newAccessToken,
          refreshToken: newRefreshToken,
        );
        return newAccessToken;
      }

      return null;
    } catch (e) {
      return null;
    }
  }
}

