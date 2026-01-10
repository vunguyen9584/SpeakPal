import 'package:flutter/material.dart';
import '../../domain/models/turn.dart';

class CorrectionCard extends StatelessWidget {
  final Correction correction;
  final VoidCallback? onTap;

  const CorrectionCard({
    super.key,
    required this.correction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final severityColor = _getSeverityColor(correction.severity);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      color: severityColor.withValues(alpha: 0.1),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    _getCorrectionIcon(correction.type),
                    size: 20,
                    color: severityColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getCorrectionTypeLabel(correction.type),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: severityColor,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: Colors.grey,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  style: DefaultTextStyle.of(context).style,
                  children: [
                    TextSpan(
                      text: correction.original,
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        color: Colors.red,
                      ),
                    ),
                    const TextSpan(text: ' 竊・'),
                    TextSpan(
                      text: correction.corrected,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                correction.explanation,
                style: const TextStyle(
                  fontSize: 13,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ),
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

