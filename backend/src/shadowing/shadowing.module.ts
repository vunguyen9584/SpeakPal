import { Module } from '@nestjs/common';
import { ShadowingController } from './shadowing.controller';
import { ShadowingService } from './services/shadowing.service';
import { ShadowingContentRepository } from './repositories';
import { PrismaModule } from '../prisma/prisma.module';
import { QuickResponseModule } from '../quick-response/quick-response.module';

@Module({
  imports: [PrismaModule, QuickResponseModule],
  controllers: [ShadowingController],
  providers: [ShadowingService, ShadowingContentRepository],
  exports: [ShadowingService],
})
export class ShadowingModule {}
