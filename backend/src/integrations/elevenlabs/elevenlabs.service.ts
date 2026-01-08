import { Injectable, Logger } from '@nestjs/common';
import { ElevenLabsClient } from './elevenlabs.client';
import type { TTSRequest, StreamingTTSOptions, VoiceSettings } from './types';
import { Readable } from 'stream';

@Injectable()
export class ElevenLabsService {
  private readonly logger = new Logger(ElevenLabsService.name);
  private readonly voiceCache = new Map<string, string>();

  constructor(private readonly elevenLabsClient: ElevenLabsClient) {}

  /**
   * Convert text to speech (streaming)
   */
  async *textToSpeechStreaming(
    options: StreamingTTSOptions,
  ): AsyncGenerator<Buffer> {
    try {
      const config = this.elevenLabsClient.getConfig();
      const client = this.elevenLabsClient.getClient();

      const voiceSettings: VoiceSettings = options.voiceSettings || {
        stability: config.stability,
        similarity_boost: config.similarityBoost,
      };

      const audioStream = await client.textToSpeech.convert(options.voiceId, {
        text: options.text,
        model_id: options.modelId || config.model,
        voice_settings: voiceSettings,
      });

      // Convert the stream to async generator
      for await (const chunk of audioStream) {
        yield chunk as Buffer;
      }
    } catch (error) {
      this.logger.error('Error in streaming TTS:', error);
      throw error;
    }
  }

  /**
   * Convert text to speech (complete audio buffer)
   */
  async textToSpeech(request: TTSRequest): Promise<Buffer> {
    try {
      const config = this.elevenLabsClient.getConfig();
      const voiceId = request.voiceId || config.defaultVoiceId;

      const chunks: Buffer[] = [];

      for await (const chunk of this.textToSpeechStreaming({
        text: request.text,
        voiceId,
        voiceSettings: request.settings,
      })) {
        chunks.push(chunk);
      }

      return Buffer.concat(chunks);
    } catch (error) {
      this.logger.error('Error converting text to speech:', error);
      throw error;
    }
  }

  /**
   * Get voice ID for persona
   * Maps persona settings to ElevenLabs voice IDs
   */
  getVoiceIdForPersona(personaVoice: string): string {
    const config = this.elevenLabsClient.getConfig();
    const voiceMap = config.voiceMap || {};

    return voiceMap[personaVoice.toLowerCase()] || config.defaultVoiceId;
  }

  /**
   * Cache common phrases
   * Returns cached audio if available, otherwise generates and caches
   */
  async getCachedOrGenerateAudio(
    text: string,
    voiceId: string,
  ): Promise<Buffer> {
    const cacheKey = `${voiceId}:${text}`;

    // Check cache (in production, use Redis or S3)
    if (this.voiceCache.has(cacheKey)) {
      this.logger.log(`Cache hit for: ${text.substring(0, 30)}...`);
      const base64Audio = this.voiceCache.get(cacheKey);
      return Buffer.from(base64Audio, 'base64');
    }

    // Generate audio
    const audio = await this.textToSpeech({ text, voiceId });

    // Cache it (in production, use Redis or S3)
    this.voiceCache.set(cacheKey, audio.toString('base64'));

    return audio;
  }

  /**
   * Get available voices
   */
  async getAvailableVoices() {
    return this.elevenLabsClient.getVoices();
  }

  /**
   * Clear voice cache
   */
  clearCache() {
    this.voiceCache.clear();
    this.logger.log('Voice cache cleared');
  }
}
