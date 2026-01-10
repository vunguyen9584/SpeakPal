import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/badge.dart';
import '../../domain/models/streak.dart';
import '../../domain/models/ranking.dart';
import '../../domain/repositories/gamification_repository.dart';
import '../../data/repositories/gamification_repository_impl.dart';
import 'package:mobile/core/providers/providers.dart';

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
  // TODO: Implement actual progress calculation based on user stats
  // For now, returning 0.0 for locked badges
  final userBadges = ref.watch(userBadgesProvider);

  return userBadges.when(
    data: (badges) {
      final isEarned = badges.any((ub) => ub.badgeCode == badge.code);
      return isEarned ? 1.0 : 0.0;
    },
    loading: () => 0.0,
    error: (error, stack) => 0.0,
  );
});

