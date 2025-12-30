import '../models/dashboard_stats.dart';
import '../models/recent_conversation.dart';

abstract class HomeRepository {
  /// Get dashboard statistics for the current user
  Future<DashboardStats> getDashboardStats();

  /// Get recent conversations (limited to 5)
  Future<List<RecentConversation>> getRecentConversations({int limit = 5});

  /// Refresh dashboard data
  Future<void> refreshDashboard();
}
