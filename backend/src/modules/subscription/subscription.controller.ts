import {
    Controller,
    Get,
    Post,
    Body,
    UseGuards,
    Request,
    HttpCode,
    HttpStatus,
} from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { PlanService } from './plan.service';
import { UsageService } from './usage.service';
import { PurchaseService } from './purchase.service';
import { PurchaseRequestDto } from './dto/purchase-request.dto';
import { SubscriptionResponseDto } from './dto/subscription-response.dto';

@Controller('subscriptions')
@UseGuards(JwtAuthGuard)
export class SubscriptionController {
    constructor(
        private readonly planService: PlanService,
        private readonly usageService: UsageService,
        private readonly purchaseService: PurchaseService,
    ) { }

    /**
     * GET /subscriptions/me
     * Get current subscription details
     */
    @Get('me')
    async getCurrentSubscription(
        @Request() req,
    ): Promise<SubscriptionResponseDto> {
        return this.planService.getSubscription(req.user.userId);
    }

    /**
     * GET /subscriptions/usage
     * Get current usage status
     */
    @Get('usage')
    async getUsageStatus(@Request() req) {
        return this.usageService.getUsageStatus(req.user.userId);
    }

    /**
     * POST /subscriptions/purchase
     * Verify and activate a purchase
     */
    @Post('purchase')
    @HttpCode(HttpStatus.OK)
    async verifyPurchase(@Request() req, @Body() dto: PurchaseRequestDto) {
        const result = await this.purchaseService.verifyPurchase(dto);

        if (result.success) {
            await this.purchaseService.activateSubscription(req.user.userId, result);
        }

        return {
            success: result.success,
            message: result.success
                ? 'Subscription activated successfully'
                : result.error,
            subscription: result.success
                ? await this.planService.getSubscription(req.user.userId)
                : null,
        };
    }

    /**
     * POST /subscriptions/restore
     * Restore previous purchases
     */
    @Post('restore')
    @HttpCode(HttpStatus.OK)
    async restorePurchases(
        @Request() req,
        @Body() body: { platform: 'ios' | 'android' },
    ) {
        const restored = await this.purchaseService.restorePurchases(
            req.user.userId,
            body.platform,
        );

        return {
            success: restored,
            message: restored
                ? 'Subscription restored successfully'
                : 'No active subscription found',
            subscription: restored
                ? await this.planService.getSubscription(req.user.userId)
                : null,
        };
    }

    /**
     * POST /subscriptions/cancel
     * Cancel auto-renewal
     */
    @Post('cancel')
    @HttpCode(HttpStatus.OK)
    async cancelSubscription(@Request() req) {
        await this.purchaseService.cancelSubscription(req.user.userId);

        return {
            success: true,
            message: 'Auto-renewal cancelled. Subscription will expire at the end of the current period.',
            subscription: await this.planService.getSubscription(req.user.userId),
        };
    }
}
