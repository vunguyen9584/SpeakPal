import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/models/conversation_summary.dart';
import 'conversation_providers.dart';

final summaryProvider = FutureProvider.family<ConversationSummary, String>(
  (ref, conversationId) async {
    final repository = ref.watch(conversationRepositoryProvider);
    final result = await repository.getConversationSummary(conversationId);
    
    return result.fold(
      (error) => throw Exception(error.message),
      (data) => data,
    );
  },
);

