class Streak {
  final int currentStreak;
  final int longestStreak;
  final int streakFreezeCount;
  final DateTime? lastActivityDate;
  final List<String> milestones;

  const Streak({
    required this.currentStreak,
    required this.longestStreak,
    required this.streakFreezeCount,
    this.lastActivityDate,
    required this.milestones,
  });

  factory Streak.fromJson(Map<String, dynamic> json) {
    return Streak(
      currentStreak: json['currentStreak'] as int,
      longestStreak: json['longestStreak'] as int,
      streakFreezeCount: json['streakFreezeCount'] as int,
      lastActivityDate: json['lastActivityDate'] != null
          ? DateTime.parse(json['lastActivityDate'] as String)
          : null,
      milestones: (json['milestones'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'streakFreezeCount': streakFreezeCount,
      'lastActivityDate': lastActivityDate?.toIso8601String(),
      'milestones': milestones,
    };
  }
}

class StreakDay {
  final DateTime date;
  final bool hasActivity;
  final bool wasFrozen;

  const StreakDay({
    required this.date,
    required this.hasActivity,
    this.wasFrozen = false,
  });
}


