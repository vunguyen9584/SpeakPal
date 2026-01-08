import { Module } from '@nestjs/common';
import { AppStoreClient } from './appstore.client';
import { AppStoreService } from './appstore.service';

@Module({
  providers: [AppStoreClient, AppStoreService],
  exports: [AppStoreService],
})
export class AppStoreModule {}
