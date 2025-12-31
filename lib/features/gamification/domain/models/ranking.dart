import 'package:freezed_annotation/freezed_annotation.dart';

part 'ranking.freezed.dart';
part 'ranking.g.dart';

/// Ranking response containing leaderboard data
@freezed
class RankingResponse with _$RankingResponse {
  const factory RankingResponse({
    required League league,
    required int weekNumber,
    required DateTime weekStart,
    required DateTime weekEnd,
    required List<RankingEntry> rankings,
    required UserRankInfo? currentUserRank,
    required int promotionThreshold,
    required int demotionThreshold,
  }) = _RankingResponse;

  factory RankingResponse.fromJson(Map<String, dynamic> json) =>
      _$RankingResponseFromJson(json);
}

/// Single entry in the ranking list
@freezed
class RankingEntry with _$RankingEntry {
  const factory RankingEntry({
    required int rank,
    required String userId,
    required String userName,
    required String? avatarUrl,
    required int weeklyXp,
    required League league,
    required bool isCurrentUser,
  }) = _RankingEntry;

  factory RankingEntry.fromJson(Map<String, dynamic> json) =>
      _$RankingEntryFromJson(json);
}

/// User's rank information
@freezed
class UserRankInfo with _$UserRankInfo {
  const factory UserRankInfo({
    required int rank,
    required int weeklyXp,
    required League league,
    required RankZone zone,
    required int xpToPromotion,
    required int xpToDemotion,
  }) = _UserRankInfo;

  factory UserRankInfo.fromJson(Map<String, dynamic> json) =>
      _$UserRankInfoFromJson(json);
}

/// League levels in the ranking system
enum League {
  @JsonValue('bronze')
  bronze,
  @JsonValue('silver')
  silver,
  @JsonValue('gold')
  gold,
  @JsonValue('platinum')
  platinum,
  @JsonValue('diamond')
  diamond,
}

/// Zone within a league (promotion, safe, demotion)
enum RankZone {
  @JsonValue('promotion')
  promotion,
  @JsonValue('safe')
  safe,
  @JsonValue('demotion')
  demotion,
}

/// Extension to get display properties for League
extension LeagueExtension on League {
  String get displayName {
    switch (this) {
      case League.bronze:
        return 'Bronze';
      case League.silver:
        return 'Silver';
      case League.gold:
        return 'Gold';
      case League.platinum:
        return 'Platinum';
      case League.diamond:
        return 'Diamond';
    }
  }

  String get color {
    switch (this) {
      case League.bronze:
        return '#CD7F32';
      case League.silver:
        return '#C0C0C0';
      case League.gold:
        return '#FFD700';
      case League.platinum:
        return '#E5E4E2';
      case League.diamond:
        return '#B9F2FF';
    }
  }
}

/// Extension to get display properties for RankZone
extension RankZoneExtension on RankZone {
  String get displayName {
    switch (this) {
      case RankZone.promotion:
        return 'Promotion Zone';
      case RankZone.safe:
        return 'Safe Zone';
      case RankZone.demotion:
        return 'Demotion Zone';
    }
  }

  String get color {
    switch (this) {
      case RankZone.promotion:
        return '#4CAF50'; // Green
      case RankZone.safe:
        return '#2196F3'; // Blue
      case RankZone.demotion:
        return '#F44336'; // Red
    }
  }
}
