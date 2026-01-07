import 'package:flutter/material.dart';
import '../../domain/models/turn.dart';
import 'correction_list_item.dart';

class CorrectionsSection extends StatelessWidget {
  final List<Correction> corrections;

  const CorrectionsSection({
    Key? key,
    required this.corrections,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (corrections.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              Icon(
                Icons.check_circle,
                size: 64,
                color: Colors.green[400],
              ),
              const SizedBox(height: 12),
              const Text(
                'Perfect conversation!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'No corrections needed. Keep up the great work!',
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    // Group corrections by type
    final grouped = <String, List<Correction>>{};
    for (final correction in corrections) {
      grouped.putIfAbsent(correction.type, () => []).add(correction);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.edit, color: Colors.orange[700]),
            const SizedBox(width: 8),
            Text(
              'Areas to Improve',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${corrections.length}',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (grouped.containsKey('grammar'))
          _buildCorrectionGroup(
            context,
            'Grammar',
            Icons.abc,
            grouped['grammar']!,
          ),
        if (grouped.containsKey('vocabulary'))
          _buildCorrectionGroup(
            context,
            'Vocabulary',
            Icons.book,
            grouped['vocabulary']!,
          ),
        if (grouped.containsKey('pronunciation'))
          _buildCorrectionGroup(
            context,
            'Pronunciation',
            Icons.mic,
            grouped['pronunciation']!,
          ),
      ],
    );
  }

  Widget _buildCorrectionGroup(
    BuildContext context,
    String title,
    IconData icon,
    List<Correction> corrections,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            children: [
              Icon(icon, size: 20, color: Colors.grey[700]),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  '${corrections.length}',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
        ...corrections.map((correction) => CorrectionListItem(correction: correction)),
        const SizedBox(height: 12),
      ],
    );
  }
}
