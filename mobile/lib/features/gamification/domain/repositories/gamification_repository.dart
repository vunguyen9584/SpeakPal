import '../models/badge.dart';
import '../models/streak.dart';
import '../models/ranking.dart';

abstract class GamificationRepository {
  // Badges
  Future<List<Badge>> getAllBadges();
  Future<List<UserBadge>> getUserBadges();

  // Streak
  Future<Streak> getStreak();
  Future<void> useStreakFreeze();

  // Ranking
  Future<Leaderboard> getWeeklyRanking({String? league});
}
