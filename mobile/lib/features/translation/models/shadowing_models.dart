import 'package:freezed_annotation/freezed_annotation.dart';

part 'shadowing_models.freezed.dart';
part 'shadowing_models.g.dart';

enum ContentType {
  @JsonValue('conversation')
  conversation,
  @JsonValue('news')
  news,
  @JsonValue('speech')
  speech,
  @JsonValue('podcast')
  podcast;

  String get displayName {
    switch (this) {
      case ContentType.conversation:
        return '会話';
      case ContentType.news:
        return 'ニュース';
      case ContentType.speech:
        return 'スピーチ';
      case ContentType.podcast:
        return 'ポッドキャスト';
    }
  }
}

@freezed
abstract class ShadowingContent with _$ShadowingContent {
  const factory ShadowingContent({
    required String id,
    required String title,
    required String type,
    required String level,
    required int durationSeconds,
    required String audioUrl,
    required String transcript,
    String? thumbnailUrl,
    required bool isPremium,
  }) = _ShadowingContent;

  factory ShadowingContent.fromJson(Map<String, dynamic> json) =>
      _$ShadowingContentFromJson(json);
}

@freezed
abstract class ShadowingResult with _$ShadowingResult {
  const factory ShadowingResult({
    required String id,
    required int overallScore,
    required ShadowingScoreBreakdown breakdown,
    required List<WeakSegment> weakSegments,
    required List<String> feedback,
    required int xpEarned,
  }) = _ShadowingResult;

  factory ShadowingResult.fromJson(Map<String, dynamic> json) =>
      _$ShadowingResultFromJson(json);
}

@freezed
abstract class ShadowingScoreBreakdown with _$ShadowingScoreBreakdown {
  const factory ShadowingScoreBreakdown({
    required int followingScore,
    required int pronunciationScore,
    required int rhythmScore,
    required int completenessScore,
  }) = _ShadowingScoreBreakdown;

  factory ShadowingScoreBreakdown.fromJson(Map<String, dynamic> json) =>
      _$ShadowingScoreBreakdownFromJson(json);
}

@freezed
abstract class WeakSegment with _$WeakSegment {
  const factory WeakSegment({
    required double startTime,
    required double endTime,
    required String text,
    required String issueType, // pronunciation, timing, skipped
  }) = _WeakSegment;

  factory WeakSegment.fromJson(Map<String, dynamic> json) =>
      _$WeakSegmentFromJson(json);
}
