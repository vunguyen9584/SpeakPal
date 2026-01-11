import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/services/shadowing_audio_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:just_audio/just_audio.dart';

class MockAudioPlayer extends Mock implements AudioPlayer {
  @override
  Stream<Duration> get positionStream => const Stream.empty();
  
  @override
  Stream<Duration?> get durationStream => const Stream.empty();
  
  @override
  Stream<PlayerState> get playerStateStream => const Stream.empty();
}

void main() {
  group('ShadowingAudioService Tests', () {
    late MockAudioPlayer mockModelPlayer;
    late MockAudioPlayer mockUserPlayer;
    late ShadowingAudioService service;

    setUp(() {
      mockModelPlayer = MockAudioPlayer();
      mockUserPlayer = MockAudioPlayer();
      service = ShadowingAudioService(
        modelPlayer: mockModelPlayer,
        userPlayer: mockUserPlayer,
      );
      
      // Register fallbacks
      registerFallbackValue(Duration.zero);
    });

    test('playModel calls play on model player', () async {
      when(() => mockModelPlayer.play()).thenAnswer((_) async {});

      await service.playModel();

      verify(() => mockModelPlayer.play()).called(1);
    });

    test('pauseModel calls pause on model player', () async {
      when(() => mockModelPlayer.pause()).thenAnswer((_) async {});

      await service.pauseModel();

      verify(() => mockModelPlayer.pause()).called(1);
    });

    test('seekModel calls seek on model player', () async {
      const position = Duration(seconds: 5);
      when(() => mockModelPlayer.seek(any())).thenAnswer((_) async {});

      await service.seekModel(position);

      verify(() => mockModelPlayer.seek(position)).called(1);
    });

    test('stopAll stops both players', () async {
      when(() => mockModelPlayer.stop()).thenAnswer((_) async {});
      when(() => mockUserPlayer.stop()).thenAnswer((_) async {});

      await service.stopAll();

      verify(() => mockModelPlayer.stop()).called(1);
      verify(() => mockUserPlayer.stop()).called(1);
    });
  });
}
