import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/translation_topic.dart';
import '../providers/topic_provider.dart';

class TranslationHeader extends ConsumerWidget {
  const TranslationHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final topic = ref.watch(topicProvider);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.vertical(
          bottom: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          // Daily progress
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '今日の進捗',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '3/10',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          // Topic selector
          DropdownButtonFormField<TranslationTopic>(
            value: topic,
            decoration: InputDecoration(
              labelText: 'トピック',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            items: TranslationTopic.values.map((t) {
              return DropdownMenuItem(
                value: t,
                child: Text(t.displayName),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                ref.read(topicProvider.notifier).setTopic(value);
              }
            },
          ),
        ],
      ),
    );
  }
}
