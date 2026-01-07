import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../domain/models/report.dart';
import '../providers/progress_providers.dart';
import '../widgets/pronunciation_trend_chart.dart';

class WeeklyReportScreen extends ConsumerStatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  ConsumerState<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends ConsumerState<WeeklyReportScreen> {
  int _currentWeek = _getCurrentWeekNumber();

  static int _getCurrentWeekNumber() {
    final now = DateTime.now();
    final firstDayOfYear = DateTime(now.year, 1, 1);
    final daysSinceFirstDay = now.difference(firstDayOfYear).inDays;
    return (daysSinceFirstDay / 7).floor() + 1;
  }

  @override
  Widget build(BuildContext context) {
    final reportAsync = ref.watch(weeklyReportProvider(_currentWeek));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        elevation: 0,
      ),
      body: reportAsync.when(
        data: (report) => _buildReportContent(report),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error loading report: $error'),
        ),
      ),
    );
  }

  Widget _buildReportContent(WeeklyReport report) {
    return RefreshIndicator(
      onRefresh: () async {
        ref.invalidate(weeklyReportProvider);
      },
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Week Header
            _buildWeekHeader(report),
            const SizedBox(height: 24),

            // Summary Card
            _buildSummaryCard(report.summary),
            const SizedBox(height: 24),

            // Achievements
            if (report.achievements.isNotEmpty) ...[
              Text('Achievements This Week', style: AppTextStyles.h3),
              const SizedBox(height: 12),
              _buildAchievements(report.achievements),
              const SizedBox(height: 24),
            ],

            // Pronunciation Trend
            Text('Pronunciation Trend', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            PronunciationTrendChart(
              dailyScores: report.pronunciationTrend,
              labels: _generateDayLabels(7),
            ),
            const SizedBox(height: 24),

            // Top Corrections
            Text('Top Corrections', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            _buildTopCorrections(report.topCorrections),
            const SizedBox(height: 24),

            // Vocabulary Progress
            Text('Vocabulary Progress', style: AppTextStyles.h3),
            const SizedBox(height: 12),
            _buildVocabularyProgress(report.vocabularyProgress),
            const SizedBox(height: 24),

            // Share Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  // Share report
                },
                icon: const Icon(Icons.share),
                label: const Text('Share Report'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekHeader(WeeklyReport report) {
    return Container(
      padding: const EdgeInsets.all(16),
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
          IconButton(
            onPressed: () => setState(() => _currentWeek--),
            icon: const Icon(Icons.chevron_left, color: Colors.white),
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  'Week ${report.weekNumber}',
                  style: AppTextStyles.h2.copyWith(color: Colors.white),
                ),
                Text(
                  '${_formatDate(report.startDate)} - ${_formatDate(report.endDate)}',
                  style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: _currentWeek < _getCurrentWeekNumber()
                ? () => setState(() => _currentWeek++)
                : null,
            icon: const Icon(Icons.chevron_right, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(ReportSummary summary) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Summary', style: AppTextStyles.h3),
          const SizedBox(height: 16),
          _buildSummaryRow(Icons.chat_bubble, 'Conversations', '${summary.totalConversations}'),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.access_time, 'Practice Time', '${summary.totalMinutes} min'),
          const SizedBox(height: 12),
          _buildSummaryRow(Icons.star, 'XP Earned', '${summary.totalXp}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primary, size: 24),
        const SizedBox(width: 12),
        Expanded(
          child: Text(label, style: AppTextStyles.bodyMedium),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _buildAchievements(List<Achievement> achievements) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: achievements.map((achievement) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.success.withOpacity(0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.emoji_events, color: AppColors.success, size: 20),
              const SizedBox(width: 8),
              Text(
                achievement.name,
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.success),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTopCorrections(List<TopCorrection> corrections) {
    if (corrections.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            'No corrections this week',
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: corrections.map((correction) {
          return ListTile(
            leading: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${correction.count}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            title: Text(correction.type, style: AppTextStyles.bodyMedium),
            subtitle: Text(
              correction.example,
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildVocabularyProgress(VocabularyProgress progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                Text(
                  '${progress.newWords}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.primary),
                ),
                const SizedBox(height: 4),
                Text(
                  'New Words',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          Container(
            width: 1,
            height: 40,
            color: Colors.grey.shade300,
          ),
          Expanded(
            child: Column(
              children: [
                Text(
                  '${progress.masteredWords}',
                  style: AppTextStyles.h2.copyWith(color: AppColors.success),
                ),
                const SizedBox(height: 4),
                Text(
                  'Mastered',
                  style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}';
  }

  List<String> _generateDayLabels(int days) {
    final labels = <String>[];
    final dayNames = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    for (int i = 0; i < days; i++) {
      labels.add(dayNames[i % 7]);
    }
    return labels;
  }
}
