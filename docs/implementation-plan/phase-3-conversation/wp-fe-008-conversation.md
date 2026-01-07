# WP-FE-008: Conversation Screen (Frontend)

## Overview

| Item           | Value                                                                              |
| -------------- | ---------------------------------------------------------------------------------- |
| ID             | WP-FE-008                                                                          |
| Name           | Conversation Screen                                                                |
| Description    | Real-time conversation UI with voice input, AI response, corrections               |
| Dependencies   | WP-FE-007 (Home), WP-BE-009 (WebSocket)                                            |
| Estimated Days | 5                                                                                  |
| Total Tasks    | 8                                                                                  |
| DD References  | `09-ui-specifications/conversation-screens.md`, `06-component-design.md#uc009-016` |

---

## Tasks

### Task 1: Create Conversation Feature Structure

- **ID**: WP-FE-008-T001
- **Type**: setup
- **Description**: Tạo feature structure cho Conversation với state management
- **Commands**:
  ```bash
  cd mobile
  mkdir -p lib/features/conversation/{data,domain,presentation}/{models,repositories,providers,screens,widgets}
  ```
- **Files to Create**:
  - `lib/features/conversation/conversation_feature.dart` - Barrel file
  - `lib/features/conversation/domain/models/conversation.dart`
  - `lib/features/conversation/domain/models/turn.dart`
  - `lib/features/conversation/domain/models/correction.dart`
  - `lib/features/conversation/domain/models/suggestion.dart`
  - `lib/features/conversation/domain/repositories/conversation_repository.dart`
  - `lib/features/conversation/data/repositories/conversation_repository_impl.dart`
- **Implementation Details**:

  ```dart
  // conversation.dart
  class Conversation {
    final String id;
    final ConversationMode mode;
    final Persona persona;
    final DateTime startedAt;
    final String websocketUrl;
    final String token;
  }

  // turn.dart
  class Turn {
    final String id;
    final TurnSpeaker speaker; // user | ai
    final String content;
    final int sequence;
    final DateTime createdAt;
    final List<Correction>? corrections;
  }
  ```

- **Acceptance Criteria**:
  - [ ] Feature folder structure đầy đủ
  - [ ] Conversation model với all fields
  - [ ] Turn model với speaker, content, corrections
  - [ ] Correction model với type, original, corrected, explanation
  - [ ] Suggestion model với template, vocabulary, alternatives
  - [ ] Repository interface defined
- **Estimated Hours**: 1.5
- **DD Reference**: `08-api-design/conversation-apis.md`

---

### Task 2: Implement Mode/Topic Selection

- **ID**: WP-FE-008-T002
- **Type**: feature
- **Description**: Implement conversation setup screen với mode và topic selection
- **Files to Create**:
  - `lib/features/conversation/presentation/screens/conversation_setup_screen.dart`
  - `lib/features/conversation/presentation/widgets/mode_selector.dart`
  - `lib/features/conversation/presentation/widgets/topic_selector.dart`
  - `lib/features/conversation/presentation/widgets/persona_selector.dart`
- **Wireframe Reference**:
  ```
  ┌────────────────────────────────────────┐
  │ [←]        Start Conversation          │
  │                                        │
  │ Select Mode                            │
  │ ┌────────────────────────────────────┐ │
  │ │ ○ Free Talk - Practice freely      │ │
  │ │ ● Instructor - With guidance       │ │
  │ │ ○ Roleplay - Real scenarios        │ │
  │ └────────────────────────────────────┘ │
  │                                        │
  │ Select Topic (Optional)                │
  │ ┌────────────────────────────────────┐ │
  │ │ Daily Life | Travel | Business     │ │
  │ │ Technology | Sports | Culture      │ │
  │ └────────────────────────────────────┘ │
  │                                        │
  │ AI Partner                             │
  │ ┌────────────────────────────────────┐ │
  │ │ 😊 Sarah - Friendly, Patient      │ │
  │ │ [Change Partner]                   │ │
  │ └────────────────────────────────────┘ │
  │                                        │
  │ ┌────────────────────────────────────┐ │
  │ │        [ Start Conversation ]       │ │
  │ └────────────────────────────────────┘ │
  └────────────────────────────────────────┘
  ```
