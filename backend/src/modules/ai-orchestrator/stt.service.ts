import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export interface TranscriptChunk {
  text: string;
  isFinal: boolean;
  confidence: number;
  timestamp: Date;
}

@Injectable()
export class STTService {
  private apiKey: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('DEEPGRAM_API_KEY') || '';
  }

  /**
   * Stream transcribe audio using Deepgram
   * @param audio Audio buffer (16kHz, mono, PCM)
   * @returns AsyncGenerator yielding transcript chunks
   */
  async *streamTranscribe(audio: Buffer): AsyncGenerator<TranscriptChunk> {
    try {
      // TODO: Implement actual Deepgram streaming
      // const { createClient } = require('@deepgram/sdk');
      // const deepgram = createClient(this.apiKey);
      //
      // const { result, error } = await deepgram.listen.prerecorded.transcribeFile(
      //   audio,
      //   {
      //     model: 'nova-2',
      //     language: 'en',
      //     smart_format: true,
      //     punctuate: true,
      //   }
      // );

      // Mock implementation
      const mockTranscripts: TranscriptChunk[] = [
        {
          text: 'Hello',
          isFinal: false,
          confidence: 0.85,
          timestamp: new Date(),
        },
        {
          text: 'Hello, how',
          isFinal: false,
          confidence: 0.90,
          timestamp: new Date(),
        },
        {
          text: 'Hello, how are you?',
          isFinal: true,
          confidence: 0.95,
          timestamp: new Date(),
        },
      ];

      for (const transcript of mockTranscripts) {
        yield transcript;
        // Simulate streaming delay
        await this.delay(100);
      }
    } catch (error) {
      console.error('STT Error:', error);
      throw new Error('Failed to transcribe audio');
    }
  }

  /**
   * Detect language from audio
   * @param audio Audio buffer
   * @returns Detected language code (e.g., 'en', 'ja')
   */
  async detectLanguage(audio: Buffer): Promise<string> {
    try {
      // TODO: Implement with Deepgram language detection
      // For now, default to English
      return 'en';
    } catch (error) {
      console.error('Language detection error:', error);
      return 'en'; // Default fallback
    }
  }

  /**
   * Check if Deepgram service is available
   */
  async healthCheck(): Promise<boolean> {
    try {
      // TODO: Implement actual health check
      return !!this.apiKey;
    } catch (error) {
      return false;
    }
  }

  private delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
