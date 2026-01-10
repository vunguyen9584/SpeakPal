import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/translation/models/translation_topic.dart';

void main() {
  group('TranslationTopic Tests', () {
    test('displayName returns correct Japanese strings', () {
      expect(TranslationTopic.daily.displayName, '日常会話');
      expect(TranslationTopic.business.displayName, 'ビジネス');
      expect(TranslationTopic.travel.displayName, '旅行');
      expect(TranslationTopic.news.displayName, 'ニュース');
      expect(TranslationTopic.entertainment.displayName, 'エンタメ');
    });

    test('value returns correct string identifiers', () {
      expect(TranslationTopic.daily.value, 'daily');
      expect(TranslationTopic.entertainment.value, 'entertainment');
    });
  });
}
