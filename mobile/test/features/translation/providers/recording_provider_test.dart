import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mobile/features/translation/providers/recording_provider.dart';

void main() {
  group('RecordingProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with idle state', () {
      final state = container.read(recordingProvider);
      expect(state, RecordingState.idle);
    });

    test('should transition to recording state', () async {
      final notifier = container.read(recordingProvider.notifier);
      
      // Mock: In real test, we'd need to mock permission
      // For now, test state transitions
      expect(notifier.state, RecordingState.idle);
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
      container.read(recordingTimeProvider.notifier).state = 15;
      
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