- **Acceptance Criteria**:
  - [ ] Mode selection (Free Talk, Instructor, Roleplay)
  - [ ] Topic chips (optional) với categories
  - [ ] Persona selection với avatar, name, description
  - [ ] Start button calls POST /conversations
  - [ ] Navigate to conversation screen after success
  - [ ] Error handling cho usage limit reached
- **Estimated Hours**: 2.5
- **DD Reference**: `09-ui-specifications/conversation-screens.md`

---

### Task 3: Implement Audio Recording

- **ID**: WP-FE-008-T003
- **Type**: feature
- **Description**: Implement audio recording với platform-specific implementation
- **Files to Create**:
  - `lib/features/conversation/data/services/audio_recorder_service.dart`
  - `lib/features/conversation/presentation/widgets/mic_button.dart`
  - `lib/features/conversation/presentation/widgets/waveform_widget.dart`
- **Dependencies**:
  ```yaml
  # pubspec.yaml
  dependencies:
    record: ^5.0.0
    permission_handler: ^11.0.0
  ```
- **Implementation Details**:

  ```dart
  class AudioRecorderService {
    final Record _recorder = Record();
    StreamSubscription? _amplitudeSubscription;

    Future<void> startRecording() async {
      if (await _recorder.hasPermission()) {
        await _recorder.start(
          encoder: AudioEncoder.pcm16bits,
          samplingRate: 16000,
          numChannels: 1,
        );
        _amplitudeSubscription = _recorder.onAmplitudeChanged(
          Duration(milliseconds: 100),
        ).listen((amp) => _onAmplitudeChange(amp));
      }
    }

    Stream<Uint8List> getAudioStream() {
      return _recorder.onStateChanged()...; // Stream audio chunks
    }

    Future<void> stopRecording() async {
      await _recorder.stop();
      _amplitudeSubscription?.cancel();
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Request microphone permission
  - [ ] Start recording on mic button press
  - [ ] Stop recording on release
  - [ ] Stream audio chunks (16kHz, mono, PCM)
  - [ ] Waveform visualization during recording
  - [ ] Recording timer display
  - [ ] Handle permission denied gracefully
- **Estimated Hours**: 3
- **DD Reference**: `09-ui-specifications/conversation-screens.md#SCR-007`

---

### Task 4: Implement WebSocket Connection

- **ID**: WP-FE-008-T004
- **Type**: feature
- **Description**: Implement WebSocket client cho real-time communication
- **Files to Create**:
  - `lib/features/conversation/data/services/conversation_socket_service.dart`
  - `lib/features/conversation/presentation/providers/conversation_socket_provider.dart`
- **Dependencies**:
  ```yaml
  dependencies:
    socket_io_client: ^2.0.0
  ```
