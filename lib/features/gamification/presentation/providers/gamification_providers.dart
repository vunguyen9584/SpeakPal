import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/badge.dart';
import '../../domain/models/ranking.dart';
import '../../domain/models/streak.dart';
import '../../domain/repositories/gamification_repository.dart';

// Repository provider - will be implemented when data layer is added
// For now, using a mock implementation
final gamificationRepositoryProvider = Provider<GamificationRepository>((ref) {
  return _MockGamificationRepository();
});

/// Provider for current user's streak information
/// Auto-disposes when no longer in use
final streakProvider = FutureProvider.autoDispose<Streak>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getStreak();
});

/// Provider for all available badges in the system
/// Auto-disposes when no longer in use
final allBadgesProvider = FutureProvider.autoDispose<List<Badge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getAllBadges();
});

/// Provider for badges earned by current user
/// Auto-disposes when no longer in use
final myBadgesProvider = FutureProvider.autoDispose<List<EarnedBadge>>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getMyBadges();
});

/// Provider for badges filtered by category
/// Family provider that takes category as parameter
final badgesByCategoryProvider = FutureProvider.autoDispose.family<List<Badge>, BadgeCategory>(
  (ref, category) async {
    final repository = ref.watch(gamificationRepositoryProvider);
    return repository.getBadgesByCategory(category);
  },
);

/// Provider for weekly ranking by league
/// Family provider that takes league as parameter
final weeklyRankingProvider = FutureProvider.autoDispose.family<RankingResponse, League>(
  (ref, league) async {
    final repository = ref.watch(gamificationRepositoryProvider);
    return repository.getWeeklyRanking(league);
  },
);

/// Provider for current user's rank information
/// Auto-disposes when no longer in use
final myRankProvider = FutureProvider.autoDispose<UserRankInfo>((ref) async {
  final repository = ref.watch(gamificationRepositoryProvider);
  return repository.getMyRank();
});

/// State notifier for streak freeze action
/// Manages the state of using a streak freeze
final streakFreezeProvider = StateNotifierProvider.autoDispose<StreakFreezeNotifier, AsyncValue<StreakFreezeResponse?>>(
  (ref) => StreakFreezeNotifier(ref),
);

class StreakFreezeNotifier extends StateNotifier<AsyncValue<StreakFreezeResponse?>> {
  final Ref ref;

  StreakFreezeNotifier(this.ref) : super(const AsyncValue.data(null));

  Future<void> useFreeze() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(gamificationRepositoryProvider);
      final response = await repository.useStreakFreeze();
      state = AsyncValue.data(response);

      // Invalidate streak provider to refresh data
      ref.invalidate(streakProvider);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// ============================================================================
// MOCK IMPLEMENTATION - WILL BE REPLACED WITH ACTUAL API INTEGRATION
// ============================================================================

class _MockGamificationRepository implements GamificationRepository {
  @override
  Future<Streak> getStreak() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    return Streak(
      currentStreak: 7,
      longestStreak: 15,
      freezeRemaining: 2,
      lastActivityDate: now.subtract(const Duration(days: 1)),
      isActiveToday: false,
      daysToNextMilestone: 23,
      nextMilestone: 30,
      recentDays: List.generate(7, (index) {
        final date = now.subtract(Duration(days: 6 - index));
        return StreakDay(
          date: date,
          hasActivity: index < 6, // Last 6 days have activity, today doesn't
          wasFrozen: index == 3, // One day was frozen
        );
      }),
    );
  }

