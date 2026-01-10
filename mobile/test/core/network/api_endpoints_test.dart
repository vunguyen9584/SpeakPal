import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/core/network/api_endpoints.dart';

void main() {
  group('ApiEndpoints Tests', () {
    test('static constants have correct values', () {
      expect(ApiEndpoints.login, '/auth/login');
      expect(ApiEndpoints.register, '/auth/register');
      expect(ApiEndpoints.refreshToken, '/auth/refresh');
    });

    test('dynamic endpoints return correct paths', () {
      expect(ApiEndpoints.oauth('google'), '/auth/oauth/google');
      expect(ApiEndpoints.userById('123'), '/users/123');
      expect(ApiEndpoints.personaById('456'), '/personas/456');
      expect(ApiEndpoints.conversationById('789'), '/conversations/789');
      expect(ApiEndpoints.vocabularyById('abc'), '/vocabulary/abc');
      expect(ApiEndpoints.challengeById('def'), '/challenges/def');
      expect(ApiEndpoints.groupById('ghi'), '/social/groups/ghi');
    });
  });
}
