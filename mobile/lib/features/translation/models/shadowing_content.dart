import 'package:freezed_annotation/freezed_annotation.dart';
import 'difficulty.dart';
import 'translation_topic.dart';

part 'shadowing_content.freezed.dart';
part 'shadowing_content.g.dart';

@freezed
abstract class ShadowingContent with _$ShadowingContent {
  const factory ShadowingContent({
    required String id,
    required String title,
    required String description,
    required Difficulty difficulty,
    required TranslationTopic topic,
    required String text,
    required String audioUrl,
    required Duration duration,
    required bool isPremium,
    required List<TextSegment> segments,
  }) = _ShadowingContent;

  factory ShadowingContent.fromJson(Map<String, dynamic> json) =>
      _$ShadowingContentFromJson(json);
}

@freezed
abstract class TextSegment with _$TextSegment {
  const factory TextSegment({
    required String id,
    required String text,
    required Duration startTime,
    required Duration endTime,
  }) = _TextSegment;

  factory TextSegment.fromJson(Map<String, dynamic> json) =>
      _$TextSegmentFromJson(json);
}
