class Stats {
  final DailyStats daily;
  final WeeklyStats weekly;
  final MonthlyStats monthly;
  final AllTimeStats allTime;
  final double averagePronunciation;
  final int currentStreak;

  Stats({
    required this.daily,
    required this.weekly,
    required this.monthly,
    required this.allTime,
    required this.averagePronunciation,
    required this.currentStreak,
  });

  factory Stats.fromJson(Map<String, dynamic> json) {
    return Stats(
      daily: DailyStats.fromJson(json['daily'] ?? {}),
      weekly: WeeklyStats.fromJson(json['weekly'] ?? {}),
      monthly: MonthlyStats.fromJson(json['monthly'] ?? {}),
      allTime: AllTimeStats.fromJson(json['allTime'] ?? {}),
      averagePronunciation: (json['averagePronunciation'] ?? 0).toDouble(),
      currentStreak: json['currentStreak'] ?? 0,
    );
  }
}

class DailyStats {
  final int conversations;
  final int minutes;
  final int xp;
  final int vocabulary;

  DailyStats({
    required this.conversations,
    required this.minutes,
    required this.xp,
    required this.vocabulary,
  });

  factory DailyStats.fromJson(Map<String, dynamic> json) {
    return DailyStats(
      conversations: json['conversations'] ?? 0,
      minutes: json['minutes'] ?? 0,
      xp: json['xp'] ?? 0,
      vocabulary: json['vocabulary'] ?? 0,
    );
  }
}

class WeeklyStats {
  final int conversations;
  final int minutes;
  final int xp;
  final int vocabulary;

  WeeklyStats({
    required this.conversations,
    required this.minutes,
    required this.xp,
    required this.vocabulary,
  });

  factory WeeklyStats.fromJson(Map<String, dynamic> json) {
    return WeeklyStats(
      conversations: json['conversations'] ?? 0,
      minutes: json['minutes'] ?? 0,
      xp: json['xp'] ?? 0,
      vocabulary: json['vocabulary'] ?? 0,
    );
  }
}

class MonthlyStats {
  final int conversations;
  final int minutes;
  final int xp;
  final int vocabulary;

  MonthlyStats({
    required this.conversations,
    required this.minutes,
    required this.xp,
    required this.vocabulary,
  });

  factory MonthlyStats.fromJson(Map<String, dynamic> json) {
    return MonthlyStats(
      conversations: json['conversations'] ?? 0,
      minutes: json['minutes'] ?? 0,
      xp: json['xp'] ?? 0,
      vocabulary: json['vocabulary'] ?? 0,
    );
  }
}

class AllTimeStats {
  final int totalConversations;
  final int totalMinutes;
  final int totalXp;

  AllTimeStats({
    required this.totalConversations,
    required this.totalMinutes,
    required this.totalXp,
  });

  factory AllTimeStats.fromJson(Map<String, dynamic> json) {
    return AllTimeStats(
      totalConversations: json['totalConversations'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      totalXp: json['totalXp'] ?? 0,
    );
  }
}

enum StatsPeriod {
  today,
  thisWeek,
  thisMonth,
  allTime,
}

