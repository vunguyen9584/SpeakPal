import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
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
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        state = AuthState.authenticated(user);
      } else {
        state = const AuthState.unauthenticated();
      }
    } catch (e) {
      state = const AuthState.unauthenticated();
    }
  }

  /// Login with email and password
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.login(email, password);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = const AuthState.unauthenticated();
        }
      });
    }
  }

  /// Register new account
  Future<void> register(
    String email,
    String password,
    String? username,
  ) async {
    state = const AuthState.loading();
    try {
      final user = await _repository.register(email, password, username);
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = const AuthState.unauthenticated();
        }
      });
    }
  }

  /// Login with Google
  Future<void> loginWithGoogle() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.loginWithGoogle();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = const AuthState.unauthenticated();
        }
      });
    }
  }

  /// Login with Apple
  Future<void> loginWithApple() async {
    state = const AuthState.loading();
    try {
      final user = await _repository.loginWithApple();
      state = AuthState.authenticated(user);
    } catch (e) {
      state = AuthState.error(e.toString());
      // Reset to unauthenticated after showing error
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          state = const AuthState.unauthenticated();
        }
      });
    }
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _repository.logout();
      state = const AuthState.unauthenticated();
    } catch (e) {
      state = AuthState.error(e.toString());
    }
  }

  /// Forgot password
  Future<void> forgotPassword(String email) async {
    try {
      await _repository.forgotPassword(email);
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password
  Future<void> resetPassword(String token, String newPassword) async {
    try {
      await _repository.resetPassword(token, newPassword);
    } catch (e) {
      rethrow;
    }
  }

  /// Update current user in state
  void updateUser(User user) {
    state = AuthState.authenticated(user);
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
