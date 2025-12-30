// Vocabulary Model
class Vocabulary {
  final String id;
  final String word;
  final String meaning;
  final String pronunciation;
  final String? exampleSentence;
  final String srsLevel;
  final DateTime nextReviewDate;
  final int reviewCount;
  final int correctCount;
  final DateTime createdAt;
  final String? conversationId;

  Vocabulary({
    required this.id,
    required this.word,
    required this.meaning,
    required this.pronunciation,
    this.exampleSentence,
    required this.srsLevel,
    required this.nextReviewDate,
    required this.reviewCount,
    required this.correctCount,
    required this.createdAt,
    this.conversationId,
  });

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'] as String,
      word: json['word'] as String,
      meaning: json['meaning'] as String,
      pronunciation: json['pronunciation'] as String,
      exampleSentence: json['exampleSentence'] as String?,
      srsLevel: json['srsLevel'] as String,
      nextReviewDate: DateTime.parse(json['nextReviewDate'] as String),
      reviewCount: json['reviewCount'] as int,
      correctCount: json['correctCount'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      conversationId: json['conversationId'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'word': word,
      'meaning': meaning,
      'pronunciation': pronunciation,
      'exampleSentence': exampleSentence,
      'srsLevel': srsLevel,
      'nextReviewDate': nextReviewDate.toIso8601String(),
      'reviewCount': reviewCount,
      'correctCount': correctCount,
      'createdAt': createdAt.toIso8601String(),
      'conversationId': conversationId,
    };
  }
}
