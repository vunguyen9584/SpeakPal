// Scenario Model
class Scenario {
  final String id;
  final String title;
  final String description;
  final String category;
  final String difficulty;
  final int estimatedMinutes;
  final String prompt;
  final List<String> suggestedTopics;

  Scenario({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.difficulty,
    required this.estimatedMinutes,
    required this.prompt,
    required this.suggestedTopics,
  });

  factory Scenario.fromJson(Map<String, dynamic> json) {
    return Scenario(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as String,
      estimatedMinutes: json['estimatedMinutes'] as int,
      prompt: json['prompt'] as String,
      suggestedTopics: (json['suggestedTopics'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );
  }
}

