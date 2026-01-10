class RankingEntry {
  final int rank;
  final String userId;
  final String displayName;
  final String? avatarUrl;
  final int weeklyXp;
  final int level;
  final String league;
  final bool isCurrentUser;

  const RankingEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    this.avatarUrl,
    required this.weeklyXp,
    required this.level,
    required this.league,
    this.isCurrentUser = false,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      rank: json['rank'] as int,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      weeklyXp: json['weeklyXp'] as int,
      level: json['level'] as int,
      league: json['league'] as String,
      isCurrentUser: json['isCurrentUser'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rank': rank,
      'userId': userId,
      'displayName': displayName,
      'avatarUrl': avatarUrl,
      'weeklyXp': weeklyXp,
      'level': level,
      'league': league,
      'isCurrentUser': isCurrentUser,
    };
  }
}

class Leaderboard {
  final String league;
  final List<RankingEntry> rankings;
  final RankingEntry? currentUser;

  const Leaderboard({
    required this.league,
    required this.rankings,
    this.currentUser,
  });

  factory Leaderboard.fromJson(Map<String, dynamic> json) {
    return Leaderboard(
      league: json['league'] as String,
      rankings: (json['rankings'] as List<dynamic>)
          .map((e) => RankingEntry.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentUser: json['currentUser'] != null
          ? RankingEntry.fromJson(json['currentUser'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'league': league,
      'rankings': rankings.map((e) => e.toJson()).toList(),
      'currentUser': currentUser?.toJson(),
    };
  }
}

