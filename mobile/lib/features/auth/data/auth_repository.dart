import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_endpoints.dart';
import 'package:mobile/core/auth/token_manager.dart';
import '../domain/models/user.dart' as app_user;
import '../domain/models/auth_tokens.dart';

/// Auth Repository - Handles authentication API calls
class AuthRepository {
  final ApiClient _apiClient;
  final TokenManager _tokenManager;
  final firebase_auth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    required ApiClient apiClient,
    required TokenManager tokenManager,
    firebase_auth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _apiClient = apiClient,
        _tokenManager = tokenManager,
        _firebaseAuth = firebaseAuth ?? firebase_auth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn.instance;

  /// Register a new user
  Future<app_user.User> register(
    String email,
    String password,
    String? username,
  ) async {
    final response = await _apiClient.post(
      ApiEndpoints.register,
      data: {
        'email': email,
        'password': password,
        if (username != null) 'username': username,
      },
    );

    final tokens = AuthTokens.fromJson(response.data['tokens']);
    await _tokenManager.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return app_user.User.fromJson(response.data['user']);
  }

  /// Login with email and password
  Future<app_user.User> login(String email, String password) async {
    final response = await _apiClient.post(
      ApiEndpoints.login,
      data: {
        'email': email,
        'password': password,
      },
    );

    final tokens = AuthTokens.fromJson(response.data['tokens']);
    await _tokenManager.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return app_user.User.fromJson(response.data['user']);
  }

  /// Logout
  Future<void> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
    } finally {
      await _tokenManager.clearTokens();
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    }
  }

  /// Refresh tokens
  Future<AuthTokens> refreshTokens() async {
    final refreshToken = await _tokenManager.getRefreshToken();
    if (refreshToken == null) {
      throw Exception('No refresh token available');
    }

    final response = await _apiClient.post(
      ApiEndpoints.refreshToken,
      data: {'refreshToken': refreshToken},
    );

    final tokens = AuthTokens.fromJson(response.data);
    await _tokenManager.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return tokens;
  }

  /// Forgot password - send reset email
  Future<void> forgotPassword(String email) async {
    await _apiClient.post(
      ApiEndpoints.forgotPassword,
      data: {'email': email},
    );
  }

  /// Reset password with token
  Future<void> resetPassword(String token, String newPassword) async {
    await _apiClient.post(
      ApiEndpoints.resetPassword,
      data: {
        'token': token,
        'password': newPassword,
      },
    );
  }

  /// Login with Google
  Future<app_user.User> loginWithGoogle() async {
    // Sign in with Google
    final googleUser = await _googleSignIn.authenticate();
    
    final googleAuth = googleUser.authentication;
    final authorization = await googleUser.authorizationClient.authorizeScopes(['email', 'profile']);
    
    final credential = firebase_auth.GoogleAuthProvider.credential(
      accessToken: authorization.accessToken,
      idToken: googleAuth.idToken,
    );

    // Sign in to Firebase
    final firebaseUserCredential =
        await _firebaseAuth.signInWithCredential(credential);
    final firebaseIdToken =
        await firebaseUserCredential.user?.getIdToken() ?? '';

    // Send Firebase token to backend
    final response = await _apiClient.post(
      ApiEndpoints.oauth('google'),
      data: {'idToken': firebaseIdToken},
    );

    final tokens = AuthTokens.fromJson(response.data['tokens']);
    await _tokenManager.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return app_user.User.fromJson(response.data['user']);
  }

  /// Login with Apple
  Future<app_user.User> loginWithApple() async {
    // Sign in with Apple
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    // Create Firebase credential
    final oAuthProvider = firebase_auth.OAuthProvider('apple.com');
    final firebaseCredential = oAuthProvider.credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    // Sign in to Firebase
    final firebaseUserCredential =
        await _firebaseAuth.signInWithCredential(firebaseCredential);
    final firebaseIdToken =
        await firebaseUserCredential.user?.getIdToken() ?? '';

    // Send Firebase token to backend
    final response = await _apiClient.post(
      ApiEndpoints.oauth('apple'),
      data: {'idToken': firebaseIdToken},
    );

    final tokens = AuthTokens.fromJson(response.data['tokens']);
    await _tokenManager.saveTokens(
      accessToken: tokens.accessToken,
      refreshToken: tokens.refreshToken,
    );

    return app_user.User.fromJson(response.data['user']);
  }

  /// Get current user
  Future<app_user.User?> getCurrentUser() async {
    final isAuthenticated = await _tokenManager.isAuthenticated();
    if (!isAuthenticated) return null;

    try {
      final response = await _apiClient.get(ApiEndpoints.user);
      return app_user.User.fromJson(response.data);
    } catch (e) {
      await _tokenManager.clearTokens();
      return null;
    }
  }

  /// Check if authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenManager.isAuthenticated();
  }
}
