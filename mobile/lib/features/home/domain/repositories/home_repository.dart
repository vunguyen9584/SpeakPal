import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../models/dashboard_stats.dart';
import '../models/recent_conversation.dart';

abstract class HomeRepository {
  /// Get dashboard statistics for the current user
  Future<Either<AppError, DashboardStats>> getDashboardStats();

  /// Get recent conversations (limited to 5)
  Future<Either<AppError, List<RecentConversation>>> getRecentConversations({int limit = 5});

  /// Refresh dashboard data
  Future<Either<AppError, void>> refreshDashboard();
}

