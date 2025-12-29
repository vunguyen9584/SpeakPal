import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/secure_storage.dart';

/// Auth State
class AuthState {
  final bool isAuthenticated;
  final String? accessToken;
  final String? refreshToken;
  final bool isLoading;

  AuthState({
    required this.isAuthenticated,
    this.accessToken,
    this.refreshToken,
    this.isLoading = false,
  });

  AuthState copyWith({
    bool? isAuthenticated,
    String? accessToken,
    String? refreshToken,
    bool? isLoading,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Auth State Notifier
class AuthStateNotifier extends StateNotifier<AuthState> {
  final SecureStorage _secureStorage = SecureStorage();

  AuthStateNotifier()
      : super(AuthState(isAuthenticated: false, isLoading: true)) {
    _checkAuthStatus();
  }

  /// Check if user is authenticated on app start
  Future<void> _checkAuthStatus() async {
    final isAuth = await _secureStorage.isAuthenticated();
    final accessToken = await _secureStorage.getAccessToken();
    final refreshToken = await _secureStorage.getRefreshToken();

    state = AuthState(
      isAuthenticated: isAuth,
      accessToken: accessToken,
      refreshToken: refreshToken,
      isLoading: false,
    );
  }

  /// Login - Save tokens
  Future<void> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    await _secureStorage.saveTokens(
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    state = AuthState(
      isAuthenticated: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );
  }

  /// Logout - Clear tokens
  Future<void> logout() async {
    await _secureStorage.clearTokens();

    state = AuthState(
      isAuthenticated: false,
      accessToken: null,
      refreshToken: null,
    );
  }

  /// Update access token (after refresh)
  Future<void> updateAccessToken(String newAccessToken) async {
    await _secureStorage.saveAccessToken(newAccessToken);

    state = state.copyWith(accessToken: newAccessToken);
  }
}

/// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);
