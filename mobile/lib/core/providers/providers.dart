import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import '../network/api_client.dart';

/// Provider for SharedPreferences instance
/// Used for non-sensitive local storage
final sharedPreferencesProvider = Provider<SharedPreferences>((ref) {
  throw UnimplementedError('SharedPreferences not initialized');
});

/// Provider for FlutterSecureStorage instance
/// Used for storing sensitive data like tokens
final secureStorageProvider = Provider<FlutterSecureStorage>((ref) {
  return const FlutterSecureStorage();
});

/// Provider for Dio HTTP client
/// Used for making API requests
final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(
    BaseOptions(
      // TODO: Update with actual API base URL from environment config
      baseUrl: 'http://localhost:3000/api/v1',
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  // Add interceptors
  dio.interceptors.add(
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: false,
      responseBody: true,
      error: true,
    ),
  );

  return dio;
});

/// Provider for ApiClient
/// Used for all API requests with interceptors
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
