class WeeklyReport {
  final int weekNumber;
  final DateTime startDate;
  final DateTime endDate;
  final ReportSummary summary;
  final List<double> pronunciationTrend;
  final List<TopCorrection> topCorrections;
  final VocabularyProgress vocabularyProgress;
  final List<Achievement> achievements;

  WeeklyReport({
    required this.weekNumber,
    required this.startDate,
    required this.endDate,
    required this.summary,
    required this.pronunciationTrend,
    required this.topCorrections,
    required this.vocabularyProgress,
    required this.achievements,
  });

  factory WeeklyReport.fromJson(Map<String, dynamic> json) {
    return WeeklyReport(
      weekNumber: json['weekNumber'] ?? 0,
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      summary: ReportSummary.fromJson(json['summary'] ?? {}),
      pronunciationTrend: (json['pronunciationTrend'] as List?)
              ?.map((e) => (e as num).toDouble())
              .toList() ??
          [],
      topCorrections: (json['topCorrections'] as List?)
              ?.map((e) => TopCorrection.fromJson(e))
              .toList() ??
          [],
      vocabularyProgress:
          VocabularyProgress.fromJson(json['vocabularyProgress'] ?? {}),
      achievements: (json['achievements'] as List?)
              ?.map((e) => Achievement.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class ReportSummary {
  final int totalConversations;
  final int totalMinutes;
  final int totalXp;

  ReportSummary({
    required this.totalConversations,
    required this.totalMinutes,
    required this.totalXp,
  });

  factory ReportSummary.fromJson(Map<String, dynamic> json) {
    return ReportSummary(
      totalConversations: json['totalConversations'] ?? 0,
      totalMinutes: json['totalMinutes'] ?? 0,
      totalXp: json['totalXp'] ?? 0,
    );
  }
}

class TopCorrection {
  final String type;
  final int count;
  final String example;

  TopCorrection({
    required this.type,
    required this.count,
    required this.example,
  });

  factory TopCorrection.fromJson(Map<String, dynamic> json) {
    return TopCorrection(
      type: json['type'] ?? '',
      count: json['count'] ?? 0,
      example: json['example'] ?? '',
    );
  }
}

class VocabularyProgress {
  final int newWords;
  final int masteredWords;

  VocabularyProgress({
    required this.newWords,
    required this.masteredWords,
  });

  factory VocabularyProgress.fromJson(Map<String, dynamic> json) {
    return VocabularyProgress(
      newWords: json['newWords'] ?? 0,
      masteredWords: json['masteredWords'] ?? 0,
    );
  }
}

class Achievement {
  final String type;
  final String name;
  final String description;
  final DateTime earnedAt;

  Achievement({
    required this.type,
    required this.name,
    required this.description,
    required this.earnedAt,
  });

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      type: json['type'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      earnedAt: DateTime.parse(json['earnedAt']),
    );
  }
}
