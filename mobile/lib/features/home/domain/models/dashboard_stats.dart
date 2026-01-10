class DashboardStats {
  final int todayMinutes;
  final int weeklyMinutes;
  final int currentStreak;
  final int totalXp;
  final int level;
  final double pronunciationAvg;
  final int conversationsToday;
  final int dailyGoal;

  const DashboardStats({
    required this.todayMinutes,
    required this.weeklyMinutes,
    required this.currentStreak,
    required this.totalXp,
    required this.level,
    required this.pronunciationAvg,
    required this.conversationsToday,
    required this.dailyGoal,
  });

  factory DashboardStats.fromJson(Map<String, dynamic> json) {
    return DashboardStats(
      todayMinutes: json['todayMinutes'] as int,
      weeklyMinutes: json['weeklyMinutes'] as int,
      currentStreak: json['currentStreak'] as int,
      totalXp: json['totalXp'] as int,
      level: json['level'] as int,
      pronunciationAvg: (json['pronunciationAvg'] as num).toDouble(),
      conversationsToday: json['conversationsToday'] as int,
      dailyGoal: json['dailyGoal'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'todayMinutes': todayMinutes,
      'weeklyMinutes': weeklyMinutes,
      'currentStreak': currentStreak,
      'totalXp': totalXp,
      'level': level,
      'pronunciationAvg': pronunciationAvg,
      'conversationsToday': conversationsToday,
      'dailyGoal': dailyGoal,
    };
  }

  double get progressPercentage => (todayMinutes / dailyGoal).clamp(0.0, 1.0);
}

