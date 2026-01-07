import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/turn.dart';
import '../../domain/models/suggestion.dart';

class ConversationSummary {
  final String conversationId;
  final int durationSeconds;
  final int pronunciationScore;
  final int xpEarned;
  final bool levelUp;
  final int? newLevel;
  final List<String> newBadges;
  final String summary;
  final List<VocabularyItem> vocabulary;
  final List<Correction> corrections;
  final int turnCount;

  ConversationSummary({
    required this.conversationId,
    required this.durationSeconds,
    required this.pronunciationScore,
    required this.xpEarned,
    this.levelUp = false,
    this.newLevel,
    this.newBadges = const [],
    required this.summary,
    required this.vocabulary,
    required this.corrections,
    required this.turnCount,
  });

  factory ConversationSummary.fromJson(Map<String, dynamic> json) {
    return ConversationSummary(
      conversationId: json['conversationId'] as String,
      durationSeconds: json['durationSeconds'] as int,
      pronunciationScore: json['pronunciationScore'] as int,
      xpEarned: json['xpEarned'] as int,
      levelUp: json['levelUp'] as bool? ?? false,
      newLevel: json['newLevel'] as int?,
      newBadges: (json['newBadges'] as List?)?.cast<String>() ?? [],
      summary: json['summary'] as String,
      vocabulary: (json['vocabulary'] as List?)
              ?.map((v) => VocabularyItem.fromJson(v))
              .toList() ??
          [],
      corrections: (json['corrections'] as List?)
              ?.map((c) => Correction.fromJson(c))
              .toList() ??
          [],
      turnCount: json['turnCount'] as int,
    );
  }
}

final summaryProvider = FutureProvider.family<ConversationSummary, String>(
  (ref, conversationId) async {
    // TODO: Fetch from repository
    // For now, return mock data
    await Future.delayed(const Duration(seconds: 1));
    return ConversationSummary(
      conversationId: conversationId,
      durationSeconds: 512,
      pronunciationScore: 85,
      xpEarned: 120,
      levelUp: false,
      summary: 'Great conversation! You practiced daily life topics.',
      vocabulary: [],
      corrections: [],
      turnCount: 12,
    );
  },
);
