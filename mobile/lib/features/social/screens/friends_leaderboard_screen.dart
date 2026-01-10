import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/group_provider.dart';

/// Global leaderboard showing rankings across all user's groups
class FriendsLeaderboardScreen extends ConsumerWidget {
  const FriendsLeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groupsAsync = ref.watch(myGroupsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Friends Leaderboard'),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(myGroupsProvider),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          ref.invalidate(myGroupsProvider);
        },
        child: groupsAsync.when(
          data: (groups) {
            if (groups.isEmpty) {
              return _buildEmptyState();
            }
            return _buildLeaderboard(context, ref, groups);
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => _buildErrorState(error.toString()),
        ),
      ),
    );
  }

  Widget _buildLeaderboard(BuildContext context, WidgetRef ref, List<Group> groups) {
    // Collect all rankings from all groups
    final allRankings = <GroupRanking>[];
    
    for (final group in groups) {
      final rankingsAsync = ref.watch(groupRankingProvider(group.id));
      rankingsAsync.whenData((rankings) {
        allRankings.addAll(rankings);
      });
    }

    // Aggregate rankings by user (sum weekly XP across all groups)
    final userRankings = <String, int>{};
    for (final ranking in allRankings) {
      userRankings[ranking.username] = 
          (userRankings[ranking.username] ?? 0) + ranking.weeklyXp;
    }

    // Convert to list and sort by XP
    final sortedRankings = userRankings.entries
        .map((e) => _UserRanking(username: e.key, totalXp: e.value))
        .toList()
      ..sort((a, b) => b.totalXp.compareTo(a.totalXp));

    if (sortedRankings.isEmpty) {
      return _buildEmptyState();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Week Info Card
          _buildWeekInfoCard(),
          const SizedBox(height: 16),

          // Top 3 Podium
          if (sortedRankings.length >= 3)
            _buildPodium(sortedRankings.take(3).toList()),
          const SizedBox(height: 24),

          // Full Rankings List
          _buildRankingsList(sortedRankings),
        ],
      ),
    );
  }

  Widget _buildWeekInfoCard() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            const Icon(Icons.calendar_today, color: Colors.blue),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'This Week',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue,
                    ),
                  ),
                  Text(
                    '${_formatShortDate(weekStart)} - ${_formatShortDate(weekEnd)}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.blue.shade700,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildPodium(List<_UserRanking> topThree) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            // 2nd Place
            if (topThree.length > 1)
              _buildPodiumPlace(
                ranking: topThree[1],
                position: 2,
                height: 100,
                color: Colors.grey,
              ),
            // 1st Place
            _buildPodiumPlace(
              ranking: topThree[0],
              position: 1,
              height: 140,
              color: Colors.amber,
            ),
            // 3rd Place
            if (topThree.length > 2)
              _buildPodiumPlace(
                ranking: topThree[2],
                position: 3,
                height: 80,
                color: Colors.brown,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPodiumPlace({
    required _UserRanking ranking,
    required int position,
    required double height,
    required Color color,
  }) {
    return Column(
      children: [
        CircleAvatar(
          radius: position == 1 ? 36 : 28,
          backgroundColor: color.withValues(alpha: 0.2),
          child: Text(
            ranking.username[0].toUpperCase(),
            style: TextStyle(
              fontSize: position == 1 ? 28 : 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          ranking.username,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          '${ranking.totalXp} XP',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 80,
          height: height,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
            border: Border.all(color: color, width: 2),
          ),
          child: Center(
            child: Icon(
              Icons.emoji_events,
              color: color,
              size: position == 1 ? 48 : 32,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRankingsList(List<_UserRanking> rankings) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Rankings',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rankings.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final ranking = rankings[index];
                final position = index + 1;
                return _buildRankingTile(ranking, position);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRankingTile(_UserRanking ranking, int position) {
    Color? medalColor;
    IconData? medalIcon;

    if (position == 1) {
      medalColor = Colors.amber;
      medalIcon = Icons.emoji_events;
    } else if (position == 2) {
      medalColor = Colors.grey;
      medalIcon = Icons.emoji_events;
    } else if (position == 3) {
      medalColor = Colors.brown;
      medalIcon = Icons.emoji_events;
    }

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      leading: SizedBox(
        width: 50,
        child: Row(
          children: [
            if (medalIcon != null)
              Icon(medalIcon, color: medalColor, size: 28)
            else
              SizedBox(
                width: 28,
                child: Text(
                  '#$position',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            const SizedBox(width: 12),
          ],
        ),
      ),
      title: Text(
        ranking.username,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: LinearProgressIndicator(
        value: ranking.totalXp / (ranking.totalXp > 1000 ? ranking.totalXp : 1000),
        backgroundColor: Colors.grey.shade200,
        valueColor: AlwaysStoppedAnimation<Color>(
          position <= 3 ? (medalColor ?? Colors.blue) : Colors.blue,
        ),
      ),
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: position <= 3
              ? (medalColor?.withValues(alpha: 0.2) ?? Colors.blue.shade50)
              : Colors.blue.shade50,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.stars,
              size: 18,
              color: position <= 3 ? medalColor : Colors.blue,
            ),
            const SizedBox(width: 6),
            Text(
              '${ranking.totalXp}',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: position <= 3 ? medalColor : Colors.blue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.leaderboard,
              size: 100,
              color: Colors.grey.shade300,
            ),
            const SizedBox(height: 24),
            Text(
              'No Rankings Yet',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Join a group and start learning\nto see rankings!',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text(
              'Failed to load leaderboard',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              error,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatShortDate(DateTime date) {
    return '${date.day}/${date.month}';
  }
}

/// Internal class for aggregated user rankings
class _UserRanking {
  final String username;
  final int totalXp;

  _UserRanking({required this.username, required this.totalXp});
}

