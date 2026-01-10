import '../models/conversation.dart';

abstract class ConversationRepository {
  /// Create a new conversation session
  Future<Conversation> createConversation({
    required ConversationMode mode,
    required String personaId,
    String? topic,
  });

  /// Get conversation details
  Future<Conversation> getConversation(String id);

  /// End a conversation
  Future<void> endConversation(String id);

  /// Get conversation turns
  Future<List<dynamic>> getTurns(String id);
}