- **Implementation Details**:

  ```dart
  class ConversationSocketService {
    late Socket _socket;
    final StreamController<SocketEvent> _eventController = StreamController.broadcast();

    Stream<SocketEvent> get events => _eventController.stream;

    Future<void> connect(String url, String token, String conversationId) async {
      _socket = io(url, <String, dynamic>{
        'auth': {'token': token, 'conversationId': conversationId},
        'transports': ['websocket'],
      });

      _socket.on('connected', (data) => _emit(SocketEvent.connected(data)));
      _socket.on('text_result', (data) => _emit(SocketEvent.textResult(data)));
      _socket.on('ai_response_start', (data) => _emit(SocketEvent.aiResponseStart(data)));
      _socket.on('ai_response_audio', (data) => _emit(SocketEvent.aiResponseAudio(data)));
      _socket.on('ai_response_end', (data) => _emit(SocketEvent.aiResponseEnd(data)));
      _socket.on('correction', (data) => _emit(SocketEvent.correction(data)));
      _socket.on('suggestion', (data) => _emit(SocketEvent.suggestion(data)));
      _socket.on('error', (data) => _emit(SocketEvent.error(data)));
    }

    void sendAudioChunk(Uint8List chunk, int sequence, bool isFinal) {
      _socket.emit('audio_stream', {
        'chunk': base64Encode(chunk),
        'sequence': sequence,
        'sampleRate': 16000,
        'channels': 1,
        'isFinal': isFinal,
      });
    }

    void sendInterrupt(String reason) {
      _socket.emit('interrupt', {'reason': reason});
    }

    void disconnect() {
      _socket.disconnect();
      _eventController.close();
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Connect với token từ POST /conversations
  - [ ] Handle all WebSocket events (connected, text*result, ai_response*\*, correction, suggestion, error)
  - [ ] Send audio_stream events với Base64 encoded chunks
  - [ ] Send interrupt event khi user starts speaking during AI response
  - [ ] Reconnection logic với exponential backoff
  - [ ] Disconnect cleanup
- **Estimated Hours**: 3
- **DD Reference**: `08-api-design/websocket-apis.md`

---

### Task 5: Implement Chat UI

- **ID**: WP-FE-008-T005
- **Type**: feature
- **Description**: Implement chat UI với message bubbles và typing indicator
- **Files to Create**:
  - `lib/features/conversation/presentation/screens/conversation_screen.dart`
  - `lib/features/conversation/presentation/widgets/chat_bubble.dart`
  - `lib/features/conversation/presentation/widgets/typing_indicator.dart`
  - `lib/features/conversation/presentation/widgets/ai_avatar.dart`
  - `lib/features/conversation/presentation/widgets/subtitle_box.dart`
- **Wireframe Reference**:
  ```
  ┌────────────────────────────────────────┐
  │ [✕ End]                    [⚙ Settings]│
  │                                        │
  │  ┌────────────────────────────────┐    │
  │  │     AI Persona Avatar          │    │
  │  │         😊 "Sarah"             │    │
  │  │  ┌─────────────────────────┐   │    │
  │  │  │ 💬 "Hi! How are you     │   │    │
  │  │  │     doing today?"       │   │    │
  │  │  └─────────────────────────┘   │    │
  │  └────────────────────────────────┘    │
  │                                        │
  │  ╔════════════════════════════════╗    │
  │  ║  📝 Real-time Subtitles        ║    │
  │  ║  "I'm doing great, thanks..."  ║    │
  │  ╚════════════════════════════════╝    │
  └────────────────────────────────────────┘
  ```
- **Implementation Details**:

  ```dart
  class ChatBubble extends StatelessWidget {
    final Turn turn;
    final bool isAI;

    @override
    Widget build(BuildContext context) {
      return Align(
        alignment: isAI ? Alignment.centerLeft : Alignment.centerRight,
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isAI ? Colors.grey[200] : AppColors.primary,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(turn.content),
              if (turn.corrections != null && turn.corrections!.isNotEmpty)
                CorrectionIndicator(count: turn.corrections!.length),
            ],
          ),
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] AI messages aligned left với avatar
  - [ ] User messages aligned right
  - [ ] Real-time subtitle box (updating as STT streams)
  - [ ] Typing indicator khi AI đang respond
  - [ ] Smooth scroll to bottom on new messages
  - [ ] Correction indicator on messages with errors
  - [ ] Tap message để xem corrections
- **Estimated Hours**: 3.5
- **DD Reference**: `09-ui-specifications/conversation-screens.md#SCR-007`

---

### Task 6: Implement Audio Playback

- **ID**: WP-FE-008-T006
- **Type**: feature
- **Description**: Implement audio playback cho AI responses (streaming)
- **Files to Create**:
  - `lib/features/conversation/data/services/audio_player_service.dart`
  - `lib/features/conversation/presentation/widgets/audio_wave_animation.dart`
- **Dependencies**:
  ```yaml
  dependencies:
    just_audio: ^0.9.36
  ```
- **Implementation Details**:

  ```dart
  class AudioPlayerService {
    final AudioPlayer _player = AudioPlayer();
    final _audioQueue = Queue<Uint8List>();

    Future<void> playStream(Stream<Uint8List> audioStream) async {
      await for (final chunk in audioStream) {
        _audioQueue.add(chunk);
        if (!_player.playing) {
          await _playNextChunk();
        }
      }
    }

    Future<void> _playNextChunk() async {
      if (_audioQueue.isEmpty) return;
      final chunk = _audioQueue.removeFirst();
      await _player.setAudioSource(
        BufferAudioSource(chunk),
      );
      await _player.play();
      if (_audioQueue.isNotEmpty) {
        _playNextChunk();
      }
    }

    void stop() {
      _player.stop();
      _audioQueue.clear();
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Play streaming audio chunks smoothly
  - [ ] Queue chunks để avoid gaps
  - [ ] Stop playback on user interrupt
  - [ ] Volume control
  - [ ] Audio wave animation during playback
  - [ ] Playback state indicator (playing/paused/stopped)
- **Estimated Hours**: 2.5
- **DD Reference**: `08-api-design/websocket-apis.md#ai_response`

