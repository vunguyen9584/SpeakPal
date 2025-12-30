enum ConversationMode {
  freetalk,
  instructor,
  roleplay,
}

enum ConversationStatus {
  active,
  paused,
  ended,
}

class Conversation {
  final String id;
  final ConversationMode mode;
  final String personaId;
  final String personaName;
  final DateTime startedAt;
  final DateTime? endedAt;
  final String? topic;
  final ConversationStatus status;
  final String websocketUrl;
  final String token;

  const Conversation({
    required this.id,
    required this.mode,
    required this.personaId,
    required this.personaName,
    required this.startedAt,
    this.endedAt,
    this.topic,
    required this.status,
    required this.websocketUrl,
    required this.token,
  });

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      mode: ConversationMode.values.firstWhere(
        (e) => e.name == json['mode'],
        orElse: () => ConversationMode.freetalk,
      ),
      personaId: json['personaId'] as String,
      personaName: json['personaName'] as String,
      startedAt: DateTime.parse(json['startedAt'] as String),
      endedAt: json['endedAt'] != null ? DateTime.parse(json['endedAt'] as String) : null,
      topic: json['topic'] as String?,
      status: ConversationStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => ConversationStatus.active,
      ),
      websocketUrl: json['websocketUrl'] as String,
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mode': mode.name,
      'personaId': personaId,
      'personaName': personaName,
      'startedAt': startedAt.toIso8601String(),
      'endedAt': endedAt?.toIso8601String(),
      'topic': topic,
      'status': status.name,
      'websocketUrl': websocketUrl,
      'token': token,
    };
  }

  Duration get duration {
    final end = endedAt ?? DateTime.now();
    return end.difference(startedAt);
  }
}
