import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/env/app_config.dart';

/// Centralized API Configuration
/// Manages all API endpoints and external service URLs
class ApiConfig {
  final String baseUrl;
  final String apiVersion;

  const ApiConfig({
    required this.baseUrl,
    this.apiVersion = 'v1',
  });

  /// Get full API base URL with version
  String get apiBaseUrl => '$baseUrl/api/$apiVersion';

  /// WebSocket URL
  String get wsBaseUrl {
    final wsProtocol = baseUrl.startsWith('https') ? 'wss' : 'ws';
    final host = baseUrl.replaceFirst(RegExp(r'https?://'), '');
    return '$wsProtocol://$host';
  }

  /// Conversation WebSocket endpoint
  String get conversationWsUrl => '$wsBaseUrl/ws/conversation';

  // API Endpoints
  String get authEndpoint => '$apiBaseUrl/auth';
  String get usersEndpoint => '$apiBaseUrl/users';
  String get conversationsEndpoint => '$apiBaseUrl/conversations';
  String get translationEndpoint => '$apiBaseUrl/translation';
  String get learningEndpoint => '$apiBaseUrl/learning';
  String get progressEndpoint => '$apiBaseUrl/progress';
  String get socialEndpoint => '$apiBaseUrl/social';
  String get subscriptionEndpoint => '$apiBaseUrl/subscription';
}

/// Provider for API configuration
/// Automatically uses the correct environment config
final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig(baseUrl: AppConfig.apiBaseUrl);
});

