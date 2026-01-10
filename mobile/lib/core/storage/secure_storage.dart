import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'storage_keys.dart';

/// Secure Storage for sensitive data (tokens, credentials)
class SecureStorage {
  final FlutterSecureStorage _storage;

  factory SecureStorage() {
    return _instance;
  }

  @visibleForTesting
  SecureStorage.withStorage(this._storage);

  SecureStorage._internal()
      : _storage = const FlutterSecureStorage(
          aOptions: AndroidOptions(
            encryptedSharedPreferences: true,
          ),
          iOptions: IOSOptions(
            accessibility: KeychainAccessibility.first_unlock,
          ),
        );

  static void setMockInstance(SecureStorage instance) {
    _instance = instance;
  }
  
  static SecureStorage _instance = SecureStorage._internal();

  /// Write value
  Future<void> write(String key, String value) async {
    await _storage.write(key: key, value: value);
  }

  /// Read value
  Future<String?> read(String key) async {
    return await _storage.read(key: key);
  }

  /// Delete value
  Future<void> delete(String key) async {
    await _storage.delete(key: key);
  }

  /// Delete all
  Future<void> deleteAll() async {
    await _storage.deleteAll();
  }

  /// Check if key exists
  Future<bool> containsKey(String key) async {
    return await _storage.containsKey(key: key);
  }

  // ============================================================
  // Auth Token Methods
  // ============================================================

  /// Save access token
  Future<void> saveAccessToken(String token) async {
    await write(StorageKeys.accessToken, token);
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await read(StorageKeys.accessToken);
  }

  /// Save refresh token
  Future<void> saveRefreshToken(String token) async {
    await write(StorageKeys.refreshToken, token);
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await read(StorageKeys.refreshToken);
  }

  /// Save both tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await Future.wait([
      saveAccessToken(accessToken),
      saveRefreshToken(refreshToken),
    ]);
  }

  /// Clear both tokens
  Future<void> clearTokens() async {
    await Future.wait([
      delete(StorageKeys.accessToken),
      delete(StorageKeys.refreshToken),
    ]);
  }

  /// Check if user is authenticated
  Future<bool> isAuthenticated() async {
    final accessToken = await getAccessToken();
    return accessToken != null && accessToken.isNotEmpty;
  }
}

