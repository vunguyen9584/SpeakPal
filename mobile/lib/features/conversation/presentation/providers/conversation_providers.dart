import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/providers/providers.dart';
import '../../data/repositories/conversation_repository_impl.dart';
import '../../domain/repositories/conversation_repository.dart';

final conversationRepositoryProvider = Provider<ConversationRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return ConversationRepositoryImpl(apiClient);
});
