import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../domain/models/vocabulary.dart';
import '../providers/learning_providers.dart';

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
    final filters = VocabularyFilters(
      srsLevel: _selectedLevel,
      search: _searchController.text.isEmpty ? null : _searchController.text,
    );
    final vocabulariesAsync = ref.watch(vocabularyListProvider(filters));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Vocabulary'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              _showAddVocabularyDialog(context);
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
              onChanged: (_) => setState(() {}),
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
            child: vocabulariesAsync.when(
              data: (vocabularies) => vocabularies.isEmpty
                  ? const Center(child: Text('No vocabulary yet'))
                  : ListView.builder(
                      itemCount: vocabularies.length,
                      itemBuilder: (context, index) {
                        final vocab = vocabularies[index];
                        return VocabularyListItem(vocabulary: vocab);
                      },
                    ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(child: Text('Error: $error')),
            ),
          ),
        ],
      ),
    );
  }
  Future<void> _showAddVocabularyDialog(BuildContext context) async {
    final wordController = TextEditingController();
    final meaningController = TextEditingController();
    final exampleController = TextEditingController();
    final formKey = GlobalKey<FormState>();
    bool isLoading = false;

    await showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Text('Add Vocabulary'),
          content: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: wordController,
                  decoration: const InputDecoration(labelText: 'Word'),
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                ),
                TextFormField(
                  controller: meaningController,
                  decoration: const InputDecoration(labelText: 'Meaning'),
                  validator: (v) => v?.isNotEmpty == true ? null : 'Required',
                ),
                TextFormField(
                  controller: exampleController,
                  decoration: const InputDecoration(labelText: 'Example Sentence (Optional)'),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: isLoading ? null : () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: isLoading
                  ? null
                  : () async {
                      if (formKey.currentState?.validate() == true) {
                        setState(() => isLoading = true);
                        
                        final repository = ref.read(learningRepositoryProvider);
                        final result = await repository.addVocabulary({
                          'word': wordController.text.trim(),
                          'meaning': meaningController.text.trim(),
                          'exampleSentence': exampleController.text.trim(),
                          'pronunciation': '', 
                          'partOfSpeech': 'noun', 
                          'srsLevel': 'new',
                        });

                        if (context.mounted) {
                           setState(() => isLoading = false);
                           
                           result.fold(
                            (error) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text(error.message)),
                              );
                            },
                            (newVocab) {
                               Navigator.pop(context);
                               ScaffoldMessenger.of(context).showSnackBar(
                                 SnackBar(content: Text('Added "${newVocab.word}"')),
                               );
                               ref.invalidate(vocabularyListProvider);
                            },
                           );
                        }
                      }
                    },
              child: isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Add'),
            ),
          ],
        ),
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
          context.push('/learning/vocabulary/${vocabulary.id}', extra: vocabulary);
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



