import '../storage/secure_storage.dart';

/// Token Manager - Handles JWT tokens
class TokenManager {
  final SecureStorage _secureStorage = SecureStorage();

  /// Save tokens
  Future<void> saveTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Get access token
  Future<String?> getAccessToken() async {
    return await _secureStorage.getAccessToken();
  }

  /// Get refresh token
  Future<String?> getRefreshToken() async {
    return await _secureStorage.getRefreshToken();
  }

  /// Clear tokens
  Future<void> clearTokens() async {
    await _secureStorage.clearTokens();
  }

  /// Check if authenticated
  Future<bool> isAuthenticated() async {
    return await _secureStorage.isAuthenticated();
  }

  /// Decode JWT token (basic implementation)
  Map<String, dynamic>? decodeToken(String token) {
    try {
      final parts = token.split('.');
      if (parts.length != 3) return null;

      final payload = parts[1];
      final normalized = base64Url.normalize(payload);
      final decoded = utf8.decode(base64Url.decode(normalized));

      return json.decode(decoded) as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }

  /// Check if token is expired
  bool isTokenExpired(String token) {
    final decoded = decodeToken(token);
    if (decoded == null) return true;

    final exp = decoded['exp'] as int?;
    if (exp == null) return true;

    final expiryDate = DateTime.fromMillisecondsSinceEpoch(exp * 1000);
    return DateTime.now().isAfter(expiryDate);
  }
}
