import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/core/utils/logger_service.dart';
import 'package:mobile/core/error/app_error.dart';

/// Provider for TTS service
final ttsServiceProvider = Provider<TtsService>((ref) {
  return TtsService();
});

/// Text-to-Speech service using platform TTS
/// 
/// This service provides text-to-speech functionality for:
/// - Vocabulary pronunciation
/// - Translation model answers
/// - Learning content narration
/// 
/// Features:
/// - Adjustable speech rate (slow for learners)
/// - Multiple language support
/// - Playback control (play, pause, stop)
/// - Error handling
class TtsService {
  final FlutterTts _tts = FlutterTts();
  bool _isInitialized = false;
  bool _isSpeaking = false;

  /// Current language code (e.g., 'en-US', 'ja-JP')
  String _currentLanguage = 'en-US';

  /// Current speech rate (0.0 to 1.0, default 0.5 for learners)
  double _currentRate = 0.5;

  /// Initialize TTS service
  /// 
  /// Should be called once during app startup
  Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      logger.info('Initializing TTS service', tag: 'TtsService');

      // Set default language
      await _tts.setLanguage(_currentLanguage);

      // Set speech rate (slower for language learners)
      await _tts.setSpeechRate(_currentRate);

      // Set pitch (1.0 is normal)
      await _tts.setPitch(1.0);

      // Set volume (1.0 is max)
      await _tts.setVolume(1.0);

      // Setup handlers
      _tts.setErrorHandler((msg) {
        logger.error('TTS error', tag: 'TtsService', error: msg);
        _isSpeaking = false;
      });

      _tts.setStartHandler(() {
        logger.debug('TTS started', tag: 'TtsService');
        _isSpeaking = true;
      });

      _tts.setCompletionHandler(() {
        logger.debug('TTS completed', tag: 'TtsService');
        _isSpeaking = false;
      });

      _tts.setCancelHandler(() {
        logger.debug('TTS cancelled', tag: 'TtsService');
        _isSpeaking = false;
      });

      _isInitialized = true;
      logger.info('TTS service initialized successfully', tag: 'TtsService');
    } catch (e, stackTrace) {
      logger.error(
        'Failed to initialize TTS service',
        tag: 'TtsService',
        error: e,
        stackTrace: stackTrace,
      );
      throw MediaError(
        'Failed to initialize text-to-speech',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Speak the given text
  /// 
  /// [text] - The text to speak
  /// [language] - Optional language code (e.g., 'en-US', 'ja-JP')
  /// 
  /// Throws [MediaError] if TTS fails
  Future<void> speak(String text, {String? language}) async {
    try {
      // Initialize if not already done
      if (!_isInitialized) {
        await initialize();
      }

      // Stop any ongoing speech
      if (_isSpeaking) {
        await stop();
      }

      // Change language if specified
      if (language != null && language != _currentLanguage) {
        await setLanguage(language);
      }

      logger.debug('Speaking text', tag: 'TtsService', data: {
        'text': text.substring(0, text.length > 50 ? 50 : text.length),
        'language': _currentLanguage,
      });

      await _tts.speak(text);
    } catch (e, stackTrace) {
      logger.error(
        'TTS speak failed',
        tag: 'TtsService',
        error: e,
        stackTrace: stackTrace,
      );
      throw MediaError(
        'Text-to-speech failed',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Stop current speech
  Future<void> stop() async {
    try {
      await _tts.stop();
      _isSpeaking = false;
    } catch (e) {
      logger.error('TTS stop failed', tag: 'TtsService', error: e);
    }
  }

  /// Pause current speech (if supported by platform)
  Future<void> pause() async {
    try {
      await _tts.pause();
    } catch (e) {
      logger.warning('TTS pause not supported or failed', tag: 'TtsService', error: e);
    }
  }

  /// Set speech rate
  /// 
  /// [rate] - Speech rate (0.0 to 1.0)
  ///   - 0.0 = very slow
  ///   - 0.5 = normal (recommended for learners)
  ///   - 1.0 = fast
  Future<void> setSpeed(double rate) async {
    try {
      _currentRate = rate.clamp(0.0, 1.0);
      await _tts.setSpeechRate(_currentRate);
      logger.debug('TTS speed set', tag: 'TtsService', data: {'rate': _currentRate});
    } catch (e) {
      logger.error('Failed to set TTS speed', tag: 'TtsService', error: e);
    }
  }

  /// Set language
  /// 
  /// [language] - Language code (e.g., 'en-US', 'ja-JP', 'vi-VN')
  Future<void> setLanguage(String language) async {
    try {
      final result = await _tts.setLanguage(language);
      if (result == 1) {
        _currentLanguage = language;
        logger.debug('TTS language set', tag: 'TtsService', data: {'language': language});
      } else {
        logger.warning('Language not available', tag: 'TtsService', data: {'language': language});
      }
    } catch (e) {
      logger.error('Failed to set TTS language', tag: 'TtsService', error: e);
    }
  }

  /// Get available languages
  Future<List<String>> getAvailableLanguages() async {
    try {
      final languages = await _tts.getLanguages;
      return languages.cast<String>();
    } catch (e) {
      logger.error('Failed to get available languages', tag: 'TtsService', error: e);
      return [];
    }
  }

  /// Check if currently speaking
  bool get isSpeaking => _isSpeaking;

  /// Get current language
  String get currentLanguage => _currentLanguage;

  /// Get current speech rate
  double get currentRate => _currentRate;

  /// Dispose resources
  Future<void> dispose() async {
    await stop();
    _isInitialized = false;
  }
}
