import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:math' as math;
import '../../domain/models/stats.dart';
import '../widgets/stat_card.dart';

/// Statistics dashboard screen displaying key metrics and progress
class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  StatsPeriod _selectedPeriod = StatsPeriod.week;

  final List<StatsPeriod> _periods = [
    StatsPeriod.today,
    StatsPeriod.week,
    StatsPeriod.month,
    StatsPeriod.allTime,
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: _periods.length,
      vsync: this,
      initialIndex: 1, // Default to "This Week"
    );
    _tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _tabController.removeListener(_onTabChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (_tabController.indexIsChanging) {
      setState(() {
        _selectedPeriod = _periods[_tabController.index];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(48),
          child: _buildPeriodSelector(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: _buildContent(),
      ),
    );
  }

  Widget _buildPeriodSelector() {
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
        tabs: _periods.map((period) {
          return Tab(text: period.displayName);
        }).toList(),
      ),
    );
  }

  Widget _buildContent() {
    // Mock data - will be replaced with provider in WP-FE-012-T006
    final stats = _getMockStats();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Key metrics grid
          _buildMetricsGrid(stats),
          const SizedBox(height: 24),

          // Pronunciation gauge
          _buildPronunciationGauge(stats.pronunciationAverage),
          const SizedBox(height: 24),

          // Current streak
          _buildStreakCard(stats.currentStreak),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(Stats stats) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 1.1,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        StatCard(
          icon: Icons.chat_bubble,
          label: 'Conversations',
          value: stats.totalConversations.toString(),
          color: Colors.blue,
        ),
        StatCard(
          icon: Icons.access_time,
          label: 'Practice Minutes',
          value: stats.totalMinutes.toString(),
          color: Colors.green,
        ),
        StatCard(
          icon: Icons.stars,
          label: 'XP Earned',
          value: stats.totalXp.toString(),
          color: Colors.orange,
        ),
        StatCard(
          icon: Icons.book,
          label: 'Vocabulary',
          value: stats.vocabularyCount.toString(),
          color: Colors.purple,
        ),
      ],
    );
  }

  Widget _buildPronunciationGauge(double average) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Pronunciation Average',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 24),

          // Gauge
          SizedBox(
            height: 160,
            child: CustomPaint(
              painter: _GaugePainter(
                value: average,
                color: _getGaugeColor(average),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      average.toStringAsFixed(0),
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: _getGaugeColor(average),
                      ),
                    ),
                    Text(
                      '/ 100',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Rating
          Text(
            _getPronunciationRating(average),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: _getGaugeColor(average),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStreakCard(int streak) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.orange.shade400,
            Colors.red.shade400,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.orange.withOpacity(0.3),
            blurRadius: 10,
            spreadRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_fire_department,
              size: 36,
              color: Colors.white,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current Streak',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.9),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  baseline: TextBaseline.alphabetic,
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  children: [
                    Text(
                      streak.toString(),
                      style: const TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      streak == 1 ? 'day' : 'days',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getGaugeColor(double value) {
    if (value >= 80) return Colors.green;
    if (value >= 60) return Colors.blue;
    if (value >= 40) return Colors.orange;
    return Colors.red;
  }

  String _getPronunciationRating(double value) {
    if (value >= 90) return 'Excellent';
    if (value >= 80) return 'Very Good';
    if (value >= 70) return 'Good';
    if (value >= 60) return 'Fair';
    if (value >= 50) return 'Needs Improvement';
    return 'Poor';
  }

  Future<void> _onRefresh() async {
    // Refresh stats data - will be implemented with providers
    await Future.delayed(const Duration(seconds: 1));
  }

  // Mock data for testing UI
  Stats _getMockStats() {
    final now = DateTime.now();
    switch (_selectedPeriod) {
      case StatsPeriod.today:
        return Stats(
          totalConversations: 3,
          totalMinutes: 45,
          totalXp: 180,
          vocabularyCount: 12,
          pronunciationAverage: 78.5,
          currentStreak: 7,
          period: StatsPeriod.today,
          startDate: now,
          endDate: now,
        );
      case StatsPeriod.week:
        return Stats(
          totalConversations: 18,
          totalMinutes: 240,
          totalXp: 1250,
          vocabularyCount: 65,
          pronunciationAverage: 82.3,
          currentStreak: 7,
          period: StatsPeriod.week,
          startDate: now.subtract(const Duration(days: 6)),
          endDate: now,
        );
      case StatsPeriod.month:
        return Stats(
          totalConversations: 72,
          totalMinutes: 960,
          totalXp: 4800,
          vocabularyCount: 248,
          pronunciationAverage: 85.7,
          currentStreak: 7,
          period: StatsPeriod.month,
          startDate: now.subtract(const Duration(days: 29)),
          endDate: now,
        );
      case StatsPeriod.allTime:
        return Stats(
          totalConversations: 156,
          totalMinutes: 2340,
          totalXp: 12580,
          vocabularyCount: 542,
          pronunciationAverage: 87.2,
          currentStreak: 7,
          period: StatsPeriod.allTime,
          startDate: now.subtract(const Duration(days: 90)),
          endDate: now,
        );
    }
  }
}

/// Custom painter for the pronunciation gauge
class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;

  _GaugePainter({
    required this.value,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height - 20);
    final radius = math.min(size.width, size.height - 40) / 2;

    // Background arc
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      math.pi,
      false,
      backgroundPaint,
    );

    // Value arc
    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (value / 100) * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi,
      sweepAngle,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(_GaugePainter oldDelegate) {
    return oldDelegate.value != value || oldDelegate.color != color;
  }
}
