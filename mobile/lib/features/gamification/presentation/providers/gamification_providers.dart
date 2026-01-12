import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/badge.dart';
import '../../domain/models/streak.dart';
import '../../domain/models/ranking.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../../data/repositories/gamification_repository_impl.dart';
import 'package:mobile/core/providers/providers.dart';
import 'package:mobile/features/progress/domain/models/stats.dart';
import 'package:mobile/features/progress/presentation/providers/progress_providers.dart';

// Repository provider
final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return GamificationRepositoryImpl(apiClient);
});

// All Badges Provider
final allBadgesProvider = FutureProvider<List<Badge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  final result = await repository.getAllBadges();
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

// User Badges Provider
final userBadgesProvider = FutureProvider<List<UserBadge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  final result = await repository.getUserBadges();
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

// Streak Provider
final streakProvider = FutureProvider<Streak>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  final result = await repository.getStreak();
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

// Leaderboard Provider with league filter
final leaderboardProvider = FutureProvider.family<Leaderboard, String?>((ref, league) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  final result = await repository.getWeeklyRanking(league: league);
  return result.fold(
    (error) => throw Exception(error.message),
    (data) => data,
  );
});

// Use Streak Freeze Handler
final useStreakFreezeProvider = Provider((ref) {
  return () async {
    final repository = ref.read(gamificationRepositoryProvider);
    final result = await repository.useStreakFreeze();
    
    result.fold(
      (error) => throw Exception(error.message),
      (_) => ref.invalidate(streakProvider),
    );
  };
});

// Badge progress provider - calculates progress for each badge
final badgeProgressProvider = Provider.family<double, Badge>((ref, badge) {
  final userBadges = ref.watch(userBadgesProvider);
  final stats = ref.watch(statsProvider(StatsPeriod.allTime));

  // If badge is already earned, return 100%
  final isEarned = userBadges.whenOrNull(
    data: (badges) => badges.any((ub) => ub.badgeCode == badge.code),
  ) ?? false;
  
  if (isEarned) {
    return 1.0;
  }

  // Calculate progress based on badge category and user stats
  return stats.when(
    data: (userStats) {
      final currentValue = _getCurrentValueForBadge(badge, userStats);
      final progress = (currentValue / badge.requiredValue).clamp(0.0, 1.0);
      return progress;
    },
    loading: () => 0.0,
    error: (error, stack) => 0.0,
  );
});

/// Helper function to get current value based on badge category
int _getCurrentValueForBadge(Badge badge, Stats stats) {
  // Map badge category to corresponding stat value
  switch (badge.category.toLowerCase()) {
    case 'conversation':
    case 'conversations':
      return stats.totalConversations;
    
    case 'vocabulary':
    case 'words':
      return stats.totalWords;
    
    case 'pronunciation':
    case 'shadowing':
      return stats.totalShadowing;
    
    case 'streak':
    case 'daily':
      return stats.currentStreak;
    
    case 'xp':
    case 'experience':
      return stats.totalXP;
    
    case 'minutes':
    case 'time':
      return stats.totalMinutes;
    
    default:
      // For unknown categories, try to match by badge code prefix
      if (badge.code.startsWith('CONV')) {
        return stats.totalConversations;
      } else if (badge.code.startsWith('VOCAB')) {
        return stats.totalWords;
      } else if (badge.code.startsWith('SHADOW')) {
        return stats.totalShadowing;
      } else if (badge.code.startsWith('STREAK')) {
        return stats.currentStreak;
      }
      return 0;
  }
}

