import 'package:freezed_annotation/freezed_annotation.dart';

part 'history_item.freezed.dart';
part 'history_item.g.dart';

/// History item representing a user activity
@freezed
class HistoryItem with _$HistoryItem {
  const factory HistoryItem({
    required String id,
    required HistoryActivityType type,
    required DateTime timestamp,
    required String description,
    required int xpEarned,
    required Map<String, dynamic> metadata,
  }) = _HistoryItem;

  factory HistoryItem.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemFromJson(json);
}

/// Type of activity in history
enum HistoryActivityType {
  @JsonValue('conversation')
  conversation,
  @JsonValue('vocabulary_review')
  vocabularyReview,
  @JsonValue('challenge')
  challenge,
  @JsonValue('badge_earned')
  badgeEarned,
  @JsonValue('level_up')
  levelUp,
}

/// Extension for activity type display
extension HistoryActivityTypeExtension on HistoryActivityType {
  String get displayName {
    switch (this) {
      case HistoryActivityType.conversation:
        return 'Conversation';
      case HistoryActivityType.vocabularyReview:
        return 'Vocabulary Review';
      case HistoryActivityType.challenge:
        return 'Challenge';
      case HistoryActivityType.badgeEarned:
        return 'Badge Earned';
      case HistoryActivityType.levelUp:
        return 'Level Up';
    }
  }
}

/// Paginated history response
@freezed
class PaginatedHistory with _$PaginatedHistory {
  const factory PaginatedHistory({
    required List<HistoryItem> items,
    required int totalCount,
    required int page,
    required int pageSize,
    required bool hasMore,
  }) = _PaginatedHistory;

  factory PaginatedHistory.fromJson(Map<String, dynamic> json) =>
      _$PaginatedHistoryFromJson(json);
}

/// History query parameters
@freezed
class HistoryQuery with _$HistoryQuery {
  const factory HistoryQuery({
    required int page,
    required int pageSize,
    DateTime? startDate,
    DateTime? endDate,
    HistoryActivityType? type,
  }) = _HistoryQuery;

  factory HistoryQuery.fromJson(Map<String, dynamic> json) =>
      _$HistoryQueryFromJson(json);
}
