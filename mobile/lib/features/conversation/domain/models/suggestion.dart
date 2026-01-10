class Suggestion {
  final String template;
  final List<VocabularyItem> vocabulary;
  final List<String> alternativeResponses;

  const Suggestion({
    required this.template,
    required this.vocabulary,
    required this.alternativeResponses,
  });

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      template: json['template'] as String,
      vocabulary: (json['vocabulary'] as List)
          .map((v) => VocabularyItem.fromJson(v))
          .toList(),
      alternativeResponses: (json['alternativeResponses'] as List)
          .map((r) => r as String)
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'template': template,
      'vocabulary': vocabulary.map((v) => v.toJson()).toList(),
      'alternativeResponses': alternativeResponses,
    };
  }
}

class VocabularyItem {
  final String word;
  final String pronunciation;
  final String meaning;
  final String partOfSpeech;
  final String exampleSentence;

  const VocabularyItem({
    required this.word,
    required this.pronunciation,
    required this.meaning,
    required this.partOfSpeech,
    required this.exampleSentence,
  });

  factory VocabularyItem.fromJson(Map<String, dynamic> json) {
    return VocabularyItem(
      word: json['word'] as String,
      pronunciation: json['pronunciation'] as String,
      meaning: json['meaning'] as String,
      partOfSpeech: json['partOfSpeech'] as String,
      exampleSentence: json['exampleSentence'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'word': word,
      'pronunciation': pronunciation,
      'meaning': meaning,
      'partOfSpeech': partOfSpeech,
      'exampleSentence': exampleSentence,
    };
  }
}

