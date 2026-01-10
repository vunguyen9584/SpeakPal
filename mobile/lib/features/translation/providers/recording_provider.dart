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

final audioRecorderProvider = Provider<AudioRecorder>((ref) => AudioRecorder());

final recordingProvider =
    NotifierProvider<RecordingNotifier, RecordingState>(
  () => RecordingNotifier(),
);

final recordingTimeProvider = NotifierProvider<RecordingTimeNotifier, int>(
  () => RecordingTimeNotifier(),
);

class RecordingTimeNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void update(int time) => state = time;
}

class RecordingNotifier extends Notifier<RecordingState> {
  late final AudioRecorder _recorder;
  Uint8List? _audioData;

  @override
  RecordingState build() {
    _recorder = ref.watch(audioRecorderProvider);
    ref.onDispose(() {
      _recorder.dispose();
    });
    return RecordingState.idle;
  }

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
          path: 'temp.wav',
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

  // dispose is handled in build
}
