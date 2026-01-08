# External Integrations - Quick Start Guide

This guide shows how to use the newly implemented external integrations in your SpeakPal backend.

---

## 📋 Table of Contents

1. [Setup & Configuration](#setup--configuration)
2. [Deepgram STT Usage](#deepgram-stt-usage)
3. [OpenAI GPT-4o Usage](#openai-gpt-4o-usage)
4. [ElevenLabs TTS Usage](#elevenlabs-tts-usage)
5. [App Store IAP Usage](#app-store-iap-usage)
6. [Play Store IAP Usage](#play-store-iap-usage)

---

## Setup & Configuration

### 1. Install Dependencies

```bash
cd backend
npm install @deepgram/sdk openai elevenlabs axios googleapis
```

### 2. Configure Environment Variables

Copy `.env.example` to `.env` and fill in your API keys:

```bash
cp .env.example .env
```

Edit `.env`:

```bash
# Deepgram
DEEPGRAM_API_KEY=your-actual-deepgram-api-key

# OpenAI
OPENAI_API_KEY=your-actual-openai-api-key

# ElevenLabs
ELEVENLABS_API_KEY=your-actual-elevenlabs-api-key

# App Store (optional for now)
APPSTORE_SHARED_SECRET=your-shared-secret
APPSTORE_BUNDLE_ID=com.speakpal.app

# Play Store (optional for now)
PLAYSTORE_PACKAGE_NAME=com.speakpal.app
PLAYSTORE_SERVICE_ACCOUNT_KEY={"type":"service_account",...}
```

### 3. Import Modules in AppModule

```typescript
// backend/src/app.module.ts
import { DeepgramModule } from "./integrations/deepgram";
import { OpenAIModule } from "./integrations/openai";
import { ElevenLabsModule } from "./integrations/elevenlabs";
import { AppStoreModule } from "./integrations/appstore";
import { PlayStoreModule } from "./integrations/playstore";

@Module({
  imports: [
    // ... existing imports
    DeepgramModule,
    OpenAIModule,
    ElevenLabsModule,
    AppStoreModule,
    PlayStoreModule,
  ],
})
export class AppModule {}
```

---

## Deepgram STT Usage

### Basic Streaming Transcription

```typescript
import { DeepgramService } from "./integrations/deepgram";

@Injectable()
export class ConversationService {
  constructor(private readonly deepgramService: DeepgramService) {}

  async startTranscription() {
    // Create streaming session
    const connection = this.deepgramService.createStreamingSession({
      encoding: "linear16",
      sampleRate: 16000,
      channels: 1,
    });

    // Listen for transcription results
    connection.on("Results", (data: any) => {
      const result = this.deepgramService.parseTranscriptionResult(data);

      if (result.isFinal) {
        console.log("Final transcript:", result.transcript);
        console.log("Confidence:", result.confidence);
      } else {
        console.log("Interim:", result.transcript);
      }
    });

    // Send audio chunks
    connection.on("open", () => {
      // Send audio data
      this.deepgramService.sendAudioChunk(connection, audioBuffer);
    });

    return connection;
  }

  async transcribeFile(audioBuffer: Buffer) {
    const result = await this.deepgramService.transcribeAudioFile(audioBuffer);
    return result.transcript;
  }
}
```

---

## OpenAI GPT-4o Usage

### Generate Conversation Response

```typescript
import { OpenAIService } from "./integrations/openai";
import type { ConversationContext } from "./integrations/openai";

@Injectable()
export class AIService {
  constructor(private readonly openaiService: OpenAIService) {}

  async generateResponse(userMessage: string, persona: string, topic: string) {
    const context: ConversationContext = {
      personaId: persona,
      topic: topic,
      level: "intermediate",
      conversationHistory: [{ role: "user", content: userMessage }],
    };

    const response = await this.openaiService.generateConversationResponse(
      context
    );
    return response;
  }

  async *streamResponse(context: ConversationContext) {
    for await (const chunk of this.openaiService.generateStreamingConversationResponse(
      context
    )) {
      yield chunk.content;
    }
  }

  async analyzeErrors(userText: string, context: string) {
    const analysis = await this.openaiService.analyzeErrors({
      userText,
      context,
      level: "intermediate",
    });

    return {
      errors: analysis.errors,
      corrections: analysis.corrections,
      suggestions: analysis.suggestions,
    };
  }
}
```

---

## ElevenLabs TTS Usage

### Convert Text to Speech

```typescript
import { ElevenLabsService } from "./integrations/elevenlabs";

@Injectable()
export class TTSService {
  constructor(private readonly elevenLabsService: ElevenLabsService) {}

  async generateSpeech(text: string, personaVoice: string) {
    // Get voice ID for persona
    const voiceId = this.elevenLabsService.getVoiceIdForPersona(personaVoice);

    // Generate audio
    const audioBuffer = await this.elevenLabsService.textToSpeech({
      text,
      voiceId,
    });

    return audioBuffer;
  }

  async *streamSpeech(text: string, voiceId: string) {
    for await (const chunk of this.elevenLabsService.textToSpeechStreaming({
      text,
      voiceId,
    })) {
      yield chunk;
    }
  }

  async getCachedAudio(text: string, voiceId: string) {
    // Uses caching for common phrases
    return this.elevenLabsService.getCachedOrGenerateAudio(text, voiceId);
  }
}
```

### Voice Options

```typescript
// Available persona voices:
const voices = {
  sarah: "Friendly female",
  rachel: "Calm female",
  domi: "Strong female",
  bella: "Young female",
  antoni: "Well-rounded male",
  josh: "Deep male",
  arnold: "Crisp male",
  adam: "Deep male",
  sam: "Raspy male",
};
```

---

## App Store IAP Usage

### Verify Receipt

```typescript
import { AppStoreService } from "./integrations/appstore";

@Injectable()
export class SubscriptionService {
  constructor(private readonly appStoreService: AppStoreService) {}

  async verifyPurchase(receiptData: string) {
    const { valid, status } = await this.appStoreService.verifyReceipt(
      receiptData
    );

    if (!valid) {
      throw new Error("Invalid receipt");
    }

    return {
      isActive: status.isActive,
      productId: status.productId,
      expiresAt: status.expiresAt,
      isTrialPeriod: status.isTrialPeriod,
      willAutoRenew: status.willAutoRenew,
    };
  }

  async handleWebhook(notification: any) {
    await this.appStoreService.handleServerNotification(notification);
    // Update user subscription in database
  }
}
```

---

## Play Store IAP Usage

### Verify Purchase

```typescript
import { PlayStoreService } from "./integrations/playstore";

@Injectable()
export class AndroidSubscriptionService {
  constructor(private readonly playStoreService: PlayStoreService) {}

  async verifyPurchase(productId: string, purchaseToken: string) {
    const { valid, status } =
      await this.playStoreService.verifySubscriptionPurchase({
        packageName: "com.speakpal.app",
        productId,
        purchaseToken,
      });

    if (!valid) {
      throw new Error("Invalid purchase");
    }

    return {
      isActive: status.isActive,
      expiresAt: status.expiresAt,
      willAutoRenew: status.willAutoRenew,
    };
  }

  async handleRTDN(message: any) {
    await this.playStoreService.handleRTDN(message);
    // Update user subscription in database
  }
}
```

---

## Complete Example: Conversation Flow

Here's a complete example showing how all integrations work together:

```typescript
import { Injectable } from "@nestjs/common";
import { DeepgramService } from "./integrations/deepgram";
import { OpenAIService } from "./integrations/openai";
import { ElevenLabsService } from "./integrations/elevenlabs";

@Injectable()
export class ConversationOrchestrator {
  constructor(
    private readonly deepgramService: DeepgramService,
    private readonly openaiService: OpenAIService,
    private readonly elevenLabsService: ElevenLabsService
  ) {}

  async processConversationTurn(audioBuffer: Buffer, context: any) {
    // 1. Transcribe user's speech (STT)
    const transcription = await this.deepgramService.transcribeAudioFile(
      audioBuffer
    );
    const userText = transcription.transcript;

    // 2. Generate AI response (LLM)
    const conversationContext = {
      personaId: context.personaId,
      topic: context.topic,
      level: context.level,
      conversationHistory: [
        ...context.history,
        { role: "user", content: userText },
      ],
    };

    const aiResponse = await this.openaiService.generateConversationResponse(
      conversationContext
    );

    // 3. Analyze user's errors
    const errorAnalysis = await this.openaiService.analyzeErrors({
      userText,
      context: context.topic,
      level: context.level,
    });

    // 4. Convert AI response to speech (TTS)
    const voiceId = this.elevenLabsService.getVoiceIdForPersona(
      context.personaVoice
    );
    const audioResponse = await this.elevenLabsService.textToSpeech({
      text: aiResponse,
      voiceId,
    });

    return {
      userText,
      aiResponse,
      audioResponse,
      errors: errorAnalysis.errors,
      corrections: errorAnalysis.corrections,
    };
  }
}
```

---

## Testing

### Test Deepgram

```bash
# Make sure you have a test audio file
curl -X POST http://localhost:3000/test/deepgram \
  -F "audio=@test-audio.wav"
```

### Test OpenAI

```bash
curl -X POST http://localhost:3000/test/openai \
  -H "Content-Type: application/json" \
  -d '{"message": "Hello, how are you?"}'
```

### Test ElevenLabs

```bash
curl -X POST http://localhost:3000/test/elevenlabs \
  -H "Content-Type: application/json" \
  -d '{"text": "Hello, welcome to SpeakPal!"}' \
  --output test-output.mp3
```

---

## Troubleshooting

### Common Issues

1. **"API key not configured" warning**

   - Make sure `.env` file exists and contains valid API keys
   - Restart the NestJS server after updating `.env`

2. **Module import errors**

   - Run `npm install` to ensure all dependencies are installed
   - Check that modules are properly imported in `app.module.ts`

3. **Deepgram connection errors**

   - Verify audio format matches configuration (encoding, sample rate)
   - Check network connectivity to Deepgram servers

4. **OpenAI rate limiting**

   - Implement request queuing
   - Use token estimation to stay within limits

5. **ElevenLabs quota exceeded**
   - Use caching for common phrases
   - Consider upgrading plan or implementing fallback TTS

---

## Best Practices

1. **Error Handling**: Always wrap integration calls in try-catch blocks
2. **Caching**: Use caching for frequently used TTS phrases
3. **Rate Limiting**: Implement rate limiting for API calls
4. **Monitoring**: Log API usage and errors for monitoring
5. **Fallbacks**: Implement fallback mechanisms for critical features
6. **Testing**: Use sandbox/test modes before production

---

## Next Steps

1. Integrate these services into existing modules:

   - Conversation Module (WP-BE-007)
   - Subscription Module (WP-BE-015)

2. Add error handling and retry logic

3. Implement monitoring and logging

4. Create integration tests

5. Set up production API keys and credentials

---

_Last updated: 2026-01-08_
