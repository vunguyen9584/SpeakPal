import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/error/app_error.dart';
import 'package:mobile/core/error/error_handler.dart';
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
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  /// Register a new user
  Future<Either<AppError, app_user.User>> register(
    String email,
    String password,
    String? username,
  ) async {
    try {
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

      return Right(app_user.User.fromJson(response.data['user']));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Login with email and password
  Future<Either<AppError, app_user.User>> login(String email, String password) async {
    try {
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

      return Right(app_user.User.fromJson(response.data['user']));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Logout
  Future<Either<AppError, void>> logout() async {
    try {
      await _apiClient.post(ApiEndpoints.logout);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    } finally {
      await _tokenManager.clearTokens();
      await _firebaseAuth.signOut();
      await _googleSignIn.signOut();
    }
  }

  /// Refresh tokens
  Future<Either<AppError, AuthTokens>> refreshTokens() async {
    try {
      final refreshToken = await _tokenManager.getRefreshToken();
      if (refreshToken == null) {
        return const Left(AuthError('No refresh token available'));
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

      return Right(tokens);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Forgot password - send reset email
  Future<Either<AppError, void>> forgotPassword(String email) async {
    try {
      await _apiClient.post(
        ApiEndpoints.forgotPassword,
        data: {'email': email},
      );
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Reset password with token
  Future<Either<AppError, void>> resetPassword(String token, String newPassword) async {
    try {
      await _apiClient.post(
        ApiEndpoints.resetPassword,
        data: {
          'token': token,
          'password': newPassword,
        },
      );
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Login with Google
  Future<Either<AppError, app_user.User>> loginWithGoogle() async {
    try {
      // Sign in with Google
      final googleUser = await _googleSignIn.signIn();
      
      if (googleUser == null) {
         return const Left(AuthError('Google sign in cancelled'));
      }
      
      final googleAuth = await googleUser.authentication;
      
      final credential = firebase_auth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
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

      return Right(app_user.User.fromJson(response.data['user']));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Login with Apple
  Future<Either<AppError, app_user.User>> loginWithApple() async {
    try {
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

      return Right(app_user.User.fromJson(response.data['user']));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Get current user
  Future<Either<AppError, app_user.User?>> getCurrentUser() async {
    try {
      final isAuthenticated = await _tokenManager.isAuthenticated();
      if (!isAuthenticated) return const Right(null);

      final response = await _apiClient.get(ApiEndpoints.user);
      return Right(app_user.User.fromJson(response.data));
    } catch (e) {
      // If error, assume expired or invalid
      await _tokenManager.clearTokens();
      // Or we can return Left if we want to bubble up the error
      // But typically getCurrentUser returns null if not logged in
       return const Right(null);
    }
  }

  /// Check if authenticated
  Future<bool> isAuthenticated() async {
    return await _tokenManager.isAuthenticated();
  }
}

