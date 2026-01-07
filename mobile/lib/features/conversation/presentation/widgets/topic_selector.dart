import 'package:flutter/material.dart';

class TopicSelector extends StatelessWidget {
  final String? selectedTopic;
  final ValueChanged<String?> onTopicChanged;

  static const List<String> topics = [
    'Daily Life',
    'Travel',
    'Business',
    'Technology',
    'Sports',
    'Culture',
  ];

  const TopicSelector({
    Key? key,
    required this.selectedTopic,
    required this.onTopicChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: topics.map((topic) {
        return FilterChip(
          label: Text(topic),
          selected: selectedTopic == topic,
          onSelected: (selected) {
            onTopicChanged(selected ? topic : null);
          },
        );
      }).toList(),
    );
  }
}
