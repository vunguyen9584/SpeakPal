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
import type { RequestWithUser } from '../../common/interfaces/request.interface';

@Controller('subscriptions')
export class SubscriptionController {
  constructor(
    private readonly planService: PlanService,
    private readonly usageService: UsageService,
    private readonly purchaseService: PurchaseService,
  ) { }

  /**
   * GET /subscriptions/plans
   * Get available subscription plans (public endpoint)
   */
  @Get('plans')
  async getPlans() {
    return [
      {
        id: 'free',
        name: 'Free',
        price: '$0',
        features: [
          '3 conversations per day',
          'Basic AI model',
          'Limited vocabulary',
          'Ads supported',
        ],
        isPopular: false,
      },
      {
        id: 'premium_monthly',
        name: 'Premium Monthly',
        price: '$9.99/month',
        features: [
          'Unlimited conversations',
          'Advanced AI model',
          'Unlimited vocabulary',
          'All personas',
          'Offline mode',
          'Ad-free',
          'Priority support',
        ],
        isPopular: true,
      },
      {
        id: 'premium_yearly',
        name: 'Premium Yearly',
        price: '$79.99/year',
        features: [
          'Unlimited conversations',
          'Advanced AI model',
          'Unlimited vocabulary',
          'All personas',
          'Offline mode',
          'Ad-free',
          'Priority support',
          'Save 33%',
        ],
        isPopular: false,
      },
    ];
  }

  /**
   * GET /subscriptions/me
   * Get current subscription details
   */
  @Get('me')
  @UseGuards(JwtAuthGuard)
  async getCurrentSubscription(
    @Request() req: RequestWithUser,
  ): Promise<SubscriptionResponseDto> {
    return this.planService.getSubscription(req.user.userId || '');
  }

  /**
   * GET /subscriptions/usage
   * Get current usage status
   */
  @Get('usage')
  @UseGuards(JwtAuthGuard)
  async getUsageStatus(@Request() req: RequestWithUser) {
    return this.usageService.getUsageStatus(req.user.userId || '');
  }

  /**
   * POST /subscriptions/purchase
   * Verify and activate a purchase
   */
  @Post('purchase')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async verifyPurchase(
    @Request() req: RequestWithUser,
    @Body() dto: PurchaseRequestDto,
  ) {
    const result = await this.purchaseService.verifyPurchase(dto);

    if (result.success) {
      await this.purchaseService.activateSubscription(
        req.user.userId || '',
        result,
      );
    }

    return {
      success: result.success,
      message: result.success
        ? 'Subscription activated successfully'
        : result.error,
      subscription: result.success
        ? await this.planService.getSubscription(req.user.userId || '')
        : null,
    };
  }

  /**
   * POST /subscriptions/restore
   * Restore previous purchases
   */
  @Post('restore')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async restorePurchases(
    @Request() req: RequestWithUser,
    @Body() body: { platform: 'ios' | 'android' },
  ) {
    const restored = await this.purchaseService.restorePurchases(
      req.user.userId || '',
      body.platform,
    );

    return {
      success: restored,
      message: restored
        ? 'Subscription restored successfully'
        : 'No active subscription found',
      subscription: restored
        ? await this.planService.getSubscription(req.user.userId || '')
        : null,
    };
  }

  /**
   * POST /subscriptions/cancel
   * Cancel auto-renewal
   */
  @Post('cancel')
  @UseGuards(JwtAuthGuard)
  @HttpCode(HttpStatus.OK)
  async cancelSubscription(@Request() req: RequestWithUser) {
    await this.purchaseService.cancelSubscription(req.user.userId || '');

    return {
      success: true,
      message:
        'Auto-renewal cancelled. Subscription will expire at the end of the current period.',
      subscription: await this.planService.getSubscription(
        req.user.userId || '',
      ),
    };
  }
}
