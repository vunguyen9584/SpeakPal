import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';

enum RecordingState {
  idle,
  permissionDenied,
  recording,
  processing,
}

final recordingProvider =
    StateNotifierProvider<RecordingNotifier, RecordingState>(
  (ref) => RecordingNotifier(),
);

final recordingTimeProvider = StateProvider<int>((ref) => 0);

class RecordingNotifier extends StateNotifier<RecordingState> {
  final AudioRecorder _recorder = AudioRecorder();
  Uint8List? _audioData;

  RecordingNotifier() : super(RecordingState.idle);

  Uint8List? get audioData => _audioData;

  Future<bool> checkPermission() async {
    final status = await Permission.microphone.request();
    if (status.isDenied || status.isPermanentlyDenied) {
      state = RecordingState.permissionDenied;
      return false;
    }
    return true;
  }

  Future<void> startRecording() async {
    if (!await checkPermission()) return;

    try {
      if (await _recorder.hasPermission()) {
        await _recorder.start(
          const RecordConfig(
            encoder: AudioEncoder.wav,
            bitRate: 128000,
            sampleRate: 44100,
          ),
        );
        state = RecordingState.recording;
      }
    } catch (e) {
      state = RecordingState.idle;
      rethrow;
    }
  }

  Future<Uint8List?> stopRecording() async {
    try {
      state = RecordingState.processing;
      final path = await _recorder.stop();
      
      if (path != null) {
        // In production, read file and convert to Uint8List
        // For now, return empty data
        _audioData = Uint8List(0);
        state = RecordingState.idle;
        return _audioData;
      }
      
      state = RecordingState.idle;
      return null;
    } catch (e) {
      state = RecordingState.idle;
      rethrow;
    }
  }

  void reset() {
    _audioData = null;
    state = RecordingState.idle;
  }

  @override
  void dispose() {
    _recorder.dispose();
    super.dispose();
  }
}
