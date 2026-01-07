import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';
import 'package:just_audio/just_audio.dart';

class AudioPlayerService {
  final AudioPlayer _player = AudioPlayer();
  final Queue<Uint8List> _audioQueue = Queue<Uint8List>();
  bool _isPlaying = false;
  StreamSubscription? _playerStateSubscription;

  Stream<PlayerState> get playerStateStream => _player.playerStateStream;
  Stream<Duration> get positionStream => _player.positionStream;
  bool get isPlaying => _isPlaying;

  /// Initialize audio player
  Future<void> initialize() async {
    _playerStateSubscription = _player.playerStateStream.listen((state) {
      _isPlaying = state.playing;
      if (state.processingState == ProcessingState.completed) {
        _playNextChunk();
      }
    });
  }

  /// Play audio from stream of chunks
  Future<void> playStream(Stream<Uint8List> audioStream) async {
    await for (final chunk in audioStream) {
      _audioQueue.add(chunk);
      if (!_isPlaying && _audioQueue.isNotEmpty) {
        await _playNextChunk();
      }
    }
  }

  /// Play a single audio chunk
  Future<void> playChunk(Uint8List chunk) async {
    _audioQueue.add(chunk);
    if (!_isPlaying) {
      await _playNextChunk();
    }
  }

  /// Play next chunk from queue
  Future<void> _playNextChunk() async {
    if (_audioQueue.isEmpty) {
      _isPlaying = false;
      return;
    }

    final chunk = _audioQueue.removeFirst();
    
    try {
      // Create audio source from bytes
      // Note: This is a simplified implementation
      // In production, you might need to use a custom audio source
      // or convert the raw PCM data to a supported format
      
      await _player.setAudioSource(
        AudioSource.uri(
          Uri.dataFromBytes(chunk, mimeType: 'audio/wav'),
        ),
      );
      await _player.play();
    } catch (e) {
      print('Error playing audio chunk: $e');
      _playNextChunk(); // Try next chunk
    }
  }

  /// Stop playback and clear queue
  Future<void> stop() async {
    await _player.stop();
    _audioQueue.clear();
    _isPlaying = false;
  }

  /// Pause playback
  Future<void> pause() async {
    await _player.pause();
  }

  /// Resume playback
  Future<void> resume() async {
    await _player.play();
  }

  /// Set volume (0.0 to 1.0)
  Future<void> setVolume(double volume) async {
    await _player.setVolume(volume.clamp(0.0, 1.0));
  }

  /// Set playback speed
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed.clamp(0.5, 2.0));
  }

  /// Dispose resources
  void dispose() {
    _playerStateSubscription?.cancel();
    _player.dispose();
    _audioQueue.clear();
  }
}
