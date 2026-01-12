import { Module } from '@nestjs/common';
import { ConfigModule } from '@nestjs/config';
import { TTSOpenAIClient } from './ttsopenai.client';
import { TTSOpenAIService } from './ttsopenai.service';

@Module({
    imports: [ConfigModule],
    providers: [TTSOpenAIClient, TTSOpenAIService],
    exports: [TTSOpenAIClient, TTSOpenAIService],
})
export class TTSOpenAIModule { }
