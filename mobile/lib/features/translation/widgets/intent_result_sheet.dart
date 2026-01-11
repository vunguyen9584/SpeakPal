import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../models/intent_result.dart';
import 'package:mobile/core/services/tts_service.dart';

class IntentResultSheet extends ConsumerWidget {
  final IntentResult? result;

  const IntentResultSheet({
    this.result,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (result == null) {
      return Container(
        height: 200,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      height: MediaQuery.of(context).size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Handle bar
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // User expression
            _buildSection(
              context,
              'あなたの表現',
              result!.userExpression,
              Colors.blue.shade50,
            ),
            
            const SizedBox(height: 24),
            
            // Score breakdown
            _buildScoreBreakdown(context, result!.breakdown),
            
            const SizedBox(height: 24),
            
            // Alternative expressions
            _buildAlternatives(context, ref, result!.alternativeExpressions),
            
            const SizedBox(height: 24),
            
            // XP earned
            _buildXPDisplay(context, result!.xpEarned),
            
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
                    onPressed: () => Navigator.pop(context),
                    child: const Text('次の問題'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    String content,
    Color bgColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _buildScoreBreakdown(
    BuildContext context,
    IntentScoreBreakdown breakdown,
  ) {
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
        _buildScoreBar(context, '意図の正確さ', breakdown.intentScore, 40, Colors.purple),
        const SizedBox(height: 8),
        _buildScoreBar(context, '自然さ', breakdown.naturalnessScore, 30, Colors.blue),
        const SizedBox(height: 8),
        _buildScoreBar(context, '語彙', breakdown.vocabularyScore, 30, Colors.green),
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

  Widget _buildAlternatives(BuildContext context, WidgetRef ref, List<String> alternatives) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '他の表現例',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        ...alternatives.take(3).map((alt) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(alt),
                ),
                IconButton(
                  icon: const Icon(Icons.volume_up),
                  onPressed: () async {
                    final tts = ref.read(ttsServiceProvider);
                    try {
                      await tts.speak(alt, language: 'en-US');
                    } catch (e) {
                      // Error already logged by TTS service
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('音声再生に失敗しました'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      }
                    }
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.copy),
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: alt)).then((_) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('コピーしました')),
                        );
                      }
                    });
                  },
                ),
              ],
            ),
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
}

