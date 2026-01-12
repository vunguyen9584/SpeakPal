import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:mobile/core/error/error_handler.dart';
import 'package:mobile/core/error/app_error.dart';
import 'package:mobile/features/conversation/services/summary_image_generator.dart';
import 'package:mobile/features/conversation/services/pdf_exporter.dart';
import 'dart:io';

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

  void _shareAsImage(BuildContext context) async {
    // Show loading feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Generating image...'),
          ],
        ),
        duration: Duration(seconds: 2),
      ),
    );

    try {
      // Generate summary card image
      final imagePath = await SummaryImageGenerator.generateSummaryCard(
        conversationId: conversationId,
        summaryText: summaryText,
        context: context,
      );

      // Share the generated image
      await Share.shareXFiles(
        [XFile(imagePath)],
        subject: 'My SpeakPal Conversation Summary',
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Image generated successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        errorHandler.handleError(
          e as AppError,
          context: context,
          showDialog: true,
        );
      }
    }
  }

  void _shareAsText(BuildContext context) {
    Share.share(
      summaryText,
      subject: 'My SpeakPal Conversation Summary',
    );
  }

  void _exportToPDF(BuildContext context) async {
    // Show loading feedback
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
            SizedBox(width: 12),
            Text('Exporting to PDF...'),
          ],
        ),
        duration: Duration(seconds: 3),
      ),
    );

    try {
      // Export to PDF
      final pdfPath = await PdfExporter.exportSummary(
        conversationId: conversationId,
        summaryText: summaryText,
        metadata: {
          'date': DateTime.now().toString().split(' ')[0],
          'conversationId': conversationId,
        },
      );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('PDF saved to: ${File(pdfPath).parent.path}'),
            backgroundColor: Colors.green,
            duration: const Duration(seconds: 4),
            action: SnackBarAction(
              label: 'SHARE',
              textColor: Colors.white,
              onPressed: () async {
                // Share the PDF file
                await Share.shareXFiles(
                  [XFile(pdfPath)],
                  subject: 'SpeakPal Conversation Summary',
                );
              },
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        errorHandler.handleError(
          e as AppError,
          context: context,
          showDialog: true,
        );
      }
    }
  }
}

