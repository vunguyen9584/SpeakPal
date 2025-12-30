class RecentConversation {
  final String id;
  final String mode;
  final int durationSeconds;
  final int pronunciationScore;
  final DateTime date;
  final String? topic;

  const RecentConversation({
    required this.id,
    required this.mode,
    required this.durationSeconds,
    required this.pronunciationScore,
    required this.date,
    this.topic,
  });

  factory RecentConversation.fromJson(Map<String, dynamic> json) {
    return RecentConversation(
      id: json['id'] as String,
      mode: json['mode'] as String,
      durationSeconds: json['durationSeconds'] as int,
      pronunciationScore: json['pronunciationScore'] as int,
      date: DateTime.parse(json['date'] as String),
      topic: json['topic'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode,
      'durationSeconds': durationSeconds,
      'pronunciationScore': pronunciationScore,
      'date': date.toIso8601String(),
      'topic': topic,
    };
  }

  String get formattedDuration {
    final minutes = durationSeconds ~/ 60;
    final seconds = durationSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  String get scoreColor {
    if (pronunciationScore >= 80) return 'green';
    if (pronunciationScore >= 60) return 'yellow';
    return 'red';
  }
}
