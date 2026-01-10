import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConversationSummaryScreen extends ConsumerWidget {
  final String conversationId;

  const ConversationSummaryScreen({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Fetch summary data from repository
    return Scaffold(
      appBar: AppBar(
        title: const Text('Conversation Summary'),
      ),
      body: SingleChildScrollView(
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
                    _buildStatRow(Icons.timer, 'Duration', '8:32'),
                    const Divider(),
                    _buildStatRow(Icons.mic, 'Pronunciation', '85/100'),
                    const Divider(),
                    _buildStatRow(Icons.star, 'XP Earned', '+120'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Vocabulary Section
            Text('New Vocabulary', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildVocabularyList(),
            const SizedBox(height: 24),
            // Corrections Section
            Text('Areas to Improve', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            _buildCorrectionsList(),
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
                  // TODO: Start new conversation with same settings
                },
                child: const Text('Practice Again'),
              ),
            ),
          ],
        ),
      ),
    );
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

  Widget _buildVocabularyList() {
    // TODO: Load actual vocabulary
    final mockVocab = [
      {'word': 'actually', 'meaning': '螳溘・', 'pronunciation': '/ﾋ暗ｦktﾊブﾉ冤i/'},
      {'word': 'particularly', 'meaning': '迚ｹ縺ｫ', 'pronunciation': '/pﾉ决ﾋ・ﾉｪkjﾉ冤ﾉ决li/'},
    ];

    return Column(
      children: mockVocab.map((vocab) {
        return Card(
          child: ListTile(
            title: Text(vocab['word']!),
            subtitle: Text('${vocab['pronunciation']} - ${vocab['meaning']}'),
            trailing: IconButton(
              icon: const Icon(Icons.bookmark_border),
              onPressed: () {},
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildCorrectionsList() {
    // TODO: Load actual corrections
    final mockCorrections = [
      {'type': 'grammar', 'original': 'I goes', 'corrected': 'I go'},
      {'type': 'vocabulary', 'original': 'very good', 'corrected': 'excellent'},
    ];

    return Column(
      children: mockCorrections.map((correction) {
        return Card(
          child: ListTile(
            leading: const Icon(Icons.edit, color: Colors.orange),
            title: RichText(
              text: TextSpan(
                style: const TextStyle(color: Colors.black),
                children: [
                  TextSpan(
                    text: correction['original'],
                    style: const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  const TextSpan(text: ' 竊・'),
                  TextSpan(
                    text: correction['corrected'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            subtitle: Text(correction['type']!),
          ),
        );
      }).toList(),
    );
  }
}

