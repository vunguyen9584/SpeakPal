import { Module } from '@nestjs/common';
import { ElevenLabsClient } from './elevenlabs.client';
import { ElevenLabsService } from './elevenlabs.service';

@Module({
    providers: [ElevenLabsClient, ElevenLabsService],
    exports: [ElevenLabsService],
})
export class ElevenLabsModule { }
