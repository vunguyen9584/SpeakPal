import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mobile/core/storage/secure_storage.dart';
import 'package:mobile/core/storage/storage_keys.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  group('SecureStorage Tests', () {
    late MockFlutterSecureStorage mockStorage;
    late SecureStorage secureStorage;

    setUp(() {
      mockStorage = MockFlutterSecureStorage();
      secureStorage = SecureStorage.withStorage(mockStorage);
      SecureStorage.setMockInstance(secureStorage);
    });

    test('singleton factory returns the same instance', () {
      final s1 = SecureStorage();
      final s2 = SecureStorage();
      expect(s1, equals(s2));
    });

    test('write calls storage.write', () async {
      when(() => mockStorage.write(key: 'key', value: 'value'))
          .thenAnswer((_) => Future.value());

      await secureStorage.write('key', 'value');

      verify(() => mockStorage.write(key: 'key', value: 'value')).called(1);
    });

    test('read calls storage.read', () async {
      when(() => mockStorage.read(key: 'key'))
          .thenAnswer((_) => Future.value('value'));

      final result = await secureStorage.read('key');

      expect(result, 'value');
      verify(() => mockStorage.read(key: 'key')).called(1);
    });

    test('clearTokens deletes both accessToken and refreshToken', () async {
      when(() => mockStorage.delete(key: any(named: 'key')))
          .thenAnswer((_) async => Future.value());

      await secureStorage.clearTokens();

      verify(() => mockStorage.delete(key: StorageKeys.accessToken)).called(1);
      verify(() => mockStorage.delete(key: StorageKeys.refreshToken)).called(1);
    });

    test('delete calls storage.delete', () async {
      when(() => mockStorage.delete(key: 'key'))
          .thenAnswer((_) => Future.value());

      await secureStorage.delete('key');

      verify(() => mockStorage.delete(key: 'key')).called(1);
    });

    test('deleteAll calls storage.deleteAll', () async {
      when(() => mockStorage.deleteAll())
          .thenAnswer((_) => Future.value());

      await secureStorage.deleteAll();

      verify(() => mockStorage.deleteAll()).called(1);
    });

    test('containsKey calls storage.containsKey', () async {
      when(() => mockStorage.containsKey(key: 'key'))
          .thenAnswer((_) => Future.value(true));

      final result = await secureStorage.containsKey('key');

      expect(result, true);
      verify(() => mockStorage.containsKey(key: 'key')).called(1);
    });

    test('saveAccessToken saves to StorageKeys.accessToken', () async {
       when(() => mockStorage.write(key: StorageKeys.accessToken, value: 'token'))
          .thenAnswer((_) => Future.value());
      
      await secureStorage.saveAccessToken('token');

      verify(() => mockStorage.write(key: StorageKeys.accessToken, value: 'token')).called(1);
    });

    test('getAccessToken reads from StorageKeys.accessToken', () async {
      when(() => mockStorage.read(key: StorageKeys.accessToken))
          .thenAnswer((_) => Future.value('token'));

      final token = await secureStorage.getAccessToken();

      expect(token, 'token');
    });

    test('isAuthenticated returns true when token exists', () async {
      when(() => mockStorage.read(key: StorageKeys.accessToken))
          .thenAnswer((_) => Future.value('token'));

      final result = await secureStorage.isAuthenticated();

      expect(result, true);
    });

    test('isAuthenticated returns false when token is absent', () async {
      when(() => mockStorage.read(key: StorageKeys.accessToken))
          .thenAnswer((_) => Future.value(null));

      final result = await secureStorage.isAuthenticated();

      expect(result, false);
    });

    test('saveRefreshToken saves correctly', () async {
      when(() => mockStorage.write(key: StorageKeys.refreshToken, value: 'rt'))
          .thenAnswer((_) async => Future.value());
      await secureStorage.saveRefreshToken('rt');
      verify(() => mockStorage.write(key: StorageKeys.refreshToken, value: 'rt')).called(1);
    });

    test('getRefreshToken reads correctly', () async {
      when(() => mockStorage.read(key: StorageKeys.refreshToken))
          .thenAnswer((_) async => 'rt');
      expect(await secureStorage.getRefreshToken(), 'rt');
    });

    test('saveTokens saves both tokens', () async {
      when(() => mockStorage.write(key: any(named: 'key'), value: any(named: 'value')))
          .thenAnswer((_) async => Future.value());
      await secureStorage.saveTokens(accessToken: 'at', refreshToken: 'rt');
      verify(() => mockStorage.write(key: StorageKeys.accessToken, value: 'at')).called(1);
      verify(() => mockStorage.write(key: StorageKeys.refreshToken, value: 'rt')).called(1);
    });
  });
}
