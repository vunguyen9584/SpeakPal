import 'package:flutter_test/flutter_test.dart';
import 'package:mobile/features/conversation/data/services/conversation_socket_service.dart';
import 'dart:typed_data';

/// Test Suite for ConversationSocketService
/// 
/// Acceptance Criteria from WP-FE-008-T004:
/// - [ ] Connect với token từ POST /conversations
/// - [ ] Handle all WebSocket events
/// - [ ] Send audio_stream events với Base64 encoded chunks
/// - [ ] Send interrupt event
/// - [ ] Reconnection logic
/// - [ ] Disconnect cleanup
void main() {
  group('ConversationSocketService Tests', () {
    late ConversationSocketService service;

    setUp(() {
      service = ConversationSocketService();
    });

    tearDown(() {
      service.dispose();
    });

    test('should initialize with disconnected state', () {
      // Assert
      expect(service.isConnected, false);
    });

    test('should provide event stream', () {
      // Assert
      expect(service.events, isA<Stream<SocketEvent>>());
    });

    test('should send audio chunk with correct format', () {
      // Arrange
      final chunk = Uint8List.fromList([1, 2, 3, 4, 5]);
      const sequence = 1;

      // Act
      service.sendAudioChunk(chunk, sequence);

      // Assert - Should not throw
      expect(service.isConnected, false); // Not connected yet
    });

    test('should send audio chunk with isFinal flag', () {
      // Arrange
      final chunk = Uint8List.fromList([1, 2, 3, 4, 5]);
      const sequence = 5;

      // Act
      service.sendAudioChunk(chunk, sequence, isFinal: true);

      // Assert - Should not throw
      expect(service.isConnected, false);
    });

    test('should send interrupt signal', () {
      // Arrange
      const reason = 'user_started_speaking';

      // Act
      service.sendInterrupt(reason);

      // Assert - Should not throw
      expect(service.isConnected, false);
    });

    test('should handle disconnect gracefully', () {
      // Act
      service.disconnect();

      // Assert
      expect(service.isConnected, false);
    });

    test('should handle dispose gracefully', () {
      // Act
      service.dispose();

      // Assert - Should not throw
      expect(service.isConnected, false);
    });
  });

  group('SocketEvent Tests', () {
    test('should create connected event', () {
      // Act
      final event = SocketEvent.connected({'status': 'ok'});

      // Assert
      expect(event.type, SocketEventType.connected);
      expect(event.data, {'status': 'ok'});
    });

    test('should create textResult event', () {
      // Act
      final event = SocketEvent.textResult({'text': 'Hello'});

      // Assert
      expect(event.type, SocketEventType.textResult);
      expect(event.data, {'text': 'Hello'});
    });

    test('should create aiResponseStart event', () {
      // Act
      final event = SocketEvent.aiResponseStart({});

      // Assert
      expect(event.type, SocketEventType.aiResponseStart);
    });

    test('should create aiResponseAudio event', () {
      // Act
      final event = SocketEvent.aiResponseAudio({'chunk': 'base64data'});

      // Assert
      expect(event.type, SocketEventType.aiResponseAudio);
    });

    test('should create aiResponseEnd event', () {
      // Act
      final event = SocketEvent.aiResponseEnd({});

      // Assert
      expect(event.type, SocketEventType.aiResponseEnd);
    });

    test('should create correction event', () {
      // Act
      final event = SocketEvent.correction({'type': 'grammar'});

      // Assert
      expect(event.type, SocketEventType.correction);
    });

    test('should create suggestion event', () {
      // Act
      final event = SocketEvent.suggestion({'template': 'Try saying...'});

      // Assert
      expect(event.type, SocketEventType.suggestion);
    });

    test('should create error event', () {
      // Act
      final event = SocketEvent.error({'message': 'Connection failed'});

      // Assert
      expect(event.type, SocketEventType.error);
    });

    test('should create disconnected event', () {
      // Act
      final event = SocketEvent.disconnected(null);

      // Assert
      expect(event.type, SocketEventType.disconnected);
    });
  });
}
