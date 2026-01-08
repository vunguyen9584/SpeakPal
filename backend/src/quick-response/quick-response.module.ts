import { Module } from '@nestjs/common';
import { QuickResponseController } from './quick-response.controller';
import { QuickResponseService } from './services/quick-response.service';
import { QuickResponseRepository } from './repositories';
import { PrismaModule } from '../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [QuickResponseController],
  providers: [QuickResponseService, QuickResponseRepository],
  exports: [QuickResponseService, QuickResponseRepository],
})
export class QuickResponseModule {}
