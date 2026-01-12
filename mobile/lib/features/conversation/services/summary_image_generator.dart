import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile/core/utils/logger_service.dart';
import 'package:mobile/core/error/app_error.dart';

/// Service to generate shareable images from conversation summaries
class SummaryImageGenerator {
  /// Generate a summary card image
  /// Returns the file path of the generated image
  static Future<String> generateSummaryCard({
    required String conversationId,
    required String summaryText,
    required BuildContext context,
  }) async {
    try {
      logger.info('Generating summary card image', data: {'conversationId': conversationId});

      // Create a widget to render
      final widget = _SummaryCardWidget(
        summaryText: summaryText,
        conversationId: conversationId,
      );

      // Render widget to image
      final image = await _widgetToImage(widget, context);
      
      // Save to file
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/summary_$conversationId.png';
      final file = File(filePath);
      
      final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw const UnknownError('Failed to convert image to bytes');
      }
      
      await file.writeAsBytes(byteData.buffer.asUint8List());
      
      logger.info('Summary card generated successfully', data: {'path': filePath});
      return filePath;
      
    } catch (e, stackTrace) {
      logger.error('Failed to generate summary card', error: e, stackTrace: stackTrace);
      throw UnknownError(
        'Failed to generate image: Could not create summary image. Please try again.',
        e,
        stackTrace,
      );
    }
  }

  /// Convert a widget to an image
  static Future<ui.Image> _widgetToImage(Widget widget, BuildContext context) async {
    final repaintBoundary = RenderRepaintBoundary();
    
    final renderView = RenderView(
      view: View.of(context),
      child: RenderPositionedBox(
        alignment: Alignment.center,
        child: repaintBoundary,
      ),
      configuration: ViewConfiguration(
        devicePixelRatio: 2.0,
      ),
    );

    final pipelineOwner = PipelineOwner()..rootNode = renderView;
    renderView.prepareInitialFrame();

    final buildOwner = BuildOwner(focusManager: FocusManager());
    final rootElement = RenderObjectToWidgetAdapter<RenderBox>(
      container: repaintBoundary,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: MediaQuery(
          data: MediaQueryData.fromView(View.of(context)),
          child: Material(
            child: widget,
          ),
        ),
      ),
    ).attachToRenderTree(buildOwner);

    buildOwner.buildScope(rootElement);
    buildOwner.finalizeTree();
    pipelineOwner.flushLayout();
    pipelineOwner.flushCompositingBits();
    pipelineOwner.flushPaint();

    final image = await repaintBoundary.toImage(pixelRatio: 2.0);
    return image;
  }
}

/// Widget to render as summary card
class _SummaryCardWidget extends StatelessWidget {
  final String summaryText;
  final String conversationId;

  const _SummaryCardWidget({
    required this.summaryText,
    required this.conversationId,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 800,
      height: 1200,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.shade400,
            Colors.purple.shade600,
          ],
        ),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.chat_bubble_outline,
                  color: Colors.blue,
                  size: 32,
                ),
              ),
              const SizedBox(width: 16),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'SpeakPal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Conversation Summary',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 40),
          
          // Summary Content
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              child: SingleChildScrollView(
                child: Text(
                  summaryText,
                  style: const TextStyle(
                    fontSize: 20,
                    height: 1.6,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Footer
          Center(
            child: Text(
              'Generated by SpeakPal • ${DateTime.now().year}',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
