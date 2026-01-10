import 'package:fpdart/fpdart.dart';
import 'package:mobile/core/error/app_error.dart';
import 'package:mobile/core/error/error_handler.dart';
import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_endpoints.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import '../domain/models/user_stats.dart';

/// Profile Repository - Handles profile-related API calls
class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get user profile
  Future<Either<AppError, User>> getProfile() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.user);
      return Right(User.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Update user profile
  Future<Either<AppError, User>> updateProfile({
    String? username,
    String? email,
  }) async {
    try {
      final response = await _apiClient.patch(
        ApiEndpoints.updateProfile,
        data: {
          if (username != null) 'username': username,
          if (email != null) 'email': email,
        },
      );
      return Right(User.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Update user settings
  Future<Either<AppError, void>> updateSettings({
    double? aiSpeed,
    bool? confirmationMode,
  }) async {
    try {
      await _apiClient.patch(
        ApiEndpoints.updateProfile,
        data: {
          if (aiSpeed != null) 'aiSpeed': aiSpeed,
          if (confirmationMode != null) 'confirmationMode': confirmationMode,
        },
      );
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Change password
  Future<Either<AppError, void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _apiClient.post(
        ApiEndpoints.changePassword,
        data: {
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        },
      );
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Get user statistics
  Future<Either<AppError, UserStats>> getStats() async {
    try {
      final response = await _apiClient.get(ApiEndpoints.statistics);
      return Right(UserStats.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  /// Delete account
  Future<Either<AppError, void>> deleteAccount() async {
    try {
      await _apiClient.delete(ApiEndpoints.user);
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

