/// Route path constants for navigation
class AppRoutes {
  // Private constructor to prevent instantiation
  AppRoutes._();

  // Root
  static const String root = '/';

  // Auth routes
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Onboarding routes
  static const String onboarding = '/onboarding';
  static const String levelSelection = '/onboarding/level';
  static const String personaSetup = '/onboarding/persona';

  // Main app routes
  static const String home = '/home';
  static const String conversation = '/conversation';
  static const String conversationSummary = '/conversation/summary';

  // Learning routes
  static const String vocabulary = '/vocabulary';
  static const String vocabularyDetail = '/vocabulary/:id';
  static const String scenarios = '/scenarios';
  static const String challenge = '/challenge/:id';
  static const String review = '/review';

  // Gamification routes
  static const String badges = '/badges';
  static const String badgeDetail = '/badges/:id';
  static const String leaderboard = '/leaderboard';

  // Progress routes
  static const String progress = '/progress';
  static const String statistics = '/statistics';
  static const String history = '/history';

  // Social routes
  static const String social = '/social';
  static const String inviteFriends = '/social/invite';
  static const String groups = '/social/groups';
  static const String groupDetail = '/social/groups/:id';

  // Profile & Settings routes
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String editProfile = '/profile/edit';

  // Subscription routes
  static const String subscription = '/subscription';
  static const String plans = '/subscription/plans';
}

