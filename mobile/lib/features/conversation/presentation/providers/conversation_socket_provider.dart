import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/services/conversation_socket_service.dart';

final conversationSocketServiceProvider = Provider<ConversationSocketService>((ref) {
  final service = ConversationSocketService();
  ref.onDispose(() => service.dispose());
  return service;
});

final conversationSocketEventsProvider = StreamProvider.autoDispose.family<SocketEvent, String>(
  (ref, conversationId) {
    final service = ref.watch(conversationSocketServiceProvider);
    return service.events;
  },
);

final socketConnectionStateProvider = StateProvider<bool>((ref) => false);
