import 'dart:async';
import 'dart:typed_data';
import 'dart:io';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

class AudioRecorderService {
  final AudioRecorder _recorder = AudioRecorder();
  StreamSubscription<Amplitude>? _amplitudeSubscription;
  final _amplitudeController = StreamController<double>.broadcast();
  final _audioChunkController = StreamController<Uint8List>.broadcast();

  Stream<double> get amplitudeStream => _amplitudeController.stream;
  Stream<Uint8List> get audioChunkStream => _audioChunkController.stream;

  bool _isRecording = false;
  bool get isRecording => _isRecording;

  /// Request microphone permission
  Future<bool> requestPermission() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  /// Check if microphone permission is granted
  Future<bool> hasPermission() async {
    return await _recorder.hasPermission();
  }

  /// Start recording audio
  Future<void> startRecording() async {
    if (!await hasPermission()) {
      final granted = await requestPermission();
      if (!granted) {
        throw Exception('Microphone permission denied');
      }
    }

    final tempDir = Directory.systemTemp;
    final path = '${tempDir.path}/audio_recording.m4a';

    await _recorder.start(
      const RecordConfig(
        encoder: AudioEncoder.pcm16bits,
        sampleRate: 16000,
        numChannels: 1,
        bitRate: 128000,
      ),
      path: path,
    );

    _isRecording = true;

    // Listen to amplitude changes for waveform visualization
    _amplitudeSubscription = _recorder.onAmplitudeChanged(
      const Duration(milliseconds: 100),
    ).listen((amplitude) {
      _amplitudeController.add(amplitude.current);
    });

    // Stream audio chunks
    _startAudioStreaming();
  }

  /// Stream audio chunks for real-time processing
  void _startAudioStreaming() async {
    // TODO: Implement actual audio chunk streaming
    // This is a placeholder - actual implementation would depend on
    // the record package's streaming capabilities
  }

  /// Stop recording
  Future<String?> stopRecording() async {
    final path = await _recorder.stop();
    _isRecording = false;
    await _amplitudeSubscription?.cancel();
    return path;
  }

  /// Pause recording
  Future<void> pauseRecording() async {
    await _recorder.pause();
    _isRecording = false;
  }

  /// Resume recording
  Future<void> resumeRecording() async {
    await _recorder.resume();
    _isRecording = true;
  }

  /// Dispose resources
  void dispose() {
    _amplitudeSubscription?.cancel();
    _amplitudeController.close();
    _audioChunkController.close();
    _recorder.dispose();
  }
}
