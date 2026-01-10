/// Storage Keys
class StorageKeys {
  StorageKeys._();

  // Auth keys (stored in secure storage)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';

  // User keys
  static const String userId = 'user_id';
  static const String userEmail = 'user_email';
  static const String userName = 'user_name';

  // Settings keys
  static const String isDarkMode = 'is_dark_mode';
  static const String language = 'language';
  static const String notificationsEnabled = 'notifications_enabled';
  static const String aiSpeed = 'ai_speed';
  static const String confirmationMode = 'confirmation_mode';

  // Onboarding
  static const String hasCompletedOnboarding = 'has_completed_onboarding';
  static const String selectedLevel = 'selected_level';

  // Cache
  static const String lastSyncTime = 'last_sync_time';
}

