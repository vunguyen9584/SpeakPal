import 'package:socket_io_client/socket_io_client.dart' as io;
import '../storage/secure_storage.dart';
import '../../config/env/app_config.dart';
import '../services/logger_service.dart';
import 'socket_events.dart';

/// WebSocket Client using Socket.IO
class SocketClient {
  io.Socket? _socket;
  final SecureStorage _secureStorage = SecureStorage();

  bool get isConnected => _socket?.connected ?? false;

  /// Connect to WebSocket server
  Future<void> connect() async {
    if (_socket?.connected == true) {
      return;
    }

    final accessToken = await _secureStorage.getAccessToken();

    _socket = io.io(
      AppConfig.wsUrl,
      io.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({'token': accessToken})
          .setReconnectionAttempts(5)
          .setReconnectionDelay(1000)
          .build(),
    );

    _setupEventHandlers();
    _socket?.connect();
  }

  /// Disconnect from WebSocket server
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// Setup default event handlers
  void _setupEventHandlers() {
    _socket?.on(SocketEvents.connect, (_) {
      LoggerService.i('Socket connected');
    });

    _socket?.on(SocketEvents.disconnect, (_) {
      LoggerService.i('Socket disconnected');
    });

    _socket?.on(SocketEvents.error, (data) {
      LoggerService.e('Socket error: $data');
    });

    _socket?.on(SocketEvents.connectError, (data) {
      LoggerService.e('Socket connection error: $data');
    });

    _socket?.on(SocketEvents.reconnect, (data) {
      LoggerService.i('Socket reconnected');
    });
  }

  /// Emit event to server
  void emit(String event, [dynamic data]) {
    _socket?.emit(event, data);
  }

  /// Listen to event from server
  void on(String event, Function(dynamic) handler) {
    _socket?.on(event, handler);
  }

  /// Remove event listener
  void off(String event, [Function(dynamic)? handler]) {
    if (handler != null) {
      _socket?.off(event, handler);
    } else {
      _socket?.off(event);
    }
  }

  /// Join conversation room
  void joinConversation(String conversationId) {
    emit(SocketEvents.joinConversation, {'conversationId': conversationId});
  }

  /// Leave conversation room
  void leaveConversation(String conversationId) {
    emit(SocketEvents.leaveConversation, {'conversationId': conversationId});
  }

  /// Send audio chunk
  void sendAudioChunk(List<int> audioData) {
    emit(SocketEvents.audioChunk, audioData);
  }

  /// Signal end of audio stream
  void endAudioStream() {
    emit(SocketEvents.audioEnd);
  }

  /// Listen for transcription updates
  void onTranscription(Function(Map<String, dynamic>) handler) {
    on(SocketEvents.transcription, (data) {
      handler(data as Map<String, dynamic>);
    });
  }

  /// Listen for AI response chunks
  void onAiResponseChunk(Function(Map<String, dynamic>) handler) {
    on(SocketEvents.aiResponseChunk, (data) {
      handler(data as Map<String, dynamic>);
    });
  }

  /// Listen for corrections
  void onCorrection(Function(Map<String, dynamic>) handler) {
    on(SocketEvents.correction, (data) {
      handler(data as Map<String, dynamic>);
    });
  }

  /// Listen for turn complete
  void onTurnComplete(Function(Map<String, dynamic>) handler) {
    on(SocketEvents.turnComplete, (data) {
      handler(data as Map<String, dynamic>);
    });
  }

  /// Listen for notifications
  void onNotification(Function(Map<String, dynamic>) handler) {
    on(SocketEvents.notification, (data) {
      handler(data as Map<String, dynamic>);
    });
  }
}

