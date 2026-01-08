import { Injectable, Logger } from '@nestjs/common';
import { DeepgramClient } from './deepgram.client';
import type { TranscriptionResult, StreamingOptions, WordInfo } from './types';
import { LiveTranscriptionEvents } from '@deepgram/sdk';

@Injectable()
export class DeepgramService {
  private readonly logger = new Logger(DeepgramService.name);

  constructor(private readonly deepgramClient: DeepgramClient) {}

  /**
   * Create a streaming STT session
   * Returns a connection object that can receive audio chunks
   */
  createStreamingSession(options: StreamingOptions) {
    const connection = this.deepgramClient.createLiveTranscription(options);

    connection.on(LiveTranscriptionEvents.Open, () => {
      this.logger.log('Deepgram connection opened');
    });

    connection.on(LiveTranscriptionEvents.Close, () => {
      this.logger.log('Deepgram connection closed');
    });

    connection.on(LiveTranscriptionEvents.Error, (error: any) => {
      this.logger.error('Deepgram error:', error);
    });

    return connection;
  }

  /**
   * Send audio chunk to streaming session
   */
  sendAudioChunk(connection: any, audioChunk: Buffer) {
    try {
      connection.send(audioChunk);
    } catch (error) {
      this.logger.error('Error sending audio chunk:', error);
      throw error;
    }
  }

  /**
   * Close streaming session
   */
  closeStreamingSession(connection: any) {
    try {
      connection.finish();
      this.logger.log('Deepgram streaming session closed');
    } catch (error) {
      this.logger.error('Error closing streaming session:', error);
    }
  }

  /**
   * Parse Deepgram response to TranscriptionResult
   */
  parseTranscriptionResult(data: any): TranscriptionResult {
    const channel = data.channel;
    const alternative = channel?.alternatives?.[0];

    if (!alternative) {
      return {
        transcript: '',
        confidence: 0,
        isFinal: false,
      };
    }

    const words: WordInfo[] =
      alternative.words?.map((word: any) => ({
        word: word.word,
        start: word.start,
        end: word.end,
        confidence: word.confidence,
      })) || [];

    return {
      transcript: alternative.transcript || '',
      confidence: alternative.confidence || 0,
      isFinal: data.is_final || false,
      words: words.length > 0 ? words : undefined,
    };
  }

  /**
   * Transcribe audio file (batch mode)
   */
  async transcribeAudioFile(audioBuffer: Buffer): Promise<TranscriptionResult> {
    try {
      const client = this.deepgramClient.getClient();
      const config = this.deepgramClient.getConfig();

      const { result, error } = await client.listen.prerecorded.transcribeFile(
        audioBuffer,
        {
          model: config.model,
          language: config.language,
          punctuate: config.punctuate,
        },
      );

      if (error) {
        this.logger.error('Deepgram transcription error:', error);
        throw new Error(`Transcription failed: ${error.message}`);
      }

      const alternative = result.results?.channels?.[0]?.alternatives?.[0];

      if (!alternative) {
        return {
          transcript: '',
          confidence: 0,
          isFinal: true,
        };
      }

      const words: WordInfo[] =
        alternative.words?.map((word: any) => ({
          word: word.word,
          start: word.start,
          end: word.end,
          confidence: word.confidence,
        })) || [];

      return {
        transcript: alternative.transcript || '',
        confidence: alternative.confidence || 0,
        isFinal: true,
        words: words.length > 0 ? words : undefined,
      };
    } catch (error) {
      this.logger.error('Error transcribing audio file:', error);
      throw error;
    }
  }
}
