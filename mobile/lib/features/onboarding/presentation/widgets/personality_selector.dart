import 'package:flutter/material.dart';

/// Personality Selector Widget
class PersonalitySelector extends StatelessWidget {
  final String? selectedPersonality;
  final Function(String personality) onPersonalitySelected;

  const PersonalitySelector({
    super.key,
    required this.selectedPersonality,
    required this.onPersonalitySelected,
  });

  static const List<Map<String, dynamic>> personalities = [
    {
      'id': 'CHEERFUL',
      'name': 'Cheerful',
      'description': 'Positive and encouraging',
      'icon': Icons.sentiment_very_satisfied,
    },
    {
      'id': 'STRICT',
      'name': 'Strict',
      'description': 'Direct and focused on accuracy',
      'icon': Icons.school,
    },
    {
      'id': 'SARCASTIC',
      'name': 'Sarcastic',
      'description': 'Witty and humorous',
      'icon': Icons.mood,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Personality',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.85,
          ),
          itemCount: personalities.length,
          itemBuilder: (context, index) {
            final personality = personalities[index];
            final isSelected = selectedPersonality == personality['id'];

            return InkWell(
              onTap: () => onPersonalitySelected(personality['id'] as String),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: isSelected
                        ? Theme.of(context).primaryColor
                        : Colors.grey[300]!,
                    width: isSelected ? 2 : 1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  color: isSelected
                      ? Theme.of(context).primaryColor.withValues(alpha: 0.1)
                      : Colors.transparent,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      personality['icon'] as IconData,
                      size: 40,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Colors.grey[600],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      personality['name'] as String,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : Colors.black87,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      personality['description'] as String,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

