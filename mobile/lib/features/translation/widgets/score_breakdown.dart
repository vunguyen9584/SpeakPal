import 'package:flutter/material.dart';
import '../models/translation_result.dart';

class ScoreBreakdownWidget extends StatelessWidget {
  final ScoreBreakdown breakdown;

  const ScoreBreakdownWidget({
    required this.breakdown,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'スコア内訳',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildScoreBar(
          context,
          '文法',
          breakdown.grammarScore,
          40,
          Colors.blue,
        ),
        const SizedBox(height: 8),
        _buildScoreBar(
          context,
          '語彙',
          breakdown.vocabularyScore,
          30,
          Colors.green,
        ),
        const SizedBox(height: 8),
        _buildScoreBar(
          context,
          'スピード',
          breakdown.speedScore,
          30,
          Colors.orange,
        ),
      ],
    );
  }

  Widget _buildScoreBar(
    BuildContext context,
    String label,
    int score,
    int maxScore,
    Color color,
  ) {
    final percentage = (score / maxScore).clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label),
            Text(
              '$score/$maxScore',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage,
            backgroundColor: color.withValues(alpha: 0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

