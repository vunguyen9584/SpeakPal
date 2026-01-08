import { Module } from '@nestjs/common';
import { NotificationService } from './notification.service';
import { FCMService } from '../../integrations/firebase/fcm.service';
import { NotificationScheduler } from './notification.scheduler';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  providers: [NotificationService, FCMService, NotificationScheduler],
  exports: [NotificationService],
})
export class NotificationModule {}
