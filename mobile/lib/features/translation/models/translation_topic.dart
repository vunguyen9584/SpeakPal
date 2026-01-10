import 'package:freezed_annotation/freezed_annotation.dart';


/// Translation practice topics
enum TranslationTopic {
  @JsonValue('daily')
  daily,
  @JsonValue('business')
  business,
  @JsonValue('travel')
  travel,
  @JsonValue('news')
  news,
  @JsonValue('entertainment')
  entertainment;

  String get displayName {
    switch (this) {
      case TranslationTopic.daily:
        return '日常会話';
      case TranslationTopic.business:
        return 'ビジネス';
      case TranslationTopic.travel:
        return '旅行';
      case TranslationTopic.news:
        return 'ニュース';
      case TranslationTopic.entertainment:
        return 'エンタメ';
    }
  }

  String get value {
    switch (this) {
      case TranslationTopic.daily:
        return 'daily';
      case TranslationTopic.business:
        return 'business';
      case TranslationTopic.travel:
        return 'travel';
      case TranslationTopic.news:
        return 'news';
      case TranslationTopic.entertainment:
        return 'entertainment';
    }
  }
}

