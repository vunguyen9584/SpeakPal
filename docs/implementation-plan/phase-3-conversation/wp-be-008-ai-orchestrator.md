# WP-BE-008: AI Orchestrator (Backend)

## Overview

| Item           | Value                                                                                         |
| -------------- | --------------------------------------------------------------------------------------------- |
| ID             | WP-BE-008                                                                                     |
| Name           | AI Orchestrator                                                                               |
| Description    | Coordinate STT → LLM → TTS pipeline for real-time conversation                                |
| Dependencies   | WP-BE-007, WP-INT-001 (Deepgram), WP-INT-002 (OpenAI), WP-INT-003 (ElevenLabs)                |
| Estimated Days | 5                                                                                             |
| Total Tasks    | 7                                                                                             |
| DD References  | `05-module-design/conversation-module.md#AIOrchestrator`, `03-system-overview.md#ai-pipeline` |

---

## Tasks

### Task 1: Create Orchestrator Module

- **ID**: WP-BE-008-T001
- **Type**: setup
- **Description**: Tạo AI Orchestrator module để coordinate các AI services
- **Commands**:
  ```bash
  cd backend
  mkdir -p src/modules/ai-orchestrator
  ```
- **Files to Create**:
  - `backend/src/modules/ai-orchestrator/ai-orchestrator.module.ts` - Module definition
  - `backend/src/modules/ai-orchestrator/ai-orchestrator.service.ts` - Main orchestrator
  - `backend/src/modules/ai-orchestrator/interfaces/ai-response.interface.ts` - Response types
  - `backend/src/modules/ai-orchestrator/interfaces/conversation-context.interface.ts` - Context
- **Implementation Details**:
  ```typescript
  @Module({
    imports: [DeepgramModule, OpenAIModule, ElevenLabsModule, FeedbackModule],
    providers: [AIOrchestrator],
    exports: [AIOrchestrator],
  })
  export class AIOrchestratorModule {}
  ```
- **Acceptance Criteria**:
  - [ ] Module được tạo với dependencies đầy đủ
  - [ ] AIOrchestrator service được inject đúng
  - [ ] Interfaces cho response types được định nghĩa
  - [ ] Export được để ConversationModule sử dụng
- **Estimated Hours**: 1.5
- **DD Reference**: `05-module-design/conversation-module.md#クラス図`

---

### Task 2: Implement Pipeline Coordinator

- **ID**: WP-BE-008-T002
- **Type**: feature
- **Description**: Implement main pipeline coordinator để xử lý audio stream
- **Files to Modify**:
  - `backend/src/modules/ai-orchestrator/ai-orchestrator.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class AIOrchestrator {
    async *processAudioStream(
      audio: Buffer,
      context: ConversationContext
    ): AsyncGenerator<AIResponse> {
      // 1. STT: Audio → Text (streaming)
      for await (const transcript of this.sttService.streamTranscribe(audio)) {
        yield { type: "text_result", data: transcript };

        if (transcript.isFinal) {
          // 2. Parallel LLM calls
          const [responsePromise, errorsPromise, suggestionsPromise] = [
            this.generateResponse(transcript.text, context),
            this.analyzeErrors(transcript.text, context),
            this.generateSuggestions(transcript.text, context),
          ];

          // 3. TTS: Text → Audio (streaming)
          const responseText = await responsePromise;
          yield { type: "ai_response_start" };

          for await (const chunk of this.ttsService.streamSynthesize(
            responseText
          )) {
            yield { type: "ai_response_audio", data: chunk };
          }
          yield { type: "ai_response_end", data: { text: responseText } };

          // 4. Return corrections & suggestions
          const errors = await errorsPromise;
          if (errors.length > 0) {
            yield { type: "correction", data: errors };
          }

          const suggestions = await suggestionsPromise;
          yield { type: "suggestion", data: suggestions };
        }
      }
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] processAudioStream() returns AsyncGenerator
  - [ ] STT results được yield ngay khi có (interim + final)
  - [ ] LLM calls được thực hiện parallel sau khi có final text
  - [ ] TTS audio được stream từng chunk
  - [ ] Corrections và suggestions được yield sau TTS
- **Estimated Hours**: 4
- **DD Reference**: `05-module-design/conversation-module.md#processAudioStream()`

---

### Task 3: Integrate STT (Deepgram)

- **ID**: WP-BE-008-T003
- **Type**: integration
- **Description**: Integrate Deepgram STT service cho speech-to-text streaming
- **Files to Create**:
  - `backend/src/modules/ai-orchestrator/stt.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class STTService {
    constructor(private deepgramClient: DeepgramClient) {}

    async *streamTranscribe(audio: Buffer): AsyncGenerator<TranscriptChunk> {
      const connection = this.deepgramClient.transcription.prerecorded({
        language: "en",
        model: "nova-2",
        smart_format: true,
        punctuate: true,
      });

      // Stream audio và yield results
    }

    async detectLanguage(audio: Buffer): Promise<string> {
      // Detect language từ first few seconds
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] streamTranscribe() stream text results real-time
  - [ ] Support interim (partial) và final results
  - [ ] Confidence score được trả về
  - [ ] Language detection hoạt động
  - [ ] Handle connection errors gracefully
- **Estimated Hours**: 3
- **DD Reference**: `03-system-overview.md#external-services`

---

### Task 4: Integrate LLM (GPT-4o)

