import 'package:flutter_test/flutter_test.dart';
// import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/translation/providers/recording_provider.dart';
import 'package:record/record.dart';
import 'package:flutter/services.dart';

class FakeAudioRecorder implements AudioRecorder {
  @override
  Future<void> dispose() async {}

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<bool> isEncoderSupported(AudioEncoder encoder) async => true;

  @override
  Future<bool> isPaused() async => false;

  @override
  Future<bool> isRecording() async => false;

  @override
  Future<void> pause() async {}

  @override
  Future<void> resume() async {}

  @override
  Future<void> start(RecordConfig config, {required String path}) async {}

  @override
  Future<String?> stop() async => 'test.wav';
  
  @override
  Future<void> cancel() async {}
  
  @override
  Future<List<InputDevice>> listInputDevices() async => [];
  
  @override
  Future<Amplitude> getAmplitude() async => Amplitude(current: 0, max: 0);

  @override
  Stream<Amplitude> onAmplitudeChanged(Duration interval) => Stream.value(Amplitude(current: 0, max: 0));

  @override
  Stream<RecordState> onStateChanged() => Stream.value(RecordState.stop);

  @override
  Future<Stream<Uint8List>> startStream(RecordConfig config) async {
    return Stream.value(Uint8List(0));
  }

  @override
  List<int> convertBytesToInt16(Uint8List bytes, [endian]) {
    return [];
  }

  @override
  // TODO: implement ios
  RecordIos? get ios => null;
}

void main() {
  group('RecordingProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      TestWidgetsFlutterBinding.ensureInitialized();
      
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'checkPermissionStatus') {
            return 1; // granted
          }
          if (methodCall.method == 'requestPermissions') {
            final permissions = methodCall.arguments as List;
            return { for (var p in permissions) p : 1 }; // all granted
          }
          return null;
        },
      );

      container = ProviderContainer(
        overrides: [
          audioRecorderProvider.overrideWithValue(FakeAudioRecorder()),
        ],
      );
    });

    tearDown(() {
       TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('flutter.baseflow.com/permissions/methods'),
        null,
      );
      container.dispose();
    });

    test('should initialize with idle state', () {
      final state = container.read(recordingProvider);
      expect(state, RecordingState.idle);
    });

    test('should transition to recording state', () async {
      final notifier = container.read(recordingProvider.notifier);
      
      await notifier.startRecording();
      
      expect(container.read(recordingProvider), RecordingState.recording);
    });

    test('should stop recording and return data', () async {
      final notifier = container.read(recordingProvider.notifier);
      
      await notifier.startRecording();
      final data = await notifier.stopRecording();
      
      expect(data, isNotNull);
      expect(container.read(recordingProvider), RecordingState.idle);
    });

    test('should reset to idle state', () {
      final notifier = container.read(recordingProvider.notifier);
      
      notifier.reset();
      
      expect(notifier.state, RecordingState.idle);
      expect(notifier.audioData, isNull);
    });

    test('recording time provider should initialize to 0', () {
      final time = container.read(recordingTimeProvider);
      expect(time, 0);
    });

    test('should update recording time', () {
      container.read(recordingTimeProvider.notifier).update(15);
      
      final time = container.read(recordingTimeProvider);
      expect(time, 15);
    });
  });

  group('RecordingState Enum Tests', () {
    test('should have all required states', () {
      expect(RecordingState.values.length, 4);
      expect(RecordingState.values, contains(RecordingState.idle));
      expect(RecordingState.values, contains(RecordingState.permissionDenied));
      expect(RecordingState.values, contains(RecordingState.recording));
      expect(RecordingState.values, contains(RecordingState.processing));
    });
  });
}
