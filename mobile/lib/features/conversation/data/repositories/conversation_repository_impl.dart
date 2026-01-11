import 'package:fpdart/fpdart.dart';
import '../../../../core/error/app_error.dart';
import '../../../../core/error/error_handler.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../../domain/models/conversation.dart';
import '../../domain/models/conversation_summary.dart';
import '../../domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final ApiClient _apiClient;

  ConversationRepositoryImpl(this._apiClient);

  @override
  Future<Either<AppError, Conversation>> createConversation({
    required ConversationMode mode,
    required String personaId,
    String? topic,
  }) async {
    try {
      final response = await _apiClient.post(ApiEndpoints.conversations, data: {
        'mode': mode.name,
        'personaId': personaId,
        'topic': topic,
      });
      return Right(Conversation.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, Conversation>> getConversation(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.conversationById(id));
      return Right(Conversation.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, void>> endConversation(String id) async {
    try {
      await _apiClient.post('${ApiEndpoints.conversationById(id)}/end');
      return const Right(null);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, List<dynamic>>> getTurns(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.conversationTurns(id));
      return Right(response.data['turns'] as List<dynamic>);
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }

  @override
  Future<Either<AppError, ConversationSummary>> getConversationSummary(String id) async {
    try {
      final response = await _apiClient.get(ApiEndpoints.conversationSummary(id));
      return Right(ConversationSummary.fromJson(response.data));
    } catch (e, stackTrace) {
      return Left(ErrorHandler.handle(e, stackTrace));
    }
  }
}

