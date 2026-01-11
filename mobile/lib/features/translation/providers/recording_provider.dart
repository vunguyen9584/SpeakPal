import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:record/record.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

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
            sampleRate: 44100,
          ),
          path: await _getTempPath(),
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
        final file = File(path);
        if (await file.exists()) {
          _audioData = await file.readAsBytes();
          // cleanup
          await file.delete();
        }
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

  Future<String> _getTempPath() async {
    final tempDir = await getTemporaryDirectory();
    return '${tempDir.path}/recording_${DateTime.now().millisecondsSinceEpoch}.wav';
  }
}

