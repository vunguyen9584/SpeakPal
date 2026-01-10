import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../models/conversation.dart';

abstract class ConversationRepository {
  /// Create a new conversation session
  Future<Either<AppError, Conversation>> createConversation({
    required ConversationMode mode,
    required String personaId,
    String? topic,
  });

  /// Get conversation details
  Future<Either<AppError, Conversation>> getConversation(String id);

  /// End a conversation
  Future<Either<AppError, void>> endConversation(String id);

  /// Get conversation turns
  Future<Either<AppError, List<dynamic>>> getTurns(String id);
}

