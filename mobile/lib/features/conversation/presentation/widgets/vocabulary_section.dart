import 'package:flutter/material.dart';
import '../../domain/models/suggestion.dart';
import 'vocabulary_card.dart';

class VocabularySection extends StatelessWidget {
  final List<VocabularyItem> words;
  final VoidCallback? onSaveAll;

  const VocabularySection({
    Key? key,
    required this.words,
    this.onSaveAll,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (words.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.menu_book,
                size: 48,
                color: Colors.grey[400],
              ),
              const SizedBox(height: 12),
              Text(
                'No new vocabulary',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.menu_book, color: Colors.blue[700]),
            const SizedBox(width: 8),
            Text(
              'New Vocabulary',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${words.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ),
            const Spacer(),
            if (onSaveAll != null)
              TextButton.icon(
                onPressed: onSaveAll,
                icon: const Icon(Icons.bookmark, size: 18),
                label: const Text('Save All'),
              ),
          ],
        ),
        const SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: words.length,
          itemBuilder: (context, index) {
            return VocabularyCard(
              word: words[index],
              onSave: () => _saveWord(context, words[index]),
              onPlayPronunciation: () => _playPronunciation(words[index]),
            );
          },
        ),
      ],
    );
  }

  void _saveWord(BuildContext context, VocabularyItem word) {
    // TODO: Implement save to word list
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Saved "${word.word}" to your word list'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _playPronunciation(VocabularyItem word) {
    // TODO: Implement pronunciation playback
    print('Playing pronunciation for: ${word.word}');
  }
}
