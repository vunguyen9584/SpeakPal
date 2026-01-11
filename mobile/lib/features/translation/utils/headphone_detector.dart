import 'package:flutter/material.dart';
import 'package:headphones_detection/headphones_detection.dart';
import 'package:mobile/core/utils/logger_service.dart';

/// Utility class for detecting headphone connection status
/// Supports both wired and Bluetooth headphones on iOS and Android
class HeadphoneDetector {
  /// Check if headphones are currently connected
  /// Returns true if any type of headphones (wired or Bluetooth) are connected
  static Future<bool> areHeadphonesConnected() async {
    try {
      final isConnected = await HeadphonesDetection.isHeadphonesConnected();
      
      logger.info(
        'Headphone connection check',
        data: {'connected': isConnected},
      );
      
      return isConnected;
    } on HeadphonesDetectionException catch (e) {
      logger.warning(
        'Headphone detection failed',
        error: e.message,
      );
      // On error, assume not connected to show warning (safer for audio quality)
      return false;
    } catch (e) {
      logger.warning(
        'Unexpected headphone detection error',
        error: e,
      );
      return false;
    }
  }

  /// Listen to headphone connection changes in real-time
  /// Returns a stream that emits true when headphones are connected, false otherwise
  static Stream<bool> get connectionStream {
    return HeadphonesDetection.headphonesStream.map((isConnected) {
      logger.debug(
        'Headphone connection changed',
        data: {'connected': isConnected},
      );
      return isConnected;
    }).handleError((error) {
      logger.error(
        'Error in headphone connection stream',
        error: error,
      );
      return false;
    });
  }

  /// Show warning dialog when headphones are not connected
  /// User can still continue anyway (non-blocking)
  static Future<void> showHeadphoneWarning(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('🎧 Headphones Required'),
        content: const Text(
          'For the best shadowing experience, please connect headphones. '
          'This prevents the model audio from interfering with your recording.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Continue Anyway'),
          ),
        ],
      ),
    );
  }
}
