import '../models/badge.dart';
import '../models/ranking.dart';
import '../models/streak.dart';

/// Repository interface for gamification features
abstract class GamificationRepository {
  // Streak methods
  /// Get current user's streak information
  Future<Streak> getStreak();

  /// Use a streak freeze to protect current streak
  Future<StreakFreezeResponse> useStreakFreeze();

  // Badge methods
  /// Get all available badges in the system
  Future<List<Badge>> getAllBadges();

  /// Get badges earned by current user
  Future<List<EarnedBadge>> getMyBadges();

  /// Get badges filtered by category
  Future<List<Badge>> getBadgesByCategory(BadgeCategory category);

  /// Get details of a specific badge
  Future<Badge> getBadgeById(String badgeId);

  // Ranking methods
  /// Get weekly leaderboard for a specific league
  Future<RankingResponse> getWeeklyRanking(League league);

  /// Get current user's rank information
  Future<UserRankInfo> getMyRank();

  /// Get rankings for a specific week
  Future<RankingResponse> getRankingByWeek(League league, int weekNumber);
}
