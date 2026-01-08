import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mobile/features/translation/models/translation_topic.dart';
import 'package:mobile/features/translation/providers/topic_provider.dart';

void main() {
  group('TopicProvider Tests', () {
    late ProviderContainer container;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      container = ProviderContainer();
    });

    tearDown(() {
      container.dispose();
    });

    test('should initialize with daily topic by default', () {
      final topic = container.read(topicProvider);
      expect(topic, TranslationTopic.daily);
    });

    test('should update topic when setTopic is called', () async {
      final notifier = container.read(topicProvider.notifier);
      
      await notifier.setTopic(TranslationTopic.business);
      
      final topic = container.read(topicProvider);
      expect(topic, TranslationTopic.business);
    });

    test('should persist topic to SharedPreferences', () async {
      final notifier = container.read(topicProvider.notifier);
      
      await notifier.setTopic(TranslationTopic.travel);
      
      final prefs = await SharedPreferences.getInstance();
      final savedTopic = prefs.getString('translation_topic');
      expect(savedTopic, 'travel');
    });

    test('should load saved topic from SharedPreferences', () async {
      SharedPreferences.setMockInitialValues({
        'translation_topic': 'news',
      });
      
      final newContainer = ProviderContainer();
      
      // Wait for async initialization
      await Future.delayed(const Duration(milliseconds: 100));
      
      final topic = newContainer.read(topicProvider);
      expect(topic, TranslationTopic.news);
      
      newContainer.dispose();
    });

    test('should handle all topic values correctly', () async {
      final notifier = container.read(topicProvider.notifier);
      
      for (final topic in TranslationTopic.values) {
        await notifier.setTopic(topic);
        final currentTopic = container.read(topicProvider);
        expect(currentTopic, topic);
      }
    });
  });

  group('TranslationTopic Enum Tests', () {
    test('should have correct display names', () {
      expect(TranslationTopic.daily.displayName, '日常会話');
      expect(TranslationTopic.business.displayName, 'ビジネス');
      expect(TranslationTopic.travel.displayName, '旅行');
      expect(TranslationTopic.news.displayName, 'ニュース');
      expect(TranslationTopic.entertainment.displayName, 'エンタメ');
    });

    test('should have correct values', () {
      expect(TranslationTopic.daily.value, 'daily');
      expect(TranslationTopic.business.value, 'business');
      expect(TranslationTopic.travel.value, 'travel');
      expect(TranslationTopic.news.value, 'news');
      expect(TranslationTopic.entertainment.value, 'entertainment');
    });

    test('should have 5 topics', () {
      expect(TranslationTopic.values.length, 5);
    });
  });
}
