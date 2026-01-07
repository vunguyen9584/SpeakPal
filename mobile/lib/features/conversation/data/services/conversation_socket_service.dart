import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum SocketEventType {
  connected,
  textResult,
  aiResponseStart,
  aiResponseAudio,
  aiResponseEnd,
  correction,
  suggestion,
  error,
  disconnected,
}

class SocketEvent {
  final SocketEventType type;
  final dynamic data;

  SocketEvent(this.type, this.data);

  factory SocketEvent.connected(dynamic data) => SocketEvent(SocketEventType.connected, data);
  factory SocketEvent.textResult(dynamic data) => SocketEvent(SocketEventType.textResult, data);
  factory SocketEvent.aiResponseStart(dynamic data) => SocketEvent(SocketEventType.aiResponseStart, data);
  factory SocketEvent.aiResponseAudio(dynamic data) => SocketEvent(SocketEventType.aiResponseAudio, data);
  factory SocketEvent.aiResponseEnd(dynamic data) => SocketEvent(SocketEventType.aiResponseEnd, data);
  factory SocketEvent.correction(dynamic data) => SocketEvent(SocketEventType.correction, data);
  factory SocketEvent.suggestion(dynamic data) => SocketEvent(SocketEventType.suggestion, data);
  factory SocketEvent.error(dynamic data) => SocketEvent(SocketEventType.error, data);
  factory SocketEvent.disconnected(dynamic data) => SocketEvent(SocketEventType.disconnected, data);
}

class ConversationSocketService {
  IO.Socket? _socket;
  final StreamController<SocketEvent> _eventController = StreamController<SocketEvent>.broadcast();

  Stream<SocketEvent> get events => _eventController.stream;

  bool get isConnected => _socket?.connected ?? false;

  /// Connect to WebSocket server
  Future<void> connect(String url, String token, String conversationId) async {
    _socket = IO.io(
      url,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .setAuth({
            'token': token,
            'conversationId': conversationId,
          })
          .build(),
    );

    _setupEventHandlers();
    _socket!.connect();
  }

  /// Setup event handlers
  void _setupEventHandlers() {
    _socket?.on('connect', (_) {
      print('WebSocket connected');
      _emit(SocketEvent.connected(null));
    });

    _socket?.on('connected', (data) {
      print('Server confirmed connection: $data');
      _emit(SocketEvent.connected(data));
    });

    _socket?.on('text_result', (data) {
      print('Received text result: $data');
      _emit(SocketEvent.textResult(data));
    });

    _socket?.on('ai_response_start', (data) {
      print('AI response started');
      _emit(SocketEvent.aiResponseStart(data));
    });

    _socket?.on('ai_response_audio', (data) {
      _emit(SocketEvent.aiResponseAudio(data));
    });

    _socket?.on('ai_response_end', (data) {
      print('AI response ended');
      _emit(SocketEvent.aiResponseEnd(data));
    });

    _socket?.on('correction', (data) {
      print('Received correction: $data');
      _emit(SocketEvent.correction(data));
    });

    _socket?.on('suggestion', (data) {
      print('Received suggestion: $data');
      _emit(SocketEvent.suggestion(data));
    });

    _socket?.on('error', (data) {
      print('WebSocket error: $data');
      _emit(SocketEvent.error(data));
    });

    _socket?.on('disconnect', (_) {
      print('WebSocket disconnected');
      _emit(SocketEvent.disconnected(null));
    });

    _socket?.on('connect_error', (error) {
      print('Connection error: $error');
      _emit(SocketEvent.error(error));
    });
  }

  /// Emit event to stream
  void _emit(SocketEvent event) {
    if (!_eventController.isClosed) {
      _eventController.add(event);
    }
  }

  /// Send audio chunk to server
  void sendAudioChunk(Uint8List chunk, int sequence, {bool isFinal = false}) {
    if (!isConnected) {
      print('Cannot send audio: not connected');
      return;
    }

    _socket?.emit('audio_stream', {
      'chunk': base64Encode(chunk),
      'sequence': sequence,
      'sampleRate': 16000,
      'channels': 1,
      'isFinal': isFinal,
    });
  }

  /// Send interrupt signal (when user starts speaking during AI response)
  void sendInterrupt(String reason) {
    if (!isConnected) {
      print('Cannot send interrupt: not connected');
      return;
    }

    _socket?.emit('interrupt', {
      'reason': reason,
      'timestamp': DateTime.now().toIso8601String(),
    });
  }

  /// Disconnect from server
  void disconnect() {
    _socket?.disconnect();
    _socket?.dispose();
    _socket = null;
  }

  /// Dispose resources
  void dispose() {
    disconnect();
    _eventController.close();
  }
}
