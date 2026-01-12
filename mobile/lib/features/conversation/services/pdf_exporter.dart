import 'dart:io';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'package:mobile/core/utils/logger_service.dart';
import 'package:mobile/core/error/app_error.dart';

/// Service to export conversation summaries to PDF
class PdfExporter {
  /// Export conversation summary to PDF
  /// Returns the file path of the generated PDF
  static Future<String> exportSummary({
    required String conversationId,
    required String summaryText,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      logger.info('Exporting summary to PDF', data: {'conversationId': conversationId});

      final pdf = pw.Document();

      // Add page with summary
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(40),
          build: (context) => [
            // Header
            _buildHeader(),
            pw.SizedBox(height: 30),
            
            // Title
            pw.Text(
              'Conversation Summary',
              style: pw.TextStyle(
                fontSize: 24,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
            pw.SizedBox(height: 10),
            
            // Metadata
            if (metadata != null) ...[
              _buildMetadata(metadata),
              pw.SizedBox(height: 20),
            ],
            
            pw.Divider(thickness: 2),
            pw.SizedBox(height: 20),
            
            // Summary Content
            pw.Text(
              summaryText,
              style: const pw.TextStyle(
                fontSize: 12,
                lineSpacing: 1.5,
              ),
            ),
            
            pw.SizedBox(height: 40),
            
            // Footer
            pw.Divider(),
            pw.SizedBox(height: 10),
            _buildFooter(),
          ],
        ),
      );

      // Save to file
      final directory = await getApplicationDocumentsDirectory();
      final filePath = '${directory.path}/summary_$conversationId.pdf';
      final file = File(filePath);
      
      await file.writeAsBytes(await pdf.save());
      
      logger.info('PDF exported successfully', data: {'path': filePath});
      return filePath;
      
    } catch (e, stackTrace) {
      logger.error('Failed to export PDF', error: e, stackTrace: stackTrace);
      throw StorageError(
        'Failed to export PDF',
        userMessage: 'Could not create PDF file. Please try again.',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  static pw.Widget _buildHeader() {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'SpeakPal',
              style: pw.TextStyle(
                fontSize: 28,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue700,
              ),
            ),
            pw.Text(
              'AI-Powered Language Learning',
              style: const pw.TextStyle(
                fontSize: 12,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.Container(
          padding: const pw.EdgeInsets.all(8),
          decoration: pw.BoxDecoration(
            color: PdfColors.blue50,
            borderRadius: pw.BorderRadius.circular(8),
          ),
          child: pw.Icon(
            const pw.IconData(0xe0b7), // chat_bubble icon
            size: 32,
            color: PdfColors.blue700,
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildMetadata(Map<String, dynamic> metadata) {
    return pw.Container(
      padding: const pw.EdgeInsets.all(16),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          if (metadata['date'] != null)
            _buildMetadataRow('Date', metadata['date'].toString()),
          if (metadata['duration'] != null)
            _buildMetadataRow('Duration', metadata['duration'].toString()),
          if (metadata['wordsLearned'] != null)
            _buildMetadataRow('Words Learned', metadata['wordsLearned'].toString()),
          if (metadata['xpEarned'] != null)
            _buildMetadataRow('XP Earned', metadata['xpEarned'].toString()),
        ],
      ),
    );
  }

  static pw.Widget _buildMetadataRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        children: [
          pw.SizedBox(
            width: 120,
            child: pw.Text(
              '$label:',
              style: pw.TextStyle(
                fontWeight: pw.FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
          pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 11),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter() {
    final now = DateTime.now();
    final dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(
          'Generated by SpeakPal',
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey600,
          ),
        ),
        pw.Text(
          dateStr,
          style: const pw.TextStyle(
            fontSize: 10,
            color: PdfColors.grey600,
          ),
        ),
      ],
    );
  }
}
