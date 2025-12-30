import { Injectable } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';

export type VoiceType = 'male' | 'female' | 'neutral';

export interface Voice {
  voice_id: string;
  name: string;
  category: VoiceType;
}

@Injectable()
export class TTSService {
  private apiKey: string;

  constructor(private configService: ConfigService) {
    this.apiKey = this.configService.get<string>('ELEVENLABS_API_KEY') || '';
  }

  /**
   * Stream synthesize text to speech
   * @param text Text to synthesize
   * @param voice Voice type
   * @returns AsyncGenerator yielding audio chunks
   */
  async *streamSynthesize(
    text: string,
    voice: VoiceType = 'female',
  ): AsyncGenerator<Buffer> {
    try {
      const voiceId = this.getVoiceId(voice);

      // TODO: Implement actual ElevenLabs streaming
      // const ElevenLabs = require('elevenlabs-node');
      // const elevenlabs = new ElevenLabs({ apiKey: this.apiKey });
      //
      // const stream = await elevenlabs.textToSpeech.stream({
      //   voice_id: voiceId,
      //   text,
      //   model_id: 'eleven_multilingual_v2',
      //   output_format: 'mp3_44100_128',
      // });
      //
      // for await (const chunk of stream) {
      //   yield chunk;
      // }

      // Mock implementation - simulate streaming audio chunks
      const mockAudioChunk = Buffer.from('mock-audio-data');
      const chunkCount = Math.ceil(text.length / 20); // Simulate chunks based on text length

      for (let i = 0; i < chunkCount; i++) {
        yield mockAudioChunk;
        // Simulate streaming delay
        await this.delay(50);
      }
    } catch (error) {
      console.error('TTS Error:', error);
      throw new Error('Failed to synthesize speech');
    }
  }

  /**
   * Get available voices
   * @returns List of available voices
   */
  async getVoices(): Promise<Voice[]> {
    try {
      // TODO: Implement actual API call
      // const elevenlabs = new ElevenLabs({ apiKey: this.apiKey });
      // return await elevenlabs.voices.getAll();

      // Mock voices
      return [
        { voice_id: 'voice_1', name: 'Sarah', category: 'female' },
        { voice_id: 'voice_2', name: 'Michael', category: 'male' },
        { voice_id: 'voice_3', name: 'Alex', category: 'neutral' },
      ];
    } catch (error) {
      console.error('Failed to fetch voices:', error);
      return [];
    }
  }

  /**
   * Get voice ID by type
   * @private
   */
  private getVoiceId(voiceType: VoiceType): string {
    // Default voice IDs (these would come from ElevenLabs)
    const voiceMap: Record<VoiceType, string> = {
      female: '21m00Tcm4TlvDq8ikWAM', // Rachel
      male: 'VR6AewLTigWG4xSOukaG', // Arnold
      neutral: 'pNInz6obpgDQGcFmaJgB', // Adam
    };

    return voiceMap[voiceType] || voiceMap.female;
  }

  /**
   * Map persona to voice
   * @param personaId Persona ID from database
   * @returns Voice type
   */
  getVoiceForPersona(personaId: string): VoiceType {
    // TODO: Implement persona to voice mapping from database
    // For now, return default
    return 'female';
  }

  /**
   * Check if ElevenLabs service is available
   */
  async healthCheck(): Promise<boolean> {
    try {
      return !!this.apiKey;
    } catch (error) {
      return false;
    }
  }

  private delay(ms: number): Promise<void> {
    return new Promise((resolve) => setTimeout(resolve, ms));
  }
}
