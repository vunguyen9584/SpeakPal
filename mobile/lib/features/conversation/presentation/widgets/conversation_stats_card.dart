import 'package:flutter/material.dart';
import '../../presentation/providers/summary_provider.dart';

class ConversationStatsCard extends StatelessWidget {
  final ConversationSummary summary;

  const ConversationStatsCard({
    Key? key,
    required this.summary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Icon(
              Icons.celebration,
              size: 56,
              color: Colors.amber[600],
            ),
            const SizedBox(height: 12),
            Text(
              'Great job!',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatItem(
                  context,
                  icon: Icons.timer,
                  label: 'Duration',
                  value: _formatDuration(summary.durationSeconds),
                ),
                _buildStatItem(
                  context,
                  icon: Icons.mic,
                  label: 'Pronunciation',
                  value: '${summary.pronunciationScore}/100',
                  color: _getScoreColor(summary.pronunciationScore),
                ),
                _buildStatItem(
                  context,
                  icon: Icons.star,
                  label: 'XP Earned',
                  value: '+${summary.xpEarned}',
                  color: Colors.amber[700],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? color,
  }) {
    return Column(
      children: [
        Icon(
          icon,
          size: 32,
          color: color ?? Theme.of(context).primaryColor,
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }

  String _formatDuration(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  Color _getScoreColor(int score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }
}
