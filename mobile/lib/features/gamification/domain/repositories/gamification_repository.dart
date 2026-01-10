import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../models/badge.dart';
import '../models/streak.dart';
import '../models/ranking.dart';

abstract class GamificationRepository {
  // Badges
  Future<Either<AppError, List<Badge>>> getAllBadges();
  Future<Either<AppError, List<UserBadge>>> getUserBadges();

  // Streak
  Future<Either<AppError, Streak>> getStreak();
  Future<Either<AppError, void>> useStreakFreeze();

  // Ranking
  Future<Either<AppError, Leaderboard>> getWeeklyRanking({String? league});
}

