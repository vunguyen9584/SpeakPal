import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/learning/domain/models/vocabulary.dart';

void main() {
  group('Vocabulary Model Tests', () {
    final now = DateTime.now();
    final nextReview = now.add(const Duration(days: 1));

    test('Vocabulary.fromJson creates a valid object', () {
      final json = {
        'id': 'v1',
        'word': 'apple',
        'meaning': 'リンゴ',
        'pronunciation': 'æpl',
        'exampleSentence': 'I eat an apple.',
        'srsLevel': 'learning',
        'nextReviewDate': nextReview.toIso8601String(),
        'reviewCount': 5,
        'correctCount': 4,
        'createdAt': now.toIso8601String(),
        'conversationId': 'c1',
      };

      final vocab = Vocabulary.fromJson(json);

      expect(vocab.id, 'v1');
      expect(vocab.word, 'apple');
      expect(vocab.meaning, 'リンゴ');
      expect(vocab.nextReviewDate.year, nextReview.year);
    });

    test('Vocabulary.toJson returns a valid map', () {
      final vocab = Vocabulary(
        id: 'v1',
        word: 'apple',
        meaning: 'リンゴ',
        pronunciation: 'æpl',
        exampleSentence: 'I eat an apple.',
        srsLevel: 'learning',
        nextReviewDate: nextReview,
        reviewCount: 5,
        correctCount: 4,
        createdAt: now,
        conversationId: 'c1',
      );

      final json = vocab.toJson();

      expect(json['id'], 'v1');
      expect(json['word'], 'apple');
      expect(json['nextReviewDate'], nextReview.toIso8601String());
    });
  });
}
