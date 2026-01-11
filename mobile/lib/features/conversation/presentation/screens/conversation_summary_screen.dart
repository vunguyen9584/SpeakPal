import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/summary_provider.dart';
import '../../domain/models/suggestion.dart';
import '../../domain/models/turn.dart';
class ConversationSummaryScreen extends ConsumerWidget {
  final String conversationId;

  const ConversationSummaryScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final summaryAsync = ref.watch(summaryProvider(conversationId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation Summary'),
      ),
      body: summaryAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
        data: (summary) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Completion Header
            const Center(
              child: Column(
                children: [
                  Icon(Icons.celebration, size: 64, color: Colors.amber),
                  SizedBox(height: 8),
                  Text(
                    'Great job!',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            // Stats Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _buildStatRow(Icons.timer, 'Duration', _formatDuration(summary.durationSeconds)),
                    const Divider(),
                    _buildStatRow(Icons.mic, 'Pronunciation', '${summary.pronunciationScore}/100'),
                    const Divider(),
                    _buildStatRow(Icons.star, 'XP Earned', '+${summary.xpEarned}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Vocabulary Section
            Text('New Vocabulary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildVocabularyList(summary.vocabulary),
            const SizedBox(height: 24),
            // Corrections Section
            Text('Areas to Improve', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildCorrectionsList(summary.corrections),
            const SizedBox(height: 32),
            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.share),
                    label: const Text('Share'),
                    onPressed: () {},
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.download),
                    label: const Text('Export'),
                    onPressed: () {},
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Back to Home'),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: TextButton(
                onPressed: () {
                  // Navigate back to conversation setup to start new conversation
                  // Pop to home first, then navigate to setup
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.pushNamed(
                    context,
                    '/conversation/setup',
                    arguments: {
                      'mode': 'freetalk', // Could preserve mode from summary
                    },
                  );
                },
                child: const Text('Practice Again'),
              ),
            ),
          ],
        ),
      ),
      ),
    );
  }

  String _formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${twoDigits(duration.inMinutes)}:${twoDigits(duration.inSeconds.remainder(60))}';
  }

  Widget _buildStatRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600]),
          const SizedBox(width: 12),
          Expanded(child: Text(label)),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabularyList(List<VocabularyItem> vocabulary) {
    if (vocabulary.isEmpty) {
      return const Text('No new vocabulary learned.');
    }
    return Column(
      children: vocabulary.map((vocab) {
        return Card(
          child: ListTile(
            title: Text(vocab.word),
            subtitle: Text('${vocab.pronunciation} - ${vocab.meaning}'),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCorrectionsList(List<Correction> corrections) {
    if (corrections.isEmpty) {
      return const Text('No suggestions available.');
    }
    return Column(
      children: corrections.map((correction) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.edit, color: Colors.orange),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: correction.original,
                    style: const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  const TextSpan(text: ' -> '),
                  TextSpan(
                    text: correction.corrected,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            subtitle: Text(correction.type),
          ),
        );
      }).toList(),
    );
  }
}

