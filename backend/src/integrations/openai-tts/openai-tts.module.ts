import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { OpenAITTSClient } from './openai-tts.client';
import { OpenAITTSService } from './openai-tts.service';

@Module({
    imports: [ConfigModule],
    providers: [OpenAITTSClient, OpenAITTSService],
    exports: [OpenAITTSClient, OpenAITTSService],
})
export class OpenAITTSModule { }
