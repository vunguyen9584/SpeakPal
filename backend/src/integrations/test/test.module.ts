import { Module } from '@nestjs/common';
import { TestIntegrationController } from './test.controller';
import { DeepgramModule } from '../deepgram/deepgram.module';
import { OpenAIModule } from '../openai/openai.module';
import { ElevenLabsModule } from '../elevenlabs/elevenlabs.module';
import { AppStoreModule } from '../appstore/appstore.module';
import { PlayStoreModule } from '../playstore/playstore.module';

@Module({
    imports: [
        DeepgramModule,
        OpenAIModule,
        ElevenLabsModule,
        AppStoreModule,
        PlayStoreModule,
    ],
    controllers: [TestIntegrationController],
})
export class TestIntegrationModule { }