  @override
  Future<StreakFreezeResponse> useStreakFreeze() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const StreakFreezeResponse(
      success: true,
      freezeRemaining: 1,
      message: 'Streak freeze used successfully',
    );
  }

  @override
  Future<List<Badge>> getAllBadges() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return [
      Badge(
        id: '1',
        name: 'First Steps',
        description: 'Complete your first conversation',
        iconUrl: '',
        category: BadgeCategory.conversation,
        xpBonus: 50,
        conditionDescription: 'Complete 1 conversation',
        earnedAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
      Badge(
        id: '2',
        name: '7-Day Streak',
        description: 'Maintain a 7-day streak',
        iconUrl: '',
        category: BadgeCategory.streak,
        xpBonus: 100,
        conditionDescription: 'Practice for 7 consecutive days',
        earnedAt: DateTime.now().subtract(const Duration(days: 2)),
      ),
      Badge(
        id: '3',
        name: 'Vocabulary Master',
        description: 'Learn 100 new words',
        iconUrl: '',
        category: BadgeCategory.vocabulary,
        xpBonus: 200,
        conditionDescription: 'Master 100 vocabulary words',
        progress: 0.65,
      ),
      Badge(
        id: '4',
        name: 'Level 10',
        description: 'Reach level 10',
        iconUrl: '',
        category: BadgeCategory.level,
        xpBonus: 500,
        conditionDescription: 'Reach level 10',
        progress: 0.40,
      ),
      Badge(
        id: '5',
        name: 'Chatterbox',
        description: 'Complete 50 conversations',
        iconUrl: '',
        category: BadgeCategory.conversation,
        xpBonus: 300,
        conditionDescription: 'Complete 50 conversations',
        progress: 0.24,
      ),
      Badge(
        id: '6',
        name: '30-Day Streak',
        description: 'Maintain a 30-day streak',
        iconUrl: '',
        category: BadgeCategory.streak,
        xpBonus: 500,
        conditionDescription: 'Practice for 30 consecutive days',
        progress: 0.10,
      ),
    ];
  }

  @override
  Future<List<EarnedBadge>> getMyBadges() async {
    await Future.delayed(const Duration(milliseconds: 500));

    final allBadges = await getAllBadges();
    final earnedBadges = allBadges.where((b) => b.earnedAt != null).toList();

    return earnedBadges.map((badge) {
      return EarnedBadge(
        id: 'earned_${badge.id}',
        badgeId: badge.id,
        userId: 'current_user',
        earnedAt: badge.earnedAt!,
        badge: badge,
      );
    }).toList();
  }

  @override
  Future<List<Badge>> getBadgesByCategory(BadgeCategory category) async {
    final allBadges = await getAllBadges();
    if (category == BadgeCategory.all) {
      return allBadges;
    }
    return allBadges.where((b) => b.category == category).toList();
  }

  @override
  Future<Badge> getBadgeById(String badgeId) async {
    final allBadges = await getAllBadges();
    return allBadges.firstWhere((b) => b.id == badgeId);
  }

  @override
  Future<RankingResponse> getWeeklyRanking(League league) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));
    final weekNumber = (now.difference(DateTime(now.year, 1, 1)).inDays / 7).ceil() + 1;

    return RankingResponse(
      league: league,
      weekNumber: weekNumber,
      weekStart: weekStart,
      weekEnd: weekEnd,
      promotionThreshold: 3,
      demotionThreshold: 18,
      currentUserRank: UserRankInfo(
        rank: 8,
        weeklyXp: 1250,
        league: league,
        zone: RankZone.safe,
        xpToPromotion: 350,
        xpToDemotion: 0,
      ),
      rankings: _generateMockRankings(league),
    );
  }

  @override
  Future<UserRankInfo> getMyRank() async {
    await Future.delayed(const Duration(milliseconds: 500));

    return const UserRankInfo(
      rank: 8,
      weeklyXp: 1250,
      league: League.bronze,
      zone: RankZone.safe,
      xpToPromotion: 350,
      xpToDemotion: 0,
    );
  }

  @override
  Future<RankingResponse> getRankingByWeek(League league, int weekNumber) async {
    // For mock, just return current week's ranking
    return getWeeklyRanking(league);
  }

  List<RankingEntry> _generateMockRankings(League league) {
    final names = [
      'Sarah Chen', 'Mike Johnson', 'Emily Davis', 'James Wilson',
      'Anna Martinez', 'David Lee', 'Lisa Brown', 'You',
      'Tom Anderson', 'Maria Garcia', 'Chris Taylor', 'Alex Kim',
      'Sophie White', 'Ryan Clark', 'Jessica Moore', 'Daniel Park',
      'Rachel Green', 'Kevin Zhang', 'Nicole Adams', 'Brian Kim',
    ];

    final xpValues = [
      2450, 2180, 1980, 1850, 1720, 1580, 1420, 1250,
      1180, 1050, 920, 820, 720, 620, 520, 480,
      420, 380, 350, 300,
    ];

    return List.generate(20, (index) {
      return RankingEntry(
        rank: index + 1,
        userId: index == 7 ? 'current_user' : 'user_${index + 1}',
        userName: names[index],
        avatarUrl: null,
        weeklyXp: xpValues[index],
        league: league,
        isCurrentUser: index == 7,
      );
    });
  }
}
