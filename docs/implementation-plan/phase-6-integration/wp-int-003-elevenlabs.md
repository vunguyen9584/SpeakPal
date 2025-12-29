# WP-INT-003: ElevenLabs TTS Integration

## Overview

| Item           | Value                                                |
| -------------- | ---------------------------------------------------- |
| ID             | WP-INT-003                                           |
| Name           | ElevenLabs TTS Integration                           |
| Description    | Text-to-Speech streaming for AI voice responses      |
| Dependencies   | WP-BE-001 (Backend Init)                             |
| Estimated Days | 3                                                    |
| Total Tasks    | 6                                                    |
| DD References  | `05-module-design/conversation-module.md#TTSService` |

---

## Tasks

### Task 1: Create Integration Module

- **ID**: WP-INT-003-T001
- **Type**: setup
- **Description**: Tạo ElevenLabs integration module
- **Files to Create**:
  - `backend/src/integrations/elevenlabs/elevenlabs.module.ts`
  - `backend/src/integrations/elevenlabs/elevenlabs.service.ts`
  - `backend/src/integrations/elevenlabs/interfaces/voice.interface.ts`
- **Acceptance Criteria**:
  - [ ] Module exports ElevenLabsService
  - [ ] API key configuration
- **Estimated Hours**: 1
- **DD Reference**: N/A

---

### Task 2: Configure ElevenLabs Client

- **ID**: WP-INT-003-T002
- **Type**: feature
- **Description**: Setup ElevenLabs SDK với voice configurations
- **Files to Create**:
  - `backend/src/integrations/elevenlabs/elevenlabs.client.ts`
  - `backend/src/integrations/elevenlabs/voice-mapping.config.ts`
- **Voice Mapping**:
  ```typescript
  // Map persona voice types to ElevenLabs voice IDs
  const VOICE_MAPPING = {
    default_female: "EXAVITQu4vr4xnSDxMaL", // Sarah
    default_male: "VR6AewLTigWG4xSOukaG", // Arnold
    friendly_female: "pNInz6obpgDQGcFmaJgB", // Rachel
    professional_male: "yoZ06aMxZJJ28mfd3POQ", // Sam
  };
  ```
- **Acceptance Criteria**:
  - [ ] Voice ID mapping per persona
  - [ ] Multi-language support configured
  - [ ] Output format: MP3 44100Hz
- **Estimated Hours**: 2
- **DD Reference**: `03-system-overview.md#external-services`

---

### Task 3: Implement Streaming TTS

- **ID**: WP-INT-003-T003
- **Type**: feature
- **Description**: Stream audio synthesis từ text
- **Files to Modify**:
  - `backend/src/integrations/elevenlabs/elevenlabs.service.ts`
- **Implementation**:
  ```typescript
  async *streamSynthesize(text: string, voiceType: string): AsyncGenerator<Buffer> {
    const voiceId = this.getVoiceId(voiceType);

    const stream = await this.elevenlabs.textToSpeech.stream(voiceId, {
      text,
      model_id: 'eleven_multilingual_v2',
      output_format: 'mp3_44100_128',
      voice_settings: {
        stability: 0.5,
        similarity_boost: 0.75,
      },
    });

    for await (const chunk of stream) {
      yield Buffer.from(chunk);
    }
  }
  ```
- **Acceptance Criteria**:
  - [ ] Stream audio chunks
  - [ ] MP3 format output
  - [ ] Voice settings configurable
  - [ ] Low latency streaming
- **Estimated Hours**: 5
- **DD Reference**: `05-module-design/conversation-module.md#TTSService`

---

### Task 4: Implement Voice Selection

- **ID**: WP-INT-003-T004
- **Type**: feature
- **Description**: Map persona settings to ElevenLabs voices
- **Files to Create**:
  - `backend/src/integrations/elevenlabs/voice-selector.service.ts`
- **Selection Logic**:
  - Use voice_type from Persona entity
  - Fallback to default voice if not mapped
  - Support speed adjustment (slow/normal/fast)
- **Acceptance Criteria**:
  - [ ] Map persona.voiceType to voice ID
  - [ ] Fallback voice handling
  - [ ] Speed adjustment via stability param
- **Estimated Hours**: 2
- **DD Reference**: N/A

---

### Task 5: Implement Caching

- **ID**: WP-INT-003-T005
- **Type**: feature
- **Description**: Cache common phrases để reduce API calls
- **Files to Create**:
  - `backend/src/integrations/elevenlabs/tts-cache.service.ts`
- **Caching Strategy**:
  - Cache greeting phrases per voice
  - Cache common responses
  - Store in S3 với Redis index
  - TTL: 30 days
- **Acceptance Criteria**:
  - [ ] Cache lookup before API call
  - [ ] S3 storage for audio files
  - [ ] Redis index for fast lookup
  - [ ] Cache invalidation on voice change
- **Estimated Hours**: 3
- **DD Reference**: N/A

---

### Task 6: Add Error Handling & Fallback

- **ID**: WP-INT-003-T006
- **Type**: feature
- **Description**: Handle API errors với fallback options
- **Error Handling**:
  | Error | Fallback |
  | -------------- | ------------------------------- |
  | API down | Return cached audio |
  | Rate limited | Queue và retry |
  | Voice unavailable | Use default voice |
  | Text too long | Split into chunks |
- **Acceptance Criteria**:
  - [ ] Fallback to cached audio
  - [ ] Text chunking for long responses
  - [ ] Retry logic với backoff
  - [ ] Error events to client
- **Estimated Hours**: 2
- **DD Reference**: `11-error-handling.md`

---

## Task Summary

| Task ID         | Name              | Type    | Hours  | Status |
| --------------- | ----------------- | ------- | ------ | ------ |
| WP-INT-003-T001 | Create Module     | setup   | 1      | ⬜     |
| WP-INT-003-T002 | Configure Client  | feature | 2      | ⬜     |
| WP-INT-003-T003 | Streaming TTS     | feature | 5      | ⬜     |
| WP-INT-003-T004 | Voice Selection   | feature | 2      | ⬜     |
| WP-INT-003-T005 | Implement Caching | feature | 3      | ⬜     |
| WP-INT-003-T006 | Error & Fallback  | feature | 2      | ⬜     |
| **Total**       |                   |         | **15** |        |

---

_Back to: [\_phase-6.md](./_phase-6.md)_
