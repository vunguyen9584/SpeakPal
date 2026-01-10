import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/translation_topic.dart';

final topicProvider = NotifierProvider<TopicNotifier, TranslationTopic>(
  () => TopicNotifier(),
);

class TopicNotifier extends Notifier<TranslationTopic> {
  @override
  TranslationTopic build() {
    _loadSavedTopic();
    return TranslationTopic.daily;
  }

  Future<void> _loadSavedTopic() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTopic = prefs.getString('translation_topic');
    if (savedTopic != null) {
      final topic = TranslationTopic.values.firstWhere(
        (t) => t.value == savedTopic,
        orElse: () => TranslationTopic.daily,
      );
      state = topic;
    }
  }

  Future<void> setTopic(TranslationTopic topic) async {
    state = topic;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('translation_topic', topic.value);
  }
}
