enum TurnSpeaker {
  user,
  ai,
}

class Turn {
  final String id;
  final TurnSpeaker speaker;
  final String content;
  final int sequence;
  final DateTime createdAt;
  final List<Correction>? corrections;

  const Turn({
    required this.id,
    required this.speaker,
    required this.content,
    required this.sequence,
    required this.createdAt,
    this.corrections,
  });

  factory Turn.fromJson(Map<String, dynamic> json) {
    return Turn(
      id: json['id'] as String,
      speaker: TurnSpeaker.values.firstWhere(
        (e) => e.name == json['speaker'],
      ),
      content: json['content'] as String,
      sequence: json['sequence'] as int,
      createdAt: DateTime.parse(json['createdAt'] as String),
      corrections: json['corrections'] != null
          ? (json['corrections'] as List)
              .map((c) => Correction.fromJson(c))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'speaker': speaker.name,
      'content': content,
      'sequence': sequence,
      'createdAt': createdAt.toIso8601String(),
      'corrections': corrections?.map((c) => c.toJson()).toList(),
    };
  }
}

class Correction {
  final String type;
  final String original;
  final String corrected;
  final String explanation;
  final String explanationJa;
  final String severity;

  const Correction({
    required this.type,
    required this.original,
    required this.corrected,
    required this.explanation,
    required this.explanationJa,
    required this.severity,
  });

  factory Correction.fromJson(Map<String, dynamic> json) {
    return Correction(
      type: json['type'] as String,
      original: json['original'] as String,
      corrected: json['corrected'] as String,
      explanation: json['explanation'] as String,
      explanationJa: json['explanationJa'] as String,
      severity: json['severity'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'original': original,
      'corrected': corrected,
      'explanation': explanation,
      'explanationJa': explanationJa,
      'severity': severity,
    };
  }
}
