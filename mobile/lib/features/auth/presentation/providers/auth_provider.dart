import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/auth/token_manager.dart';
import '../../data/auth_repository.dart';
import '../../domain/models/auth_state.dart';
import '../../domain/models/user.dart';

/// Auth Repository Provider
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ApiClient(),
    tokenManager: TokenManager(),
  );
});

/// Auth State Provider
final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authRepositoryProvider));
});

/// Auth Notifier - Manages authentication state
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;

  AuthNotifier(this._repository) : super(const AuthState.initial()) {
    checkAuthStatus();
  }

  /// Check current authentication status
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    final result = await _repository.getCurrentUser();
    result.fold(
      (error) => state = const AuthState.unauthenticated(),
      (user) {
        if (user != null) {
          state = AuthState.authenticated(user);
        } else {
          state = const AuthState.unauthenticated();
        }
      },
    );
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await _repository.login(email, password);
    result.fold(
      (error) => _handleError(error.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Register new account
  Future<void> register(
    String email,
    String password,
    String? username,
  ) async {
    state = const AuthState.loading();
    final result = await _repository.register(email, password, username);
    result.fold(
      (error) => _handleError(error.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    state = const AuthState.loading();
    final result = await _repository.loginWithGoogle();
    result.fold(
      (error) => _handleError(error.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Login with Apple
  Future<void> loginWithApple() async {
    state = const AuthState.loading();
    final result = await _repository.loginWithApple();
    result.fold(
      (error) => _handleError(error.message),
      (user) => state = AuthState.authenticated(user),
    );
  }

  /// Logout
  Future<void> logout() async {
    final result = await _repository.logout();
    result.fold(
      (error) => state = AuthState.error(error.message),
      (_) => state = const AuthState.unauthenticated(),
    );
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    final result = await _repository.forgotPassword(email);
    result.fold(
      (error) => throw Exception(error.message), // Rethrow for UI to handle if needed
      (_) => null,
    );
  }

  /// Reset password
  Future<void> resetPassword(String token, String newPassword) async {
    final result = await _repository.resetPassword(token, newPassword);
    result.fold(
      (error) => throw Exception(error.message),
      (_) => null,
    );
  }

  /// Update current user in state
  void updateUser(User user) {
    state = AuthState.authenticated(user);
  }

  void _handleError(String message) {
    state = AuthState.error(message);
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        state = const AuthState.unauthenticated();
      }
    });
  }
}

/// Current User Provider - convenience provider for getting current user
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    authenticated: (user) => user,
    orElse: () => null,
  );
});

/// Is Authenticated Provider - convenience provider for checking auth status
final isAuthenticatedProvider = Provider<bool>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.maybeWhen(
    authenticated: (_) => true,
    orElse: () => false,
  );
});

