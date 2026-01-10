import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/config/api_config.dart';

void main() {
  group('ApiConfig Tests', () {
    test('apiBaseUrl formats correctly', () {
      final config = ApiConfig(baseUrl: 'https://api.test.com');
      expect(config.apiBaseUrl, 'https://api.test.com/api/v1');
    });

    test('wsBaseUrl protocols handle https/http', () {
      final httpsConfig = ApiConfig(baseUrl: 'https://api.test.com');
      expect(httpsConfig.wsBaseUrl, 'wss://api.test.com');

      final httpConfig = ApiConfig(baseUrl: 'http://api.test.com');
      expect(httpConfig.wsBaseUrl, 'ws://api.test.com');
    });

    test('endpoints match expected patterns', () {
      final config = ApiConfig(baseUrl: 'https://api.com');
      expect(config.authEndpoint, 'https://api.com/api/v1/auth');
      expect(config.usersEndpoint, 'https://api.com/api/v1/users');
      expect(config.conversationsEndpoint, 'https://api.com/api/v1/conversations');
      expect(config.translationEndpoint, 'https://api.com/api/v1/translation');
      expect(config.learningEndpoint, 'https://api.com/api/v1/learning');
      expect(config.progressEndpoint, 'https://api.com/api/v1/progress');
      expect(config.socialEndpoint, 'https://api.com/api/v1/social');
      expect(config.subscriptionEndpoint, 'https://api.com/api/v1/subscription');
      expect(config.conversationWsUrl, 'wss://api.com/ws/conversation');
    });
  });
}
