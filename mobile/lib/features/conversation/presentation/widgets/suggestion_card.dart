import 'package:flutter/material.dart';
import '../../domain/models/suggestion.dart';

class SuggestionCard extends StatelessWidget {
  final Suggestion suggestion;

  const SuggestionCard({
    super.key,
    required this.suggestion,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: Colors.lightBlue[50],
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.lightbulb_outline,
                  size: 20,
                  color: Colors.amber[700],
                ),
                const SizedBox(width: 8),
                const Text(
                  'Suggestion',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              suggestion.template,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (suggestion.alternativeResponses.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Alternative ways to say this:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              ...suggestion.alternativeResponses.map(
                (alt) => Padding(
                  padding: const EdgeInsets.only(left: 12, top: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('窶｢ ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          alt,
                          style: const TextStyle(fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            if (suggestion.vocabulary.isNotEmpty) ...[
              const SizedBox(height: 8),
              const Text(
                'Useful vocabulary:',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: suggestion.vocabulary.map(
                  (vocab) => Chip(
                    label: Text(
                      vocab.word,
                      style: const TextStyle(fontSize: 12),
                    ),
                    backgroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                  ),
                ).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

