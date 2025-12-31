import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import '../../domain/models/report.dart';

/// Weekly report screen displaying detailed week summary
class WeeklyReportScreen extends StatefulWidget {
  const WeeklyReportScreen({super.key});

  @override
  State<WeeklyReportScreen> createState() => _WeeklyReportScreenState();
}

class _WeeklyReportScreenState extends State<WeeklyReportScreen> {
  int _currentWeekNumber = 52;

  @override
  Widget build(BuildContext context) {
    // Mock data - will be replaced with provider in WP-FE-012-T006
    final report = _getMockWeeklyReport(_currentWeekNumber);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Report'),
        actions: [
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () => _onSharePressed(report),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildWeekHeader(report),
            const SizedBox(height: 24),
            _buildSummaryCard(report.summary),
            const SizedBox(height: 24),
            _buildAchievementsSection(report.achievements),
            const SizedBox(height: 24),
            _buildPronunciationComparison(report.pronunciationComparison),
            const SizedBox(height: 24),
            _buildTopCorrections(report.topCorrections),
            const SizedBox(height: 24),
            _buildVocabularyHighlights(report.vocabularyHighlights),
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
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentWeekNumber--;
                  });
                },
              ),
              Column(
                children: [
                  Text(
                    'Week ${report.weekNumber}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDateRange(report.weekStart, report.weekEnd),
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right, color: Colors.white),
                onPressed: () {
                  setState(() {
                    _currentWeekNumber++;
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(WeeklyReportSummary summary) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Week Summary',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  Icons.chat_bubble,
                  summary.conversations.toString(),
                  'Conversations',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  Icons.access_time,
                  summary.minutes.toString(),
                  'Minutes',
                  Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildSummaryItem(
                  Icons.stars,
                  summary.xpEarned.toString(),
                  'XP Earned',
                  Colors.orange,
                ),
              ),
              Expanded(
                child: _buildSummaryItem(
                  Icons.book,
                  summary.vocabularyLearned.toString(),
                  'Vocabulary',
                  Colors.purple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildAchievementsSection(List<WeeklyAchievement> achievements) {
    if (achievements.isEmpty) {
      return const SizedBox.shrink();
    }

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.emoji_events, color: Colors.amber.shade600),
              const SizedBox(width: 8),
              Text(
                'Achievements This Week',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...achievements.map((achievement) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.amber.shade100,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _getAchievementIcon(achievement.type),
                      color: Colors.amber.shade700,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          achievement.title,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          achievement.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildPronunciationComparison(PronunciationComparison comparison) {
    final isImprovement = comparison.improvement >= 0;

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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pronunciation Progress',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'This Week',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comparison.thisWeek.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                isImprovement ? Icons.trending_up : Icons.trending_down,
                color: isImprovement ? Colors.green : Colors.red,
                size: 48,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      'Last Week',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      comparison.lastWeek.toStringAsFixed(1),
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: isImprovement ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  isImprovement ? Icons.arrow_upward : Icons.arrow_downward,
                  color: isImprovement ? Colors.green.shade700 : Colors.orange.shade700,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  '${comparison.improvement.abs().toStringAsFixed(1)} points ${isImprovement ? 'improvement' : 'decline'}',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isImprovement ? Colors.green.shade700 : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopCorrections(List<TopCorrection> corrections) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Top Corrections',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          ...corrections.map((correction) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        correction.errorType,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '${correction.count}x',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if (correction.examples.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      'Example: ${correction.examples.first}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildVocabularyHighlights(VocabularyHighlights highlights) {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vocabulary Highlights',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildHighlightItem(
                  Icons.add_circle,
                  highlights.newWords.toString(),
                  'New Words',
                  Colors.blue,
                ),
              ),
              Expanded(
                child: _buildHighlightItem(
                  Icons.check_circle,
                  highlights.masteredWords.toString(),
                  'Mastered',
                  Colors.green,
                ),
              ),
            ],
          ),
          if (highlights.topWords.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              'Top Words',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade700,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: highlights.topWords.map((word) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.purple.shade100,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    word,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.purple.shade700,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHighlightItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 32),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  IconData _getAchievementIcon(String type) {
    switch (type) {
      case 'badge':
        return Icons.stars;
      case 'level_up':
        return Icons.trending_up;
      default:
        return Icons.emoji_events;
    }
  }

  String _formatDateRange(DateTime start, DateTime end) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
                    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${months[start.month - 1]} ${start.day} - ${months[end.month - 1]} ${end.day}';
  }

  void _onSharePressed(WeeklyReport report) {
    final shareText = '''
📊 My Week ${report.weekNumber} Report

✅ ${report.summary.conversations} Conversations
⏱️ ${report.summary.minutes} Minutes
⭐ ${report.summary.xpEarned} XP Earned
📚 ${report.summary.vocabularyLearned} New Words

Keep learning with SpeakPal!
    ''';

    Share.share(shareText, subject: 'Weekly Progress Report');
  }

  // Mock data for testing UI
  WeeklyReport _getMockWeeklyReport(int weekNumber) {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekEnd = weekStart.add(const Duration(days: 6));

    return WeeklyReport(
      weekNumber: weekNumber,
      weekStart: weekStart,
      weekEnd: weekEnd,
      summary: const WeeklyReportSummary(
        conversations: 18,
        minutes: 240,
        xpEarned: 1250,
        vocabularyLearned: 65,
      ),
      achievements: [
        WeeklyAchievement(
          type: 'badge',
          title: '7-Day Streak Badge',
          description: 'Practiced for 7 consecutive days',
          achievedAt: now.subtract(const Duration(days: 2)),
        ),
        WeeklyAchievement(
          type: 'level_up',
          title: 'Reached Level 6',
          description: 'Leveled up from 5 to 6',
          achievedAt: now.subtract(const Duration(days: 4)),
        ),
      ],
      pronunciationComparison: const PronunciationComparison(
        thisWeek: 82.5,
        lastWeek: 78.3,
        improvement: 4.2,
      ),
      topCorrections: const [
        TopCorrection(
          errorType: 'Pronunciation: "th" sound',
          count: 8,
          examples: ['thing → ting'],
        ),
        TopCorrection(
          errorType: 'Grammar: Present Perfect',
          count: 5,
          examples: ['I have went → I have gone'],
        ),
        TopCorrection(
          errorType: 'Vocabulary: Prepositions',
          count: 4,
          examples: ['depend of → depend on'],
        ),
      ],
      vocabularyHighlights: const VocabularyHighlights(
        newWords: 65,
        masteredWords: 12,
        topWords: ['enthusiasm', 'magnificent', 'sophisticated', 'resilient', 'extraordinary'],
      ),
    );
  }
}