- **ID**: WP-BE-008-T004
- **Type**: integration
- **Description**: Integrate OpenAI GPT-4o cho conversation generation và error analysis
- **Files to Create**:
  - `backend/src/modules/ai-orchestrator/llm.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class LLMService {
    constructor(private openai: OpenAI) {}

    async generateResponse(
      text: string,
      context: ConversationContext
    ): Promise<string> {
      const completion = await this.openai.chat.completions.create({
        model: "gpt-4o",
        messages: this.buildConversationPrompt(text, context),
        max_tokens: 150,
        temperature: 0.7,
      });
      return completion.choices[0].message.content;
    }

    async analyzeErrors(text: string, level: UserLevel): Promise<Correction[]> {
      // Error analysis prompt
    }

    async generateSuggestions(
      context: ConversationContext
    ): Promise<Suggestion> {
      // Suggestion generation prompt
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] generateResponse() với persona-aware prompt
  - [ ] analyzeErrors() trả về corrections với type, original, corrected, explanation
  - [ ] generateSuggestions() trả về template và vocabulary
  - [ ] Prompt templates theo DD (conversation, error analysis)
  - [ ] Rate limiting và retry logic
- **Estimated Hours**: 4
- **DD Reference**: `05-module-design/conversation-module.md#LLMServiceプロンプト設計`

---

### Task 5: Integrate TTS (ElevenLabs)

- **ID**: WP-BE-008-T005
- **Type**: integration
- **Description**: Integrate ElevenLabs TTS cho text-to-speech streaming
- **Files to Create**:
  - `backend/src/modules/ai-orchestrator/tts.service.ts`
- **Implementation Details**:
  ```typescript
  @Injectable()
  export class TTSService {
    constructor(private elevenlabs: ElevenLabsClient) {}

    async *streamSynthesize(
      text: string,
      voice: VoiceType
    ): AsyncGenerator<Buffer> {
      const stream = await this.elevenlabs.textToSpeech.stream({
        voice_id: this.getVoiceId(voice),
        text,
        model_id: "eleven_multilingual_v2",
        output_format: "mp3_44100_128",
      });

      for await (const chunk of stream) {
        yield chunk;
      }
    }

    async getVoices(): Promise<Voice[]> {
      return this.elevenlabs.voices.getAll();
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] streamSynthesize() stream audio chunks
  - [ ] Support multiple voice types (male, female, different personas)
  - [ ] Audio format: MP3, 44100Hz, 128kbps
  - [ ] Voice mapping theo persona
  - [ ] Handle API errors gracefully
- **Estimated Hours**: 3
- **DD Reference**: `03-system-overview.md#external-services`

---

### Task 6: Implement Streaming Handler

- **ID**: WP-BE-008-T006
- **Type**: feature
- **Description**: Implement handler để manage streaming state và backpressure
- **Files to Create**:
  - `backend/src/modules/ai-orchestrator/streaming-handler.ts`
- **Implementation Details**:
  ```typescript
  export class StreamingHandler {
    private activeStreams: Map<string, StreamState> = new Map();
    private abortControllers: Map<string, AbortController> = new Map();

    async startStream(sessionId: string): Promise<void>;
    async stopStream(sessionId: string): Promise<void>;
    isStreaming(sessionId: string): boolean;

    // Backpressure management
    async waitForDrain(sessionId: string): Promise<void>;
    setHighWaterMark(sessionId: string, mark: number): void;
  }
  ```
- **Acceptance Criteria**:
  - [ ] Track active streams per session
  - [ ] Support graceful stream cancellation
  - [ ] Backpressure handling để tránh memory issues
  - [ ] Cleanup khi session ends
  - [ ] Concurrent stream limit per user
- **Estimated Hours**: 2.5
- **DD Reference**: `05-module-design/conversation-module.md#stopProcessing()`

---

### Task 7: Add Error Handling & Fallbacks

- **ID**: WP-BE-008-T007
- **Type**: feature
- **Description**: Implement comprehensive error handling và fallback strategies
- **Files to Modify**:
  - `backend/src/modules/ai-orchestrator/ai-orchestrator.service.ts`
- **Files to Create**:
  - `backend/src/modules/ai-orchestrator/fallback-handler.ts`
- **Implementation Details**:
  | Error Type | Fallback Strategy |
  | ------------------ | ---------------------------------------------- |
  | STT Unavailable | Return error, suggest retry |
  | LLM Unavailable | Use cached responses / simple fallback |
  | LLM Timeout | Retry once với shorter prompt |
  | TTS Unavailable | Return text-only response |
  | Connection Lost | Queue messages, resume when reconnected |
- **Acceptance Criteria**:
  - [ ] Circuit breaker cho mỗi external service
  - [ ] Retry logic với exponential backoff
  - [ ] Fallback responses khi LLM fails
  - [ ] Text-only mode khi TTS fails
  - [ ] Proper error events cho client (recoverable, action)
  - [ ] Response time target: < 500ms cho stopProcessing
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/conversation-module.md#stopProcessing()`, `11-error-handling.md`

---

## Task Summary

| Task ID        | Name                        | Type        | Hours  | Status |
| -------------- | --------------------------- | ----------- | ------ | ------ |
| WP-BE-008-T001 | Create Orchestrator Module  | setup       | 1.5    | ⬜     |
| WP-BE-008-T002 | Implement Pipeline Coord    | feature     | 4      | ⬜     |
| WP-BE-008-T003 | Integrate STT (Deepgram)    | integration | 3      | ⬜     |
| WP-BE-008-T004 | Integrate LLM (GPT-4o)      | integration | 4      | ⬜     |
| WP-BE-008-T005 | Integrate TTS (ElevenLabs)  | integration | 3      | ⬜     |
| WP-BE-008-T006 | Implement Streaming Handler | feature     | 2.5    | ⬜     |
| WP-BE-008-T007 | Add Error Handling          | feature     | 3      | ⬜     |
| **Total**      |                             |             | **21** |        |

---

_Back to: [\_phase-3.md](./_phase-3.md)_
