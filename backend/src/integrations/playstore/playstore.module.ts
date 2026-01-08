import { Module } from '@nestjs/common';
import { PlayStoreClient } from './playstore.client';
import { PlayStoreService } from './playstore.service';

@Module({
    providers: [PlayStoreClient, PlayStoreService],
    exports: [PlayStoreService],
})
export class PlayStoreModule { }
