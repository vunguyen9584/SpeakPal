import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/theme/app_colors.dart';
import 'package:mobile/core/theme/app_text_styles.dart';
import '../../domain/models/stats.dart';
import '../providers/progress_providers.dart';
import '../widgets/stat_card.dart';
import '../widgets/pronunciation_gauge.dart';

class StatisticsScreen extends ConsumerStatefulWidget {
  const StatisticsScreen({super.key});

  @override
  ConsumerState<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends ConsumerState<StatisticsScreen> {
  StatsPeriod _selectedPeriod = StatsPeriod.today;

  @override
  Widget build(BuildContext context) {
    final statsAsync = ref.watch(statsProvider(_selectedPeriod));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistics'),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Period Selector
          _buildPeriodSelector(),

          // Stats Content
          Expanded(
            child: statsAsync.when(
              data: (stats) => _buildStatsContent(stats),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Center(
                child: Text('Error loading stats: $error'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildPeriodChip('Today', StatsPeriod.today),
          const SizedBox(width: 8),
          _buildPeriodChip('This Week', StatsPeriod.thisWeek),
          const SizedBox(width: 8),
          _buildPeriodChip('This Month', StatsPeriod.thisMonth),
          const SizedBox(width: 8),
          _buildPeriodChip('All Time', StatsPeriod.allTime),
        ],
      ),
    );
  }

  Widget _buildPeriodChip(String label, StatsPeriod period) {
    final isSelected = _selectedPeriod == period;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedPeriod = period),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySmall.copyWith(
              color: isSelected ? Colors.white : AppColors.textSecondary,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatsContent(Stats stats) {
    final currentStats = _getCurrentStats(stats);

    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(statsProvider);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Key Metrics
            Text(
              'Key Metrics',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.chat_bubble,
                    label: 'Conversations',
                    value: currentStats['conversations'].toString(),
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.access_time,
                    label: 'Minutes',
                    value: currentStats['minutes'].toString(),
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    icon: Icons.star,
                    label: 'XP Earned',
                    value: currentStats['xp'].toString(),
                    color: AppColors.warning,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatCard(
                    icon: Icons.book,
                    label: 'Vocabulary',
                    value: currentStats['vocabulary'].toString(),
                    color: AppColors.success,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // Pronunciation Average
            Text(
              'Pronunciation Score',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            PronunciationGauge(score: stats.averagePronunciation),

            const SizedBox(height: 32),

            // Current Streak
            Text(
              'Current Streak',
              style: AppTextStyles.h3,
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primary.withOpacity(0.7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_fire_department,
                    size: 48,
                    color: Colors.white,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${stats.currentStreak} days',
                        style: AppTextStyles.h2.copyWith(color: Colors.white),
                      ),
                      Text(
                        'Keep it up!',
                        style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _getCurrentStats(Stats stats) {
    switch (_selectedPeriod) {
      case StatsPeriod.today:
        return {
          'conversations': stats.daily.conversations,
          'minutes': stats.daily.minutes,
          'xp': stats.daily.xp,
          'vocabulary': stats.daily.vocabulary,
        };
      case StatsPeriod.thisWeek:
        return {
          'conversations': stats.weekly.conversations,
          'minutes': stats.weekly.minutes,
          'xp': stats.weekly.xp,
          'vocabulary': stats.weekly.vocabulary,
        };
      case StatsPeriod.thisMonth:
        return {
          'conversations': stats.monthly.conversations,
          'minutes': stats.monthly.minutes,
          'xp': stats.monthly.xp,
          'vocabulary': stats.monthly.vocabulary,
        };
      case StatsPeriod.allTime:
        return {
          'conversations': stats.allTime.totalConversations,
          'minutes': stats.allTime.totalMinutes,
          'xp': stats.allTime.totalXp,
          'vocabulary': 0, // Not tracked in all-time
        };
    }
  }
}
