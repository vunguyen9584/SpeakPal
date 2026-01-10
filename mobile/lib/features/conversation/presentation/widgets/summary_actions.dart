import 'package:flutter/material.dart';

class SummaryActions extends StatelessWidget {
  final VoidCallback onShare;
  final VoidCallback onExport;
  final VoidCallback onBackToHome;
  final VoidCallback onPracticeAgain;

  const SummaryActions({
    super.key,
    required this.onShare,
    required this.onExport,
    required this.onBackToHome,
    required this.onPracticeAgain,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.share),
                  label: const Text('Share'),
                  onPressed: onShare,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: OutlinedButton.icon(
                  icon: const Icon(Icons.download),
                  label: const Text('Export'),
                  onPressed: onExport,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(12),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onBackToHome,
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.all(16),
              ),
              child: const Text('Back to Home'),
            ),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: onPracticeAgain,
            child: const Text('Practice Again'),
          ),
        ],
      ),
    );
  }
}
