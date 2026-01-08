# Integration Testing Guide

This guide describes how to use the test endpoints for external integrations.

## Prerequisites

- **Server Running**: Ensure the backend server is running (`npm run start:dev`)
- **API Keys Configured**: Ensure `.env` has valid API keys

## Test Endpoints

### 1. Deepgram STT

Transcribes an uploaded audio file.

- **URL**: `POST /test-integrations/deepgram`
- **Body**: `form-data`
  - `audio`: File (wav/mp3)

**Curl Example**:

```bash
curl -X POST http://localhost:3000/test-integrations/deepgram \
  -F "audio=@/path/to/audio/file.wav"
```

### 2. OpenAI GPT-4o

Generates a conversation response.

- **URL**: `POST /test-integrations/openai`
- **Body**: `application/json`
  - `message`: User message
  - `persona`: (Optional) Persona ID

**Curl Example**:

```bash
curl -X POST http://localhost:3000/test-integrations/openai \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, can you help me learn English?", "persona": "teacher"}'
```

### 3. ElevenLabs TTS

Converts text to speech and returns an audio file.

- **URL**: `POST /test-integrations/elevenlabs`
- **Body**: `application/json`
  - `text`: Text to convert
  - `voiceId`: (Optional) Voice ID

**Curl Example**:

```bash
curl -X POST http://localhost:3000/test-integrations/elevenlabs \
  -H "Content-Type: application/json" \
  -d '{"text": "Welcome to SpeakPal! Let us start practicing."}' \
  --output output.mp3
```

### 4. App Store IAP

Verifies an App Store receipt.

- **URL**: `POST /test-integrations/appstore`
- **Body**: `application/json`
  - `receiptData`: Base64 encoded receipt data

**Curl Example**:

```bash
curl -X POST http://localhost:3000/test-integrations/appstore \
  -H "Content-Type: application/json" \
  -d '{"receiptData": "MI..."}'
```

### 5. Play Store IAP

Verifies a Google Play Store purchase.

- **URL**: `POST /test-integrations/playstore`
- **Body**: `application/json`
  - `productId`: Product ID
  - `purchaseToken`: Purchase token

**Curl Example**:

```bash
curl -X POST http://localhost:3000/test-integrations/playstore \
  -H "Content-Type: application/json" \
  -d '{"productId": "premium_monthly", "purchaseToken": "token123"}'
```

---

## Troubleshooting

- **500 Error?** Check console logs for detailed error messages. Usually indicates missing API keys or network issues.
- **400 Error?** Check request body format.
