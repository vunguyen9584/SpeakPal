import 'package:mobile/core/network/api_client.dart';
import 'package:mobile/core/network/api_endpoints.dart';
import 'package:mobile/features/auth/domain/models/user.dart';
import '../domain/models/user_stats.dart';

/// Profile Repository - Handles profile-related API calls
class ProfileRepository {
  final ApiClient _apiClient;

  ProfileRepository({required ApiClient apiClient}) : _apiClient = apiClient;

  /// Get user profile
  Future<User> getProfile() async {
    final response = await _apiClient.get(ApiEndpoints.user);
    return User.fromJson(response.data);
  }

  /// Update user profile
  Future<User> updateProfile({
    String? username,
    String? email,
  }) async {
    final response = await _apiClient.patch(
      ApiEndpoints.updateProfile,
      data: {
        if (username != null) 'username': username,
        if (email != null) 'email': email,
      },
    );
    return User.fromJson(response.data);
  }

  /// Update user settings
  Future<void> updateSettings({
    double? aiSpeed,
    bool? confirmationMode,
  }) async {
    await _apiClient.patch(
      ApiEndpoints.updateProfile,
      data: {
        if (aiSpeed != null) 'aiSpeed': aiSpeed,
        if (confirmationMode != null) 'confirmationMode': confirmationMode,
      },
    );
  }

  /// Change password
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.post(
      ApiEndpoints.changePassword,
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  /// Get user statistics
  Future<UserStats> getStats() async {
    final response = await _apiClient.get(ApiEndpoints.statistics);
    return UserStats.fromJson(response.data);
  }

  /// Delete account
  Future<void> deleteAccount() async {
    await _apiClient.delete(ApiEndpoints.user);
  }
}
