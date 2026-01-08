/// API Endpoints
/// Contains only endpoint paths - base URL is managed by ApiConfig
class ApiEndpoints {
  ApiEndpoints._();

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String refreshToken = '/auth/refresh';
  static const String logout = '/auth/logout';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  static const String verifyEmail = '/auth/verify-email';

  // OAuth endpoints
  static const String googleAuth = '/auth/google';
  static const String appleAuth = '/auth/apple';

  // User endpoints
  static const String user = '/users';
  static String userById(String id) => '/users/$id';
  static const String updateProfile = '/users/profile';
  static const String changePassword = '/users/password';

  // Persona endpoints
  static const String personas = '/personas';
  static String personaById(String id) => '/personas/$id';

  // Conversation endpoints
  static const String conversations = '/conversations';
  static String conversationById(String id) => '/conversations/$id';
  static String conversationTurns(String id) => '/conversations/$id/turns';
  static String conversationSummary(String id) => '/conversations/$id/summary';

  // Learning endpoints
  static const String vocabulary = '/vocabulary';
  static String vocabularyById(String id) => '/vocabulary/$id';
  static const String scenarios = '/scenarios';
  static const String challenges = '/challenges';
  static String challengeById(String id) => '/challenges/$id';

  // Gamification endpoints
  static const String badges = '/gamification/badges';
  static const String userBadges = '/gamification/user-badges';
  static const String leaderboard = '/gamification/leaderboard';
  static const String streak = '/gamification/streak';
  static const String xp = '/gamification/xp';

  // Progress endpoints
  static const String progress = '/progress';
  static const String statistics = '/progress/statistics';
  static const String history = '/progress/history';

  // Social endpoints
  static const String invitations = '/social/invitations';
  static const String groups = '/social/groups';
  static String groupById(String id) => '/social/groups/$id';

  // Subscription endpoints
  static const String subscription = '/subscription';
  static const String plans = '/subscription/plans';
  static const String verifyPurchase = '/subscription/verify';

  // WebSocket endpoint
  static const String wsConversation = '/ws/conversation';
}
