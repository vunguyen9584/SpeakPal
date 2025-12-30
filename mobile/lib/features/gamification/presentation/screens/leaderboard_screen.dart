import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/ranking.dart';

class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen> {
  String _selectedLeague = 'bronze';
  final _leagues = ['bronze', 'silver', 'gold', 'platinum', 'diamond'];

  @override
  Widget build(BuildContext context) {
    // TODO: Use leaderboardProvider
    final leaderboard = Leaderboard(
      league: _selectedLeague,
      rankings: [],
      currentUser: null,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: _showLeagueInfo,
          ),
        ],
      ),
      body: Column(
        children: [
          // League selector
          Container(
            padding: const EdgeInsets.all(16),
            color: _getLeagueColor(_selectedLeague).withOpacity(0.1),
            child: Column(
              children: [
                Text(
                  '${_selectedLeague[0].toUpperCase()}${_selectedLeague.substring(1)} League',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _getLeagueColor(_selectedLeague),
                      ),
                ),
                const SizedBox(height: 8),
                const Text('Weekly Competition'),
                const SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: _leagues.map((league) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: ChoiceChip(
                          label: Text(league[0].toUpperCase() + league.substring(1)),
                          selected: _selectedLeague == league,
                          selectedColor: _getLeagueColor(league).withOpacity(0.3),
                          onSelected: (selected) {
                            setState(() {
                              _selectedLeague = league;
                            });
                          },
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),

          // Top 3 podium
          if (leaderboard.rankings.length >= 3)
            Container(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  _buildPodiumCard(
                    context,
                    leaderboard.rankings[1],
                    2,
                    Colors.grey,
                    120,
                  ),
                  const SizedBox(width: 16),
                  _buildPodiumCard(
                    context,
                    leaderboard.rankings[0],
                    1,
                    Colors.amber,
                    140,
                  ),
                  const SizedBox(width: 16),
                  _buildPodiumCard(
                    context,
                    leaderboard.rankings[2],
                    3,
                    Colors.brown,
                    100,
                  ),
                ],
              ),
            ),

          // Rankings list
          Expanded(
            child: leaderboard.rankings.isEmpty
                ? const Center(child: Text('No rankings available'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: leaderboard.rankings.length > 3
                        ? leaderboard.rankings.length - 3
                        : 0,
                    itemBuilder: (context, index) {
                      final ranking = leaderboard.rankings[index + 3];
                      return RankingListItem(ranking: ranking);
                    },
                  ),
          ),

          // Current user position
          if (leaderboard.currentUser != null)
            Container(
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: Border(
                  top: BorderSide(color: Colors.blue, width: 2),
                ),
              ),
              child: RankingListItem(
                ranking: leaderboard.currentUser!,
                highlight: true,
              ),
            ),

          // League info
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[100],
            child: Row(
              children: [
                Icon(Icons.trending_up, color: Colors.green, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Top 10 get promoted | Bottom 10 get demoted',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPodiumCard(
    BuildContext context,
    RankingEntry ranking,
    int place,
    Color color,
    double height,
  ) {
    return Column(
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: color.withOpacity(0.2),
          child: ranking.avatarUrl != null
              ? ClipOval(child: Image.network(ranking.avatarUrl!))
              : Text(
                  ranking.displayName[0].toUpperCase(),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
        ),
        const SizedBox(height: 4),
        Text(
          ranking.displayName,
          style: Theme.of(context).textTheme.bodySmall,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          '${ranking.weeklyXp} XP',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 60,
          height: height,
          decoration: BoxDecoration(
            color: color.withOpacity(0.3),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                place == 1
                    ? Icons.emoji_events
                    : place == 2
                        ? Icons.workspace_premium
                        : Icons.military_tech,
                color: color,
                size: 32,
              ),
              Text(
                '#$place',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Color _getLeagueColor(String league) {
    switch (league.toLowerCase()) {
      case 'bronze':
        return Colors.brown;
      case 'silver':
        return Colors.grey;
      case 'gold':
        return Colors.amber;
      case 'platinum':
        return Colors.cyan;
      case 'diamond':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showLeagueInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('League System'),
        content: const Text(
          'Compete weekly with others in your league!\n\n'
          '• Top 10 players get promoted to higher league\n'
          '• Bottom 10 players get demoted\n'
          '• Rankings reset every Monday\n'
          '• Earn XP by practicing conversations and completing challenges',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}

class RankingListItem extends StatelessWidget {
  final RankingEntry ranking;
  final bool highlight;

  const RankingListItem({
    Key? key,
    required this.ranking,
    this.highlight = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: highlight ? Colors.blue[100] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: highlight
            ? Border.all(color: Colors.blue, width: 2)
            : Border.all(color: Colors.grey[300]!),
      ),
      child: Row(
        children: [
          // Rank
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: _getRankColor(ranking.rank).withOpacity(0.2),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Center(
              child: Text(
                '#${ranking.rank}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: _getRankColor(ranking.rank),
                ),
              ),
            ),
          ),

          const SizedBox(width: 12),

          // Avatar
          CircleAvatar(
            radius: 20,
            backgroundColor: Colors.grey[300],
            child: ranking.avatarUrl != null
                ? ClipOval(child: Image.network(ranking.avatarUrl!))
                : Text(
                    ranking.displayName[0].toUpperCase(),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
          ),

          const SizedBox(width: 12),

          // Name and level
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        ranking.displayName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (ranking.isCurrentUser) ...[
                      const SizedBox(width: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'YOU',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(
                  'Level ${ranking.level}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),

          // XP
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${ranking.weeklyXp}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const Text(
                'XP',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    if (rank <= 3) return Colors.amber;
    if (rank <= 10) return Colors.green;
    if (rank >= 40) return Colors.red;
    return Colors.blue;
  }
}
