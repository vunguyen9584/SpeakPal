# Phase 6: External Integration

## Overview

| Item          | Value                        |
| ------------- | ---------------------------- |
| Phase         | 6                            |
| Description   | External Service Integration |
| Work Packages | 5                            |
| Total Tasks   | 30                           |
| Est. Days     | 13                           |
| Dependencies  | Phase 1 (Backend Init)       |

---

## Work Packages

| ID         | Name                       | Tasks | Est. Hours | File                                                   |
| ---------- | -------------------------- | ----- | ---------- | ------------------------------------------------------ |
| WP-INT-001 | Deepgram STT Integration   | 6     | 24         | [wp-int-001-deepgram.md](./wp-int-001-deepgram.md)     |
| WP-INT-002 | OpenAI GPT-4o Integration  | 6     | 24         | [wp-int-002-openai.md](./wp-int-002-openai.md)         |
| WP-INT-003 | ElevenLabs TTS Integration | 6     | 24         | [wp-int-003-elevenlabs.md](./wp-int-003-elevenlabs.md) |
| WP-INT-004 | App Store IAP Integration  | 6     | 16         | [wp-int-004-appstore.md](./wp-int-004-appstore.md)     |
| WP-INT-005 | Play Store IAP Integration | 6     | 16         | [wp-int-005-playstore.md](./wp-int-005-playstore.md)   |

---

## WP-INT-001: Deepgram STT Integration

### Overview

- **Description**: Speech-to-Text streaming API
- **Dependencies**: WP-BE-001
- **Estimated Days**: 3
- **DD References**: `03-system-overview.md#external-services`, `05-module-design/conversation-module.md#stt`

### Tasks

1. **WP-INT-001-T001**: Create Integration Module

   - Files: `backend/src/integrations/deepgram/deepgram.module.ts`
   - Hours: 1

2. **WP-INT-001-T002**: Configure Deepgram Client

   - Files: `backend/src/integrations/deepgram/deepgram.client.ts`
   - Config: API key, language, model settings
   - Hours: 2

3. **WP-INT-001-T003**: Implement Streaming STT

   - Features: WebSocket connection, audio chunk processing
   - Hours: 6

4. **WP-INT-001-T004**: Implement Result Handler

   - Features: Interim/final results, confidence scores
   - Hours: 3

5. **WP-INT-001-T005**: Add Error Handling

   - Features: Connection retry, fallback to batch mode
   - Hours: 2

6. **WP-INT-001-T006**: Add Integration Tests
   - Hours: 2

---

## WP-INT-002: OpenAI GPT-4o Integration

### Overview

- **Description**: Conversation AI, error analysis
- **Dependencies**: WP-BE-001
- **Estimated Days**: 3
- **DD References**: `03-system-overview.md#external-services`, `05-module-design/conversation-module.md#llm`

### Tasks

1. **WP-INT-002-T001**: Create Integration Module

   - Files: `backend/src/integrations/openai/openai.module.ts`
   - Hours: 1

2. **WP-INT-002-T002**: Configure OpenAI Client

   - Files: `backend/src/integrations/openai/openai.client.ts`
   - Hours: 2

3. **WP-INT-002-T003**: Implement Conversation Generation

   - Features: System prompts per persona, context management
   - Hours: 6

4. **WP-INT-002-T004**: Implement Error Analysis

   - Features: Grammar/vocabulary error detection prompts
   - Hours: 4

5. **WP-INT-002-T005**: Implement Streaming Response

   - Features: Stream tokens, handle interruption
   - Hours: 3

6. **WP-INT-002-T006**: Add Rate Limiting & Error Handling
   - Features: Token counting, retry logic
   - Hours: 2

---

## WP-INT-003: ElevenLabs TTS Integration

### Overview

- **Description**: Text-to-Speech streaming API
- **Dependencies**: WP-BE-001
- **Estimated Days**: 3
- **DD References**: `03-system-overview.md#external-services`, `05-module-design/conversation-module.md#tts`

### Tasks

1. **WP-INT-003-T001**: Create Integration Module

   - Files: `backend/src/integrations/elevenlabs/elevenlabs.module.ts`
   - Hours: 1

2. **WP-INT-003-T002**: Configure ElevenLabs Client

   - Files: `backend/src/integrations/elevenlabs/elevenlabs.client.ts`
   - Config: API key, voice IDs per persona setting
   - Hours: 2

3. **WP-INT-003-T003**: Implement Streaming TTS

   - Features: Text-to-audio streaming, chunk handling
   - Hours: 5

4. **WP-INT-003-T004**: Implement Voice Selection

   - Features: Map persona voice setting to ElevenLabs voice ID
   - Hours: 2

5. **WP-INT-003-T005**: Implement Caching

   - Features: Cache common phrases in S3
   - Hours: 3

6. **WP-INT-003-T006**: Add Error Handling & Fallback
   - Features: Fallback to cached audio, error recovery
   - Hours: 2

---

## WP-INT-004: App Store IAP Integration

### Overview

- **Description**: iOS In-App Purchase verification
- **Dependencies**: WP-BE-015
- **Estimated Days**: 2
- **DD References**: `03-system-overview.md#external-services`

### Tasks

1. **WP-INT-004-T001**: Create IAP Module

   - Hours: 1

2. **WP-INT-004-T002**: Configure App Store Connect

   - Features: Shared secret, product IDs
   - Hours: 1

3. **WP-INT-004-T003**: Implement Receipt Verification

   - Features: Verify with Apple servers, sandbox support
   - Hours: 4

4. **WP-INT-004-T004**: Implement Subscription Status Check

   - Features: Check expiry, auto-renew status
   - Hours: 2

5. **WP-INT-004-T005**: Handle Server Notifications

   - Features: Webhook for subscription events
   - Hours: 2

6. **WP-INT-004-T006**: Add Integration Tests
   - Hours: 2

---

## WP-INT-005: Play Store IAP Integration

### Overview

- **Description**: Android In-App Purchase verification
- **Dependencies**: WP-BE-015
- **Estimated Days**: 2
- **DD References**: `03-system-overview.md#external-services`

### Tasks

1. **WP-INT-005-T001**: Create Play Store Module

   - Hours: 1

2. **WP-INT-005-T002**: Configure Google Play Console

   - Features: Service account, product IDs
   - Hours: 1

3. **WP-INT-005-T003**: Implement Purchase Verification

   - Features: Google Play Developer API
   - Hours: 4

4. **WP-INT-005-T004**: Implement Subscription Status Check

   - Hours: 2

5. **WP-INT-005-T005**: Handle RTDN (Real-time Developer Notifications)

   - Features: Pub/Sub webhook
   - Hours: 2

6. **WP-INT-005-T006**: Add Integration Tests
   - Hours: 2

---

## Phase Summary

| Work Package | Name           | Tasks  | Est. Hours | Status |
| ------------ | -------------- | ------ | ---------- | ------ |
| WP-INT-001   | Deepgram STT   | 6      | 16         | ⬜     |
| WP-INT-002   | OpenAI GPT-4o  | 6      | 18         | ⬜     |
| WP-INT-003   | ElevenLabs TTS | 6      | 15         | ⬜     |
| WP-INT-004   | App Store IAP  | 6      | 12         | ⬜     |
| WP-INT-005   | Play Store IAP | 6      | 12         | ⬜     |
| **Total**    |                | **30** | **73**     |        |

---

## DD References

- `03-system-overview.md#external-services`
- `05-module-design/conversation-module.md`

---

## Next Phase

→ [Phase 7: Quality Assurance](../phase-7-qa.md)

---

_Back to: [\_index.md](../_index.md)_
