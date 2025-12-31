import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import '../../domain/models/ranking.dart';
import '../widgets/ranking_list_item.dart';

/// Leaderboard screen displaying weekly rankings with league tabs
class LeaderboardScreen extends ConsumerStatefulWidget {
  const LeaderboardScreen({super.key});

  @override
  ConsumerState<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends ConsumerState<LeaderboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  League _selectedLeague = League.bronze;
  Timer? _weekResetTimer;
  Duration _timeUntilReset = Duration.zero;

  final List<League> _leagues = [
    League.bronze,
    League.silver,
    League.gold,
    League.platinum,
    League.diamond,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _leagues.length,
      vsync: this,
    );
    _tabController.addListener(_onTabChanged);
    _startWeekResetTimer();
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    _weekResetTimer?.cancel();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedLeague = _leagues[_tabController.index];
      });
    }
  }

  void _startWeekResetTimer() {
    // Calculate time until next Monday 00:00
    final now = DateTime.now();
    final nextMonday = now.add(Duration(days: (8 - now.weekday) % 7));
    final resetTime = DateTime(
      nextMonday.year,
      nextMonday.month,
      nextMonday.day,
    );
    _timeUntilReset = resetTime.difference(now);

    _weekResetTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _timeUntilReset = _timeUntilReset - const Duration(seconds: 1);
        if (_timeUntilReset.isNegative) {
          _timeUntilReset = const Duration(days: 7);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Leaderboard'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildLeagueTabs(),
        ),
      ),
      body: Column(
        children: [
          _buildWeekHeader(),
          Expanded(child: _buildRankingList()),
        ],
      ),
    );
  }

  Widget _buildLeagueTabs() {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        indicatorColor: Theme.of(context).colorScheme.primary,
        labelColor: Theme.of(context).colorScheme.primary,
        unselectedLabelColor: Colors.grey,
        labelStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
        ),
        tabs: _leagues.map((league) {
          return Tab(
            child: Row(
              children: [
                Icon(
                  Icons.shield,
                  size: 20,
                  color: Color(int.parse(league.color.replaceFirst('#', '0xFF'))),
                ),
                const SizedBox(width: 8),
                Text(league.displayName),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildWeekHeader() {
    final now = DateTime.now();
    final weekNumber = _getWeekNumber(now);
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Column(
        children: [
          Text(
            'Week $weekNumber',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '${_formatDate(weekStart)} - ${_formatDate(weekEnd)}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.timer,
                size: 16,
                color: Colors.grey.shade700,
              ),
              const SizedBox(width: 4),
              Text(
                'Resets in ${_formatDuration(_timeUntilReset)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRankingList() {
    // Mock data - will be replaced with provider in WP-FE-011-T007
    final mockData = _getMockRankingData();

    return RefreshIndicator(
      onRefresh: _onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: mockData.rankings.length,
        itemBuilder: (context, index) {
          final entry = mockData.rankings[index];
          final isTopThree = entry.rank <= 3;

          // Determine zone
          RankZone? zone;
          if (entry.rank <= mockData.promotionThreshold) {
            zone = RankZone.promotion;
          } else if (entry.rank >= mockData.demotionThreshold) {
            zone = RankZone.demotion;
          } else {
            zone = RankZone.safe;
          }

          return RankingListItem(
            entry: entry,
            zone: zone,
            isTopThree: isTopThree,
          );
        },
      ),
    );
  }

  Future<void> _onRefresh() async {
    // Refresh ranking data - will be implemented with providers
    await Future.delayed(const Duration(seconds: 1));
  }

  int _getWeekNumber(DateTime date) {
    final firstDayOfYear = DateTime(date.year, 1, 1);
    final daysSinceFirstDay = date.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).ceil() + 1;
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[date.month - 1]} ${date.day}';
  }

  String _formatDuration(Duration duration) {
    final days = duration.inDays;
    final hours = duration.inHours % 24;
    final minutes = duration.inMinutes % 60;

    if (days > 0) {
      return '${days}d ${hours}h';
    } else if (hours > 0) {
      return '${hours}h ${minutes}m';
    } else {
      return '${minutes}m';
    }
  }

  // Mock data for testing UI
  RankingResponse _getMockRankingData() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return RankingResponse(
      league: _selectedLeague,
      weekNumber: _getWeekNumber(now),
      weekStart: weekStart,
      weekEnd: weekEnd,
      promotionThreshold: 3,
      demotionThreshold: 18,
      currentUserRank: UserRankInfo(
        rank: 8,
        weeklyXp: 1250,
        league: _selectedLeague,
        zone: RankZone.safe,
        xpToPromotion: 350,
        xpToDemotion: 0,
      ),
      rankings: [
        RankingEntry(
          rank: 1,
          userId: '1',
          userName: 'Sarah Chen',
          avatarUrl: null,
          weeklyXp: 2450,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 2,
          userId: '2',
          userName: 'Mike Johnson',
          avatarUrl: null,
          weeklyXp: 2180,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 3,
          userId: '3',
          userName: 'Emily Davis',
          avatarUrl: null,
          weeklyXp: 1980,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 4,
          userId: '4',
          userName: 'James Wilson',
          avatarUrl: null,
          weeklyXp: 1850,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 5,
          userId: '5',
          userName: 'Anna Martinez',
          avatarUrl: null,
          weeklyXp: 1720,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 6,
          userId: '6',
          userName: 'David Lee',
          avatarUrl: null,
          weeklyXp: 1580,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 7,
          userId: '7',
          userName: 'Lisa Brown',
          avatarUrl: null,
          weeklyXp: 1420,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 8,
          userId: 'current',
          userName: 'You',
          avatarUrl: null,
          weeklyXp: 1250,
          league: _selectedLeague,
          isCurrentUser: true,
        ),
        RankingEntry(
          rank: 9,
          userId: '9',
          userName: 'Tom Anderson',
          avatarUrl: null,
          weeklyXp: 1180,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 10,
          userId: '10',
          userName: 'Maria Garcia',
          avatarUrl: null,
          weeklyXp: 1050,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        // Safe zone continues...
        RankingEntry(
          rank: 17,
          userId: '17',
          userName: 'Chris Taylor',
          avatarUrl: null,
          weeklyXp: 520,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        // Demotion zone
        RankingEntry(
          rank: 18,
          userId: '18',
          userName: 'Alex Kim',
          avatarUrl: null,
          weeklyXp: 480,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 19,
          userId: '19',
          userName: 'Sophie White',
          avatarUrl: null,
          weeklyXp: 420,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
        RankingEntry(
          rank: 20,
          userId: '20',
          userName: 'Ryan Clark',
          avatarUrl: null,
          weeklyXp: 350,
          league: _selectedLeague,
          isCurrentUser: false,
        ),
      ],
    );
  }
}
