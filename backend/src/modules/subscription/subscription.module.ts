import { Module } from '@nestjs/common';
import { SubscriptionController } from './subscription.controller';
import { PlanService } from './plan.service';
import { UsageService } from './usage.service';
import { PurchaseService } from './purchase.service';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
    imports: [PrismaModule],
    controllers: [SubscriptionController],
    providers: [PlanService, UsageService, PurchaseService],
    exports: [PlanService, UsageService, PurchaseService],
})
export class SubscriptionModule { }
