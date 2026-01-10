import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/auth/token_manager.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'dart:convert';

class MockSecureStorage extends Mock implements SecureStorage {}

void main() {
  group('TokenManager Tests', () {
    late TokenManager tokenManager;
    late MockSecureStorage mockSecureStorage;

    setUp(() {
      mockSecureStorage = MockSecureStorage();
      tokenManager = TokenManager(secureStorage: mockSecureStorage);
    });

    test('saveTokens delegatesto secureStorage', () async {
      when(() => mockSecureStorage.saveTokens(
            accessToken: any(named: 'accessToken'),
            refreshToken: any(named: 'refreshToken'),
          )).thenAnswer((_) async => Future.value());

      await tokenManager.saveTokens(accessToken: 'a', refreshToken: 'r');

      verify(() => mockSecureStorage.saveTokens(accessToken: 'a', refreshToken: 'r')).called(1);
    });

    test('decodeToken correctly decodes a valid JWT payload', () {
      final payload = {'sub': '123', 'name': 'John Doe', 'exp': 1600000000};
      final payloadStr = base64Url.encode(utf8.encode(json.encode(payload))).replaceAll('=', '');
      final token = 'header.$payloadStr.signature';

      final decoded = tokenManager.decodeToken(token);

      expect(decoded?['sub'], '123');
      expect(decoded?['name'], 'John Doe');
    });

    test('decodeToken returns null for invalid token', () {
      expect(tokenManager.decodeToken('invalid'), null);
      expect(tokenManager.decodeToken('a.b.c.d'), null);
    });

    test('isTokenExpired returns true for expired token', () {
      final past = DateTime.now().subtract(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;
      final payloadStr = base64Url.encode(utf8.encode(json.encode({'exp': past}))).replaceAll('=', '');
      final token = 'header.$payloadStr.sig';

      expect(tokenManager.isTokenExpired(token), true);
    });

    test('isTokenExpired returns false for valid token', () {
      final future = DateTime.now().add(const Duration(hours: 1)).millisecondsSinceEpoch ~/ 1000;
      final payloadStr = base64Url.encode(utf8.encode(json.encode({'exp': future}))).replaceAll('=', '');
      final token = 'header.$payloadStr.sig';

      expect(tokenManager.isTokenExpired(token), false);
    });

    test('getAccessToken returns value from storage', () async {
      when(() => mockSecureStorage.getAccessToken()).thenAnswer((_) async => 'at');
      expect(await tokenManager.getAccessToken(), 'at');
    });

    test('getRefreshToken returns value from storage', () async {
      when(() => mockSecureStorage.getRefreshToken()).thenAnswer((_) async => 'rt');
      expect(await tokenManager.getRefreshToken(), 'rt');
    });

    test('clearTokens calls storage', () async {
      when(() => mockSecureStorage.clearTokens()).thenAnswer((_) async => Future.value());
      await tokenManager.clearTokens();
      verify(() => mockSecureStorage.clearTokens()).called(1);
    });

    test('isAuthenticated returns value from storage', () async {
      when(() => mockSecureStorage.isAuthenticated()).thenAnswer((_) async => true);
      expect(await tokenManager.isAuthenticated(), true);
    });
  });
}
