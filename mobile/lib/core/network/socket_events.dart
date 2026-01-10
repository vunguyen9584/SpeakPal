/// Socket event constants
class SocketEvents {
  SocketEvents._();

  // Connection events
  static const String connect = 'connect';
  static const String disconnect = 'disconnect';
  static const String error = 'error';
  static const String connectError = 'connect_error';
  static const String reconnect = 'reconnect';

  // Conversation events
  static const String joinConversation = 'conversation:join';
  static const String leaveConversation = 'conversation:leave';
  static const String audioStream = 'conversation:audio-stream';
  static const String audioChunk = 'conversation:audio-chunk';
  static const String audioEnd = 'conversation:audio-end';
  static const String transcription = 'conversation:transcription';
  static const String aiResponse = 'conversation:ai-response';
  static const String aiResponseChunk = 'conversation:ai-response-chunk';
  static const String aiResponseEnd = 'conversation:ai-response-end';
  static const String correction = 'conversation:correction';
  static const String turnComplete = 'conversation:turn-complete';

  // Notification events
  static const String notification = 'notification';
  static const String badgeUnlocked = 'badge:unlocked';
  static const String levelUp = 'level:up';
  static const String streakUpdated = 'streak:updated';
}

