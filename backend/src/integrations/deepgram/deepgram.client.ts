import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient } from '@deepgram/sdk';
import type { DeepgramConfig, StreamingOptions } from './types';

@Injectable()
export class DeepgramClient {
  private readonly logger = new Logger(DeepgramClient.name);
  private client: ReturnType<typeof createClient> | null = null;
  private readonly config: DeepgramConfig;
  private readonly isConfigured: boolean;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('DEEPGRAM_API_KEY');

    this.isConfigured = !!apiKey;

    if (!apiKey) {
      this.logger.warn(
        'DEEPGRAM_API_KEY not configured. Speech-to-text features will not work.',
      );
    } else {
      this.client = createClient(apiKey);
    }

    this.config = {
      apiKey: apiKey || '',
      model: this.configService.get<string>('DEEPGRAM_MODEL', 'nova-2'),
      language: this.configService.get<string>('DEEPGRAM_LANGUAGE', 'en-US'),
      punctuate: this.configService.get<boolean>('DEEPGRAM_PUNCTUATE', true),
      interimResults: this.configService.get<boolean>(
        'DEEPGRAM_INTERIM_RESULTS',
        true,
      ),
    };

    if (this.isConfigured) {
      this.logger.log(
        `Deepgram client initialized with model: ${this.config.model}`,
      );
    }
  }

  /**
   * Check if the Deepgram client is properly configured
   */
  isAvailable(): boolean {
    return this.isConfigured && this.client !== null;
  }

  getClient() {
    if (!this.client) {
      throw new Error(
        'Deepgram client not configured. Set DEEPGRAM_API_KEY environment variable.',
      );
    }
    return this.client;
  }

  getConfig(): DeepgramConfig {
    return { ...this.config };
  }

  createLiveTranscription(options: StreamingOptions) {
    if (!this.client) {
      throw new Error(
        'Deepgram client not configured. Set DEEPGRAM_API_KEY environment variable.',
      );
    }
    return this.client.listen.live({
      model: this.config.model,
      language: this.config.language,
      punctuate: this.config.punctuate,
      interim_results: this.config.interimResults,
      encoding: options.encoding,
      sample_rate: options.sampleRate,
      channels: options.channels,
    });
  }
}
