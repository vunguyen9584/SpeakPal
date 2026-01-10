import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/progress/domain/models/stats.dart';

void main() {
  group('Stats Model Tests', () {
    test('Stats.fromJson creates a valid Stats object', () {
      final json = {
        'daily': {
          'conversations': 2,
          'minutes': 15,
          'xp': 100,
          'vocabulary': 10,
        },
        'weekly': {
          'conversations': 10,
          'minutes': 60,
          'xp': 500,
          'vocabulary': 50,
        },
        'monthly': {
          'conversations': 40,
          'minutes': 250,
          'xp': 2000,
          'vocabulary': 200,
        },
        'allTime': {
          'totalConversations': 100,
          'totalMinutes': 600,
          'totalXp': 5000,
        },
        'averagePronunciation': 85.5,
        'currentStreak': 5,
      };

      final stats = Stats.fromJson(json);

      expect(stats.daily.conversations, 2);
      expect(stats.weekly.minutes, 60);
      expect(stats.monthly.xp, 2000);
      expect(stats.allTime.totalConversations, 100);
      expect(stats.averagePronunciation, 85.5);
      expect(stats.currentStreak, 5);
    });

    test('Stats.fromJson handles missing or null fields', () {
      final json = <String, dynamic>{};
      final stats = Stats.fromJson(json);

      expect(stats.daily.conversations, 0);
      expect(stats.averagePronunciation, 0.0);
      expect(stats.currentStreak, 0);
    });

    test('StatsPeriod enum has correct values', () {
      expect(StatsPeriod.today.index, 0);
      expect(StatsPeriod.values.length, 4);
    });
  });
}
