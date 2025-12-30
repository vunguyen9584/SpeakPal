import 'package:flutter/material.dart';
import '../../../auth/domain/models/user.dart';

/// Level Card Widget
class LevelCard extends StatelessWidget {
  final Level level;
  final bool isSelected;
  final VoidCallback onTap;

  const LevelCard({
    super.key,
    required this.level,
    required this.isSelected,
    required this.onTap,
  });

  String _getLevelName() {
    switch (level) {
      case Level.beginner:
        return 'Beginner';
      case Level.elementary:
        return 'Elementary';
      case Level.intermediate:
        return 'Intermediate';
      case Level.upperIntermediate:
        return 'Upper Intermediate';
      case Level.advanced:
        return 'Advanced';
    }
  }

  String _getLevelDescription() {
    switch (level) {
      case Level.beginner:
        return 'Just starting to learn English';
      case Level.elementary:
        return 'Can understand basic phrases and conversations';
      case Level.intermediate:
        return 'Can communicate in everyday situations';
      case Level.upperIntermediate:
        return 'Can express ideas fluently and naturally';
      case Level.advanced:
        return 'Can use English effectively in all situations';
    }
  }

  String _getLevelExample() {
    switch (level) {
      case Level.beginner:
        return '"Hello, my name is..."';
      case Level.elementary:
        return '"I like to watch movies"';
      case Level.intermediate:
        return '"I\'ve been learning English for 2 years"';
      case Level.upperIntermediate:
        return '"I find it fascinating how languages evolve"';
      case Level.advanced:
        return '"I\'d argue that proficiency requires immersion"';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isSelected ? 8 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: isSelected
              ? Theme.of(context).primaryColor
              : Colors.transparent,
          width: 2,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with Level Name and Selection Indicator
              Row(
                children: [
                  Expanded(
                    child: Text(
                      _getLevelName(),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSelected
                                ? Theme.of(context).primaryColor
                                : null,
                          ),
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                _getLevelDescription(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
              ),
              const SizedBox(height: 12),

              // Example
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.format_quote,
                      size: 16,
                      color: Colors.grey[600],
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _getLevelExample(),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontStyle: FontStyle.italic,
                              color: Colors.grey[700],
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
