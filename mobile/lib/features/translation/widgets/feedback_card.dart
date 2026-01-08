import 'package:flutter/material.dart';

class FeedbackCard extends StatelessWidget {
  final List<String> feedback;

  const FeedbackCard({
    required this.feedback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Separate feedback into good points and improvements
    final goodPoints = feedback.where((f) => f.startsWith('✓')).toList();
    final improvements = feedback.where((f) => !f.startsWith('✓')).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'フィードバック',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        
        // Good points
        if (goodPoints.isNotEmpty) ...[
          _buildSection(
            context,
            '良い点',
            goodPoints,
            Colors.green,
            Icons.check_circle,
          ),
          const SizedBox(height: 12),
        ],
        
        // Improvements
        if (improvements.isNotEmpty)
          _buildSection(
            context,
            '改善点',
            improvements,
            Colors.orange,
            Icons.lightbulb,
          ),
      ],
    );
  }

  Widget _buildSection(
    BuildContext context,
    String title,
    List<String> items,
    Color color,
    IconData icon,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: color.shade900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: items.map((item) {
              return Chip(
                label: Text(
                  item.replaceFirst('✓ ', ''),
                  style: const TextStyle(fontSize: 12),
                ),
                backgroundColor: color.withOpacity(0.2),
                side: BorderSide.none,
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
