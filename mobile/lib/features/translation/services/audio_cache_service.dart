import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:mobile/core/utils/logger_service.dart';

class AudioCacheService {
  static const String _cacheFolder = 'shadowing_audio_cache';
  final Dio _dio = Dio();

  /// Gets the cached file path or downloads it if not present.
  Future<String> getOrDownloadAudio(String audioUrl) async {
    try {
      if (audioUrl.isEmpty) throw Exception('Audio URL is empty');

      final cacheDir = await _getCacheDirectory();
      final fileName = _getFileNameFromUrl(audioUrl);
      final filePath = '${cacheDir.path}/$fileName';
      final file = File(filePath);

      if (await file.exists()) {
        logger.info('Audio cache hit', data: {'url': audioUrl, 'path': filePath});
        return filePath;
      }

      logger.info('Audio cache miss, downloading...', data: {'url': audioUrl});
      await _dio.download(audioUrl, filePath);
      
      return filePath;
    } catch (e, stackTrace) {
      logger.error('Failed to cache audio', error: e, stackTrace: stackTrace);
      // Fallback to original URL if caching fails
      return audioUrl;
    }
  }

  Future<Directory> _getCacheDirectory() async {
    final appDir = await getApplicationSupportDirectory();
    final cacheDir = Directory('${appDir.path}/$_cacheFolder');

    if (!await cacheDir.exists()) {
      await cacheDir.create(recursive: true);
    }
    return cacheDir;
  }

  String _getFileNameFromUrl(String url) {
    // Basic hash-like filename generation from URL to avoid illegal characters
    return url.split('/').last.split('?').first;
  }

  /// Clears the audio cache folder.
  Future<void> clearCache() async {
    try {
      final cacheDir = await _getCacheDirectory();
      if (await cacheDir.exists()) {
        await cacheDir.delete(recursive: true);
        logger.info('Audio cache cleared');
      }
    } catch (e) {
      logger.error('Failed to clear audio cache', error: e);
    }
  }
}
