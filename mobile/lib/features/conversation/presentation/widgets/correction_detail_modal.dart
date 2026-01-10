import 'package:flutter/material.dart';
import '../../domain/models/turn.dart';

class CorrectionDetailModal extends StatelessWidget {
  final Correction correction;

  const CorrectionDetailModal({
    super.key,
    required this.correction,
  });

  static void show(BuildContext context, Correction correction) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => CorrectionDetailModal(correction: correction),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          padding: const EdgeInsets.all(20),
          child: ListView(
            controller: scrollController,
            children: [
              // Handle bar
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 20),
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              // Title
              Row(
                children: [
                  Icon(
                    _getCorrectionIcon(correction.type),
                    size: 28,
                    color: _getSeverityColor(correction.severity),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '${_getCorrectionTypeLabel(correction.type)} Correction',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Original vs Corrected
              _buildSection(
                'What you said:',
                correction.original,
                Colors.red[50]!,
                Colors.red,
              ),
              const SizedBox(height: 12),
              _buildSection(
                'Correct version:',
                correction.corrected,
                Colors.green[50]!,
                Colors.green,
              ),
              const SizedBox(height: 20),
              // Explanation
              const Text(
                'Explanation:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                correction.explanation,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 16),
              // Japanese explanation
              const Text(
                '譌･譛ｬ隱櫁ｪｬ譏・',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                correction.explanationJa,
                style: const TextStyle(fontSize: 15),
              ),
              const SizedBox(height: 24),
              // Close button
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.all(16),
                ),
                child: const Text('Got it!'),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSection(String title, String content, Color bgColor, Color textColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            content,
            style: TextStyle(
              fontSize: 16,
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  IconData _getCorrectionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'grammar':
        return Icons.abc;
      case 'vocabulary':
        return Icons.book;
      case 'pronunciation':
        return Icons.mic;
      default:
        return Icons.edit;
    }
  }

  String _getCorrectionTypeLabel(String type) {
    return type[0].toUpperCase() + type.substring(1);
  }
}

