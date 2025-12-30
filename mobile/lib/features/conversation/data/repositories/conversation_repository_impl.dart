import 'package:dio/dio.dart';
import '../../domain/models/conversation.dart';
import '../../domain/repositories/conversation_repository.dart';

class ConversationRepositoryImpl implements ConversationRepository {
  final Dio _dio;

  ConversationRepositoryImpl(this._dio);

  @override
  Future<Conversation> createConversation({
    required ConversationMode mode,
    required String personaId,
    String? topic,
  }) async {
    try {
      final response = await _dio.post('/conversations', data: {
        'mode': mode.name,
        'personaId': personaId,
        'topic': topic,
      });
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to create conversation: $e');
    }
  }

  @override
  Future<Conversation> getConversation(String id) async {
    try {
      final response = await _dio.get('/conversations/$id');
      return Conversation.fromJson(response.data);
    } catch (e) {
      throw Exception('Failed to get conversation: $e');
    }
  }

  @override
  Future<void> endConversation(String id) async {
    try {
      await _dio.post('/conversations/$id/end');
    } catch (e) {
      throw Exception('Failed to end conversation: $e');
    }
  }

  @override
  Future<List<dynamic>> getTurns(String id) async {
    try {
      final response = await _dio.get('/conversations/$id/turns');
      return response.data['turns'] as List<dynamic>;
    } catch (e) {
      throw Exception('Failed to get turns: $e');
    }
  }
}
