import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:mobile/core/network/api_client.dart';

void main() {
  group('Providers Tests', () {
    test('secureStorageProvider provides FlutterSecureStorage', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      expect(container.read(secureStorageProvider), isA<FlutterSecureStorage>());
    });

    test('dioProvider provides Dio with correct config', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      final dio = container.read(dioProvider);
      expect(dio, isA<Dio>());
      expect(dio.options.connectTimeout, const Duration(seconds: 30));
      expect(dio.interceptors.length, greaterThan(0));
    });

    test('apiClientProvider provides ApiClient', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      
      expect(container.read(apiClientProvider), isA<ApiClient>());
    });
  });
}
