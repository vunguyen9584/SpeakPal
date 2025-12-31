import 'package:freezed_annotation/freezed_annotation.dart';

part 'badge.freezed.dart';
part 'badge.g.dart';

/// Badge model representing achievements in the gamification system
@freezed
class Badge with _$Badge {
  const factory Badge({
    required String id,
    required String name,
    required String description,
    required String iconUrl,
    required BadgeCategory category,
    required int xpBonus,
    required String conditionDescription,
    DateTime? earnedAt,
    double? progress,
  }) = _Badge;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
}

/// Badge earned by user with additional metadata
@freezed
class EarnedBadge with _$EarnedBadge {
  const factory EarnedBadge({
    required String id,
    required String badgeId,
    required String userId,
    required DateTime earnedAt,
    required Badge badge,
  }) = _EarnedBadge;

  factory EarnedBadge.fromJson(Map<String, dynamic> json) =>
      _$EarnedBadgeFromJson(json);
}

/// Badge category for filtering and organization
enum BadgeCategory {
  @JsonValue('all')
  all,
  @JsonValue('streak')
  streak,
  @JsonValue('level')
  level,
  @JsonValue('conversation')
  conversation,
  @JsonValue('vocabulary')
  vocabulary,
}

/// Extension to get display name for badge category
extension BadgeCategoryExtension on BadgeCategory {
  String get displayName {
    switch (this) {
      case BadgeCategory.all:
        return 'All';
      case BadgeCategory.streak:
        return 'Streak';
      case BadgeCategory.level:
        return 'Level';
      case BadgeCategory.conversation:
        return 'Conversation';
      case BadgeCategory.vocabulary:
        return 'Vocabulary';
    }
  }
}
