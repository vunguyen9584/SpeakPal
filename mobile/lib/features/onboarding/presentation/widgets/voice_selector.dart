import 'package:flutter/material.dart';

/// Voice Selector Widget
class VoiceSelector extends StatelessWidget {
  final String? selectedVoice;
  final Function(String voice) onVoiceSelected;

  const VoiceSelector({
    super.key,
    required this.selectedVoice,
    required this.onVoiceSelected,
  });

  static const List<Map<String, String>> voices = [
    {'id': 'VOICE_1', 'name': 'Male US', 'description': 'American male voice'},
    {'id': 'VOICE_2', 'name': 'Female US', 'description': 'American female voice'},
    {'id': 'VOICE_3', 'name': 'Male UK', 'description': 'British male voice'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Voice',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        ...voices.map((voice) {
          final isSelected = selectedVoice == voice['id'];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(
                color: isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.grey[300]!,
                width: isSelected ? 2 : 1,
              ),
            ),
            child: ListTile(
              title: Text(voice['name']!),
              subtitle: Text(voice['description']!),
              trailing: isSelected
                  ? Icon(Icons.check_circle, color: Theme.of(context).primaryColor)
                  : const Icon(Icons.circle_outlined),
              onTap: () => onVoiceSelected(voice['id']!),
            ),
          );
        }).toList(),
      ],
    );
  }
}