---

### Task 7: Implement Real-time Corrections Display

- **ID**: WP-FE-008-T007
- **Type**: feature
- **Description**: Display corrections và suggestions in real-time
- **Files to Create**:
  - `lib/features/conversation/presentation/widgets/correction_card.dart`
  - `lib/features/conversation/presentation/widgets/suggestion_card.dart`
  - `lib/features/conversation/presentation/widgets/correction_detail_modal.dart`
- **Implementation Details**:

  ```dart
  class CorrectionCard extends StatelessWidget {
    final Correction correction;

    @override
    Widget build(BuildContext context) {
      return Card(
        color: _getSeverityColor(correction.severity),
        child: ListTile(
          leading: Icon(Icons.edit),
          title: RichText(
            text: TextSpan(children: [
              TextSpan(
                text: correction.original,
                style: TextStyle(decoration: TextDecoration.lineThrough),
              ),
              TextSpan(text: ' → '),
              TextSpan(
                text: correction.corrected,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ]),
          ),
          subtitle: Text(correction.explanation),
          onTap: () => _showDetailModal(context, correction),
        ),
      );
    }
  }
  ```

- **Acceptance Criteria**:
  - [ ] Correction cards với original → corrected format
  - [ ] Color coded by severity (high=red, medium=yellow, low=blue)
  - [ ] Tap để expand và show full explanation
  - [ ] Japanese explanation available
  - [ ] Suggestion cards với template và vocabulary
  - [ ] Collapsible cards để save space
  - [ ] Animate in khi new correction arrives
- **Estimated Hours**: 2.5
- **DD Reference**: `09-ui-specifications/conversation-screens.md#コンポーネント仕様`

---

### Task 8: Implement Session Controls

- **ID**: WP-FE-008-T008
- **Type**: feature
- **Description**: Implement session controls (end, settings)
- **Files to Create**:
  - `lib/features/conversation/presentation/widgets/session_controls.dart`
  - `lib/features/conversation/presentation/widgets/end_conversation_dialog.dart`
  - `lib/features/conversation/presentation/widgets/conversation_settings_sheet.dart`
- **Implementation Details**:
  ```dart
  class SessionControls extends StatelessWidget {
    @override
    Widget build(BuildContext context) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => _showEndDialog(context),
          ),
          ElapsedTimer(startTime: conversation.startedAt),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () => _showSettingsSheet(context),
          ),
        ],
      );
    }
  }
  ```
- **End Conversation Flow**:
  1. Tap End button
  2. Show confirmation dialog
  3. Call POST /conversations/:id/end
  4. Navigate to Summary screen
- **Settings Options**:
  - AI speaking speed (slow/normal/fast)
  - Show/hide corrections in real-time
  - Microphone sensitivity
- **Acceptance Criteria**:
  - [ ] End button với confirmation dialog
  - [ ] Elapsed time display (mm:ss)
  - [ ] Settings bottom sheet
  - [ ] AI speed adjustment (persisted per user)
  - [ ] Toggle real-time corrections
  - [ ] Navigate to summary after end
- **Estimated Hours**: 2
- **DD Reference**: `09-ui-specifications/conversation-screens.md#イベント`

---

## Task Summary

| Task ID        | Name                           | Type    | Hours    | Status           |
| -------------- | ------------------------------ | ------- | -------- | ---------------- |
| WP-FE-008-T001 | Create Feature Structure       | setup   | 1.5      | ✅ (2026-01-07)  |
| WP-FE-008-T002 | Implement Mode/Topic Selection | feature | 2.5      | ✅ (2026-01-07)  |
| WP-FE-008-T003 | Implement Audio Recording      | feature | 3        | ✅ (2026-01-07)  |
| WP-FE-008-T004 | Implement WebSocket Connection | feature | 3        | ✅ (2026-01-07)  |
| WP-FE-008-T005 | Implement Chat UI              | feature | 3.5      | ✅ (2026-01-07)  |
| WP-FE-008-T006 | Implement Audio Playback       | feature | 2.5      | ✅ (2026-01-07)  |
| WP-FE-008-T007 | Implement Corrections Display  | feature | 2.5      | ✅ (2026-01-07)  |
| WP-FE-008-T008 | Implement Session Controls     | feature | 2        | ✅ (2026-01-07)  |
| **Total**      |                                |         | **20.5** | **✅ COMPLETED** |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
