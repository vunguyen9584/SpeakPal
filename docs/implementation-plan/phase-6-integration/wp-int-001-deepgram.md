# WP-INT-001: Deepgram STT Integration

## Overview

| Item           | Value                                                                                    |
| -------------- | ---------------------------------------------------------------------------------------- |
| ID             | WP-INT-001                                                                               |
| Name           | Deepgram STT Integration                                                                 |
| Description    | Speech-to-Text streaming API for real-time transcription                                 |
| Dependencies   | WP-BE-001 (Backend Init)                                                                 |
| Estimated Days | 3                                                                                        |
| Total Tasks    | 6                                                                                        |
| DD References  | `03-system-overview.md#external-services`, `05-module-design/conversation-module.md#stt` |

---

## Tasks

### Task 1: Create Integration Module

- **ID**: WP-INT-001-T001
- **Type**: setup
- **Description**: Tạo Deepgram integration module structure
- **Files to Create**:
  - `backend/src/integrations/deepgram/deepgram.module.ts`
  - `backend/src/integrations/deepgram/deepgram.service.ts`
  - `backend/src/integrations/deepgram/interfaces/transcript.interface.ts`
- **Acceptance Criteria**:
  - [x] Module exports DeepgramService
  - [x] ConfigService integration for API key
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Configure Deepgram Client

- **ID**: WP-INT-001-T002
- **Type**: feature
- **Description**: Setup Deepgram SDK client với configuration
- **Files to Create**:
  - `backend/src/integrations/deepgram/deepgram.client.ts`
- **Configuration**:
  ```typescript
  const config = {
    apiKey: process.env.DEEPGRAM_API_KEY,
    language: "en",
    model: "nova-2",
    smart_format: true,
    punctuate: true,
    diarize: false,
    interim_results: true,
    endpointing: 300,
  };
  ```
- **Acceptance Criteria**:
  - [x] API key from environment
  - [x] Nova-2 model configured
  - [x] Interim results enabled
  - [x] Smart formatting enabled
- **Estimated Hours**: 2
- **DD Reference**: `03-system-overview.md#external-services`

---

### Task 3: Implement Streaming STT

- **ID**: WP-INT-001-T003
- **Type**: feature
- **Description**: Implement WebSocket-based streaming transcription
- **Files to Modify**:
  - `backend/src/integrations/deepgram/deepgram.service.ts`
- **Implementation**:

  ```typescript
  async *streamTranscribe(audioStream: AsyncIterable<Buffer>): AsyncGenerator<TranscriptChunk> {
    const connection = await this.deepgram.transcription.live(this.config);

    connection.on('transcriptReceived', (data) => {
      const transcript = data.channel.alternatives[0];
      this.emit('transcript', {
        text: transcript.transcript,
        confidence: transcript.confidence,
        isFinal: data.is_final,
      });
    });

    for await (const chunk of audioStream) {
      connection.send(chunk);
    }

    connection.finish();
  }
  ```

- **Acceptance Criteria**:
  - [x] WebSocket connection to Deepgram
  - [x] Stream audio chunks in real-time
  - [x] Yield transcript results as they arrive
  - [x] Support 16kHz mono PCM input
- **Estimated Hours**: 6
- **DD Reference**: `05-module-design/conversation-module.md#STTService`

---

### Task 4: Implement Result Handler

- **ID**: WP-INT-001-T004
- **Type**: feature
- **Description**: Handle interim và final transcription results
- **Files to Modify**:
  - `backend/src/integrations/deepgram/deepgram.service.ts`
- **Result Types**:
  | Type | Description | Action |
  | ------- | --------------------- | ------------------------- |
  | interim | Partial transcription | Display to user (updating)|
  | final | Complete utterance | Pass to AI processing |
- **Acceptance Criteria**:
  - [x] Parse interim results
  - [x] Parse final results
  - [x] Include confidence scores
  - [x] Include word timestamps (optional)
  - [x] Detect end of utterance
- **Estimated Hours**: 3
- **DD Reference**: `05-module-design/conversation-module.md#processAudioStream()`

---

### Task 5: Add Error Handling

- **ID**: WP-INT-001-T005
- **Type**: feature
- **Description**: Robust error handling với retry và fallback
- **Error Scenarios**:
  | Error | Handling |
  | ------------------ | ------------------------------- |
  | Connection failed | Retry 3 times với backoff |
  | Connection dropped | Reconnect automatically |
  | Invalid audio | Return error event to client |
  | Rate limited | Queue và delay |
- **Acceptance Criteria**:
  - [x] Connection retry với exponential backoff
  - [x] Auto-reconnect on disconnect
  - [x] Proper error events emitted
  - [x] Logging for debugging
- **Estimated Hours**: 2
- **DD Reference**: `11-error-handling.md`

---

### Task 6: Add Integration Tests

- **ID**: WP-INT-001-T006
- **Type**: test
- **Description**: Integration tests cho Deepgram service
- **Files to Create**:
  - `backend/src/integrations/deepgram/tests/deepgram.service.spec.ts`
- **Test Cases**:
  - Connection establishment
  - Audio streaming
  - Result parsing
  - Error handling
- **Acceptance Criteria**:
  - [x] Mock Deepgram WebSocket
  - [x] Test interim/final result handling
  - [x] Test error scenarios
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

## Task Summary

| Task ID         | Name                     | Type    | Hours  | Status |
| --------------- | ------------------------ | ------- | ------ | ------ |
| WP-INT-001-T001 | Create Module            | setup   | 1      | ✅     |
| WP-INT-001-T002 | Configure Client         | feature | 2      | ✅     |
| WP-INT-001-T003 | Implement Streaming STT  | feature | 6      | ✅     |
| WP-INT-001-T004 | Implement Result Handler | feature | 3      | ✅     |
| WP-INT-001-T005 | Add Error Handling       | feature | 2      | ✅     |
| WP-INT-001-T006 | Add Integration Tests    | test    | 2      | ✅     |
| **Total**       |                          |         | **16** |        |

---

_Back to: [\_phase-6.md](./_phase-6.md)_
