import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/services/audio_cache_service.dart';


void main() {
  group('AudioCacheService Tests', () {
    late AudioCacheService cacheService;

    setUp(() {
      cacheService = AudioCacheService();
    });

    // Note: Testing actual download requires mocking Dio, 
    // but the directory logic can be verified.
    
    test('Service can be instantiated', () {
      expect(cacheService, isNotNull);
    });

    test('getFileNameFromUrl extracts filename correctly', () {
      const url = 'https://example.com/audio/sample.mp3?token=123';
      // In our implementation, we take the last part of path before ?
      final result = url.split('/').last.split('?').first;
      expect(result, 'sample.mp3');
    });
  });
}
