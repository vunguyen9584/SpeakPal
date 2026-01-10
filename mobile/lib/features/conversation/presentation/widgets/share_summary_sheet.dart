import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareSummarySheet extends StatelessWidget {
  final String conversationId;
  final String summaryText;

  const ShareSummarySheet({
    super.key,
    required this.conversationId,
    required this.summaryText,
  });

  static void show(
    BuildContext context, {
    required String conversationId,
    required String summaryText,
  }) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => ShareSummarySheet(
        conversationId: conversationId,
        summaryText: summaryText,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Text(
            'Share Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          // Share options
          ListTile(
            leading: const Icon(Icons.image),
            title: const Text('Share as Image'),
            subtitle: const Text('Create a summary card'),
            onTap: () {
              Navigator.pop(context);
              _shareAsImage(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.text_fields),
            title: const Text('Share as Text'),
            subtitle: const Text('Copy conversation transcript'),
            onTap: () {
              Navigator.pop(context);
              _shareAsText(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.picture_as_pdf),
            title: const Text('Export to PDF'),
            subtitle: const Text('Download full report'),
            onTap: () {
              Navigator.pop(context);
              _exportToPDF(context);
            },
          ),
        ],
      ),
    );
  }

  void _shareAsImage(BuildContext context) {
    // TODO: Implement image generation and sharing
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Generating image...')),
    );
  }

  void _shareAsText(BuildContext context) {
    Share.share(
      summaryText,
      subject: 'My SpeakPal Conversation Summary',
    );
  }

  void _exportToPDF(BuildContext context) {
    // TODO: Implement PDF export
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting to PDF...')),
    );
  }
}

