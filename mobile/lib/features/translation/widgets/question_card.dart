import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/translation_provider.dart';
import '../providers/topic_provider.dart';

class QuestionCard extends ConsumerWidget {
  const QuestionCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topic = ref.watch(topicProvider);
    final questionAsync = ref.watch(translationQuestionProvider(topic.value));

    return questionAsync.when(
      data: (question) => Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language label
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      question.sourceLanguage,
                      style: TextStyle(
                        color: Colors.blue.shade900,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Difficulty indicator
                  _buildDifficultyBadge(question.difficulty),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Source text
              Text(
                question.sourceText,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Grammar points
              if (question.grammarPoints.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: question.grammarPoints.map((point) {
                    return Chip(
                      label: Text(
                        point,
                        style: const TextStyle(fontSize: 12),
                      ),
                      backgroundColor: Colors.purple.shade50,
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
      loading: () => const Center(
        child: CircularProgressIndicator(),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Icon(Icons.error, color: Colors.red, size: 48),
              const SizedBox(height: 8),
              Text(
                'エラーが発生しました',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              Text(
                error.toString(),
                style: Theme.of(context).textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDifficultyBadge(String difficulty) {
    Color color;
    Color textColor;

    switch (difficulty.toLowerCase()) {
      case 'beginner':
        color = Colors.green.shade100;
        textColor = Colors.green.shade900;
        break;
      case 'intermediate':
        color = Colors.orange.shade100;
        textColor = Colors.orange.shade900;
        break;
      case 'advanced':
        color = Colors.red.shade100;
        textColor = Colors.red.shade900;
        break;
      default:
        color = Colors.grey.shade200;
        textColor = Colors.grey.shade800;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        difficulty,
        style: TextStyle(
          color: textColor,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
