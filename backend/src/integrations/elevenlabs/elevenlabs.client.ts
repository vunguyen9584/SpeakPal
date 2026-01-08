import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { ElevenLabsClient as ElevenLabsSDK } from 'elevenlabs';
import type { ElevenLabsConfig, Voice } from './types';

@Injectable()
export class ElevenLabsClient {
  private readonly logger = new Logger(ElevenLabsClient.name);
  private readonly client: ElevenLabsSDK;
  private readonly config: ElevenLabsConfig;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('ELEVENLABS_API_KEY');

    if (!apiKey) {
      this.logger.warn('ELEVENLABS_API_KEY not configured');
    }

    this.client = new ElevenLabsSDK({
      apiKey: apiKey || '',
    });

    this.config = {
      apiKey: apiKey || '',
      defaultVoiceId: this.configService.get<string>(
        'ELEVENLABS_DEFAULT_VOICE_ID',
        'EXAVITQu4vr4xnSDxMaL', // Default: Sarah
      ),
      model: this.configService.get<string>(
        'ELEVENLABS_MODEL',
        'eleven_monolingual_v1',
      ),
      stability: this.configService.get<number>('ELEVENLABS_STABILITY', 0.5),
      similarityBoost: this.configService.get<number>(
        'ELEVENLABS_SIMILARITY_BOOST',
        0.75,
      ),
      voiceMap: this.loadVoiceMap(),
    };

    this.logger.log(
      `ElevenLabs client initialized with voice: ${this.config.defaultVoiceId}`,
    );
  }

  getClient(): ElevenLabsSDK {
    return this.client;
  }

  getConfig(): ElevenLabsConfig {
    return { ...this.config };
  }

  /**
   * Get available voices
   */
  async getVoices(): Promise<Voice[]> {
    try {
      const response = await this.client.voices.getAll();
      return response.voices as Voice[];
    } catch (error) {
      this.logger.error('Error fetching voices:', error);
      return [];
    }
  }

  /**
   * Get voice by ID
   */
  async getVoice(voiceId: string): Promise<Voice | null> {
    try {
      const response = await this.client.voices.get(voiceId);
      return response as Voice;
    } catch (error) {
      this.logger.error(`Error fetching voice ${voiceId}:`, error);
      return null;
    }
  }

  private loadVoiceMap(): Record<string, string> {
    const envMap = this.configService.get<string>('ELEVENLABS_VOICE_MAP');
    const defaultMap = {
      sarah: 'EXAVITQu4vr4xnSDxMaL', // Sarah - friendly female
      rachel: '21m00Tcm4TlvDq8ikWAM', // Rachel - calm female
      domi: 'AZnzlk1XvdvUeBnXmlld', // Domi - strong female
      bella: 'EXAVITQu4vr4xnSDxMaL', // Bella - young female
      antoni: 'ErXwobaYiN019PkySvjV', // Antoni - well-rounded male
      josh: 'TxGEqnHWrfWFTfGW9XjX', // Josh - deep male
      arnold: 'VR6AewLTigWG4xSOukaG', // Arnold - crisp male
      adam: 'pNInz6obpgDQGcFmaJgB', // Adam - deep male
      sam: 'yoZ06aMxZJJ28mfd3POQ', // Sam - raspy male
    };

    if (envMap) {
      try {
        const parsed = JSON.parse(envMap) as Record<string, string>;
        return { ...defaultMap, ...parsed }; // Merge default with env override
      } catch {
        this.logger.warn(
          'Failed to parse ELEVENLABS_VOICE_MAP, using defaults',
        );
      }
    }

    return defaultMap;
  }
}
