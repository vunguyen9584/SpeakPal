import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { createClient, LiveTranscriptionEvents } from '@deepgram/sdk';
import type { DeepgramConfig, StreamingOptions } from './types';

@Injectable()
export class DeepgramClient {
  private readonly logger = new Logger(DeepgramClient.name);
  private readonly client: any;
  private readonly config: DeepgramConfig;

  constructor(private readonly configService: ConfigService) {
    const apiKey = this.configService.get<string>('DEEPGRAM_API_KEY');

    if (!apiKey) {
      this.logger.warn('DEEPGRAM_API_KEY not configured');
    }

    this.client = createClient(apiKey || '');

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

    this.logger.log(
      `Deepgram client initialized with model: ${this.config.model}`,
    );
  }

  getClient() {
    return this.client;
  }

  getConfig(): DeepgramConfig {
    return { ...this.config };
  }

  createLiveTranscription(options: StreamingOptions) {
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
