import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:mobile/core/utils/logger_service.dart';
import 'package:mobile/core/error/app_error.dart';

/// Service to handle audio playback for shadowing practice.
/// Manages both model audio and user recording playback.
class ShadowingAudioService {
  final AudioPlayer _modelPlayer;
  final AudioPlayer _userPlayer;

  ShadowingAudioService({
    AudioPlayer? modelPlayer,
    AudioPlayer? userPlayer,
  })  : _modelPlayer = modelPlayer ?? AudioPlayer(),
        _userPlayer = userPlayer ?? AudioPlayer();

  // Streams for position and state
  Stream<Duration> get modelPosition => _modelPlayer.positionStream;
  Stream<Duration> get modelDuration => _modelPlayer.durationStream.map((d) => d ?? Duration.zero);
  Stream<PlayerState> get modelPlayerState => _modelPlayer.playerStateStream;

  Stream<Duration> get userPosition => _userPlayer.positionStream;
  Stream<Duration> get userDuration => _userPlayer.durationStream.map((d) => d ?? Duration.zero);
  Stream<PlayerState> get userPlayerState => _userPlayer.playerStateStream;

  /// Initialize the service with the model audio URL
  Future<void> initialize(String audioUrl) async {
    try {
      final session = await AudioSession.instance;
      await session.configure(const AudioSessionConfiguration.speech());

      await _modelPlayer.setUrl(audioUrl);
      logger.info('Shadowing audio initialized', data: {'url': audioUrl});
    } catch (e, stackTrace) {
      logger.error('Failed to initialize shadowing audio', error: e, stackTrace: stackTrace);
      throw MediaError(
        'Failed to load audio',
        userMessage: 'Could not load audio. Please check your connection.',
        originalError: e,
        stackTrace: stackTrace,
      );
    }
  }

  /// Play model audio
  Future<void> playModel() async {
    try {
      await _modelPlayer.play();
    } catch (e, stackTrace) {
      throw MediaError('Model playback failed', originalError: e, stackTrace: stackTrace);
    }
  }

  /// Pause model audio
  Future<void> pauseModel() async {
    await _modelPlayer.pause();
  }

  /// Seek model audio to a specific position
  Future<void> seekModel(Duration position) async {
    await _modelPlayer.seek(position);
  }

  /// Set model playback speed
  Future<void> setModelSpeed(double speed) async {
    await _modelPlayer.setSpeed(speed);
  }

  /// Load user's recorded audio for review
  Future<void> loadUserAudio(String filePath) async {
    try {
      await _userPlayer.setFilePath(filePath);
    } catch (e, stackTrace) {
      throw MediaError('Failed to load user audio', originalError: e, stackTrace: stackTrace);
    }
  }

  /// Play both model and user audio simultaneously for comparison
  Future<void> playComparison() async {
    try {
      await _modelPlayer.seek(Duration.zero);
      await _userPlayer.seek(Duration.zero);
      
      await Future.wait([
        _modelPlayer.play(),
        _userPlayer.play(),
      ]);
    } catch (e, stackTrace) {
      throw MediaError('Comparison playback failed', originalError: e, stackTrace: stackTrace);
    }
  }

  /// Stop all playbacks
  Future<void> stopAll() async {
    await Future.wait([
      _modelPlayer.stop(),
      _userPlayer.stop(),
    ]);
  }

  /// Dispose players
  Future<void> dispose() async {
    await _modelPlayer.dispose();
    await _userPlayer.dispose();
  }
}
