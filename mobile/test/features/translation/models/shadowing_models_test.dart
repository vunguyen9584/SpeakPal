import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/models/shadowing_models.dart';

void main() {
  group('Shadowing Models Tests', () {
    test('ContentType.displayName returns correct strings', () {
      expect(ContentType.conversation.displayName, '会話');
      expect(ContentType.news.displayName, 'ニュース');
      expect(ContentType.speech.displayName, 'スピーチ');
      expect(ContentType.podcast.displayName, 'ポッドキャスト');
    });

    test('ShadowingContent.fromJson creates valid object', () {
      final json = {
        'id': 's1',
        'title': 'Test Shadowing',
        'type': 'conversation',
        'level': 'N3',
        'durationSeconds': 60,
        'audioUrl': 'http://test.com/audio.mp3',
        'transcript': 'This is a test transcript.',
        'isPremium': false,
      };

      final content = ShadowingContent.fromJson(json);
      expect(content.id, 's1');
      expect(content.title, 'Test Shadowing');
      expect(content.isPremium, false);
    });

    test('ShadowingResult.fromJson creates valid object', () {
      final json = {
        'id': 'r1',
        'overallScore': 85,
        'breakdown': {
          'followingScore': 80,
          'pronunciationScore': 90,
          'rhythmScore': 85,
          'completenessScore': 85,
        },
        'weakSegments': [
          {
            'startTime': 10.5,
            'endTime': 12.0,
            'text': 'difficult part',
            'issueType': 'pronunciation',
          }
        ],
        'feedback': ['Good job'],
        'xpEarned': 20,
      };

      final result = ShadowingResult.fromJson(json);
      expect(result.id, 'r1');
      expect(result.overallScore, 85);
      expect(result.breakdown.pronunciationScore, 90);
      expect(result.weakSegments.first.text, 'difficult part');
    });

    test('WeakSegment.fromJson creates valid object', () {
      final json = {
        'startTime': 1.0,
        'endTime': 2.0,
        'text': 'test',
        'issueType': 'timing',
      };
      final segment = WeakSegment.fromJson(json);
      expect(segment.startTime, 1.0);
      expect(segment.issueType, 'timing');
    });
  });
}
