// Challenge Model
class UserChallenge {
  final String id;
  final String type;
  final String title;
  final String description;
  final int targetProgress;
  final int currentProgress;
  final int xpReward;
  final bool completed;
  final DateTime date;

  UserChallenge({
    required this.id,
    required this.type,
    required this.title,
    required this.description,
    required this.targetProgress,
    required this.currentProgress,
    required this.xpReward,
    required this.completed,
    required this.date,
  });

  factory UserChallenge.fromJson(Map<String, dynamic> json) {
    return UserChallenge(
      id: json['id'] as String,
      type: json['type'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      targetProgress: json['targetProgress'] as int,
      currentProgress: json['currentProgress'] as int,
      xpReward: json['xpReward'] as int,
      completed: json['completed'] as bool,
      date: DateTime.parse(json['date'] as String),
    );
  }

  double get progressPercent =>
      targetProgress > 0 ? (currentProgress / targetProgress) * 100 : 0;
}
