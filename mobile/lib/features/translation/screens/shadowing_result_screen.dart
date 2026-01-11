import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/shadowing_models.dart';

class ShadowingResultScreen extends ConsumerWidget {
  final ShadowingResult result;

  const ShadowingResultScreen({
    required this.result,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('シャドーイング結果'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Overall score
            _buildScoreCircle(context, result.overallScore)
                .animate()
                .scale(duration: 600.ms, curve: Curves.elasticOut),
            
            const SizedBox(height: 32),
            
            // Score breakdown
            _buildScoreBreakdown(context, result.breakdown),
            
            const SizedBox(height: 32),
            
            // Weak segments
            if (result.weakSegments.isNotEmpty) ...[
              _buildWeakSegments(context, result.weakSegments),
              const SizedBox(height: 32),
            ],
            
            // Feedback
            _buildFeedback(context, result.feedback),
            
            const SizedBox(height: 32),
            
            // XP earned
            _buildXPDisplay(context, result.xpEarned),
            
            const SizedBox(height: 24),
            
            // Action buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('もう一度'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pop(context);
                    },
                    child: const Text('別のコンテンツ'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCircle(BuildContext context, int score) {
    Color color;
    if (score >= 80) {
      color = Colors.green;
    } else if (score >= 60) {
      color = Colors.orange;
    } else {
      color = Colors.red;
    }

    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color, width: 4),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$score',
              style: TextStyle(
                fontSize: 48,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              '点',
              style: TextStyle(
                fontSize: 16,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreBreakdown(
    BuildContext context,
    ShadowingScoreBreakdown breakdown,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'スコア内訳',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        _buildScoreBar(context, 'フォロー', breakdown.followingScore, 20, Colors.blue),
        const SizedBox(height: 12),
        _buildScoreBar(context, '発音', breakdown.pronunciationScore, 40, Colors.green),
        const SizedBox(height: 12),
        _buildScoreBar(context, 'リズム', breakdown.rhythmScore, 20, Colors.purple),
        const SizedBox(height: 12),
        _buildScoreBar(context, '完成度', breakdown.completenessScore, 20, Colors.orange),
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
            minHeight: 10,
          ),
        ),
      ],
    );
  }

  Widget _buildWeakSegments(BuildContext context, List<WeakSegment> segments) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '苦手なパート',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...segments.map((segment) => Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.shade100,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          '${_formatTime(segment.startTime)} - ${_formatTime(segment.endTime)}',
                          style: TextStyle(
                            color: Colors.red.shade900,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Chip(
                        label: Text(
                          _getIssueLabel(segment.issueType),
                          style: const TextStyle(fontSize: 11),
                        ),
                        backgroundColor: _getIssueColor(segment.issueType),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(segment.text),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          _playModelAudio(context, segment);
                        },
                        icon: const Icon(Icons.volume_up, size: 16),
                        label: const Text('モデル音声'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        onPressed: () {
                          _playUserAudio(context, segment);
                        },
                        icon: const Icon(Icons.mic, size: 16),
                        label: const Text('あなたの音声'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )),
      ],
    );
  }

  Widget _buildFeedback(BuildContext context, List<String> feedback) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'フィードバック',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...feedback.map((item) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Colors.green, size: 20),
              const SizedBox(width: 8),
              Expanded(child: Text(item)),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildXPDisplay(BuildContext context, int xp) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.purple.shade400, Colors.purple.shade600],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.stars, color: Colors.white, size: 32),
          const SizedBox(width: 12),
          Text(
            '+$xp XP',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    ).animate().shimmer(duration: 1500.ms);
  }

  String _formatTime(double seconds) {
    final minutes = seconds ~/ 60;
    final secs = (seconds % 60).toInt();
    return '$minutes:${secs.toString().padLeft(2, '0')}';
  }

  String _getIssueLabel(String issueType) {
    switch (issueType) {
      case 'pronunciation':
        return '発音';
      case 'timing':
        return 'タイミング';
      case 'skipped':
        return 'スキップ';
      default:
        return issueType;
    }
  }

  Color _getIssueColor(String issueType) {
    switch (issueType) {
      case 'pronunciation':
        return Colors.orange.shade100;
      case 'timing':
        return Colors.blue.shade100;
      case 'skipped':
        return Colors.red.shade100;
      default:
        return Colors.grey.shade100;
    }
  }

  void _playModelAudio(BuildContext context, WeakSegment segment) {
    // Play model audio for the specific time segment
    // In production, this would use an audio player to play from startTime to endTime
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing model audio: ${_formatTime(segment.startTime)} - ${_formatTime(segment.endTime)}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Integrate with actual audio player service
    // Example: audioService.playSegment(modelAudioUrl, segment.startTime, segment.endTime);
  }

  void _playUserAudio(BuildContext context, WeakSegment segment) {
    // Play user's recorded audio for the specific time segment
    // In production, this would play the user's recording from startTime to endTime
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Playing your recording: ${_formatTime(segment.startTime)} - ${_formatTime(segment.endTime)}',
        ),
        duration: const Duration(seconds: 2),
      ),
    );
    // TODO: Integrate with actual audio player service
    // Example: audioService.playSegment(userRecordingUrl, segment.startTime, segment.endTime);
  }
}

