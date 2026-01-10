import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/vocabulary.dart';

class VocabularyListScreen extends ConsumerStatefulWidget {
  const VocabularyListScreen({super.key});

  @override
  ConsumerState<VocabularyListScreen> createState() => _VocabularyListScreenState();
}

class _VocabularyListScreenState extends ConsumerState<VocabularyListScreen> {
  String? _selectedLevel;
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // TODO: Use vocabularyListProvider
    final vocabularies = <Vocabulary>[]; // Placeholder

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // TODO: Navigate to add vocabulary
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search words...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),

          // SRS Level filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                'All',
                'new',
                'learning',
                'young',
                'mature',
                'mastered'
              ].map((level) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: FilterChip(
                    label: Text(level),
                    selected: _selectedLevel == level,
                    onSelected: (selected) {
                      setState(() {
                        _selectedLevel = selected ? level : null;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 16),

          // Vocabulary list
          Expanded(
            child: vocabularies.isEmpty
                ? const Center(child: Text('No vocabulary yet'))
                : ListView.builder(
                    itemCount: vocabularies.length,
                    itemBuilder: (context, index) {
                      final vocab = vocabularies[index];
                      return VocabularyListItem(vocabulary: vocab);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

class VocabularyListItem extends StatelessWidget {
  final Vocabulary vocabulary;

  const VocabularyListItem({super.key, required this.vocabulary});

  Color _getSrsLevelColor(String level) {
    switch (level) {
      case 'new':
        return Colors.grey;
      case 'learning':
        return Colors.orange;
      case 'young':
        return Colors.yellow;
      case 'mature':
        return Colors.lightGreen;
      case 'mastered':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        title: Text(
          vocabulary.word,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(vocabulary.meaning),
            const SizedBox(height: 4),
            Text(
              'Next review: ${_formatDate(vocabulary.nextReviewDate)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: _getSrsLevelColor(vocabulary.srsLevel),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            vocabulary.srsLevel,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
        ),
        onTap: () {
          // TODO: Navigate to vocabulary detail
        },
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = date.difference(now).inDays;

    if (diff == 0) return 'Today';
    if (diff == 1) return 'Tomorrow';
    if (diff < 0) return 'Overdue';
    return '${diff}d';
  }
}
