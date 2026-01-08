import {
  Injectable,
  CanActivate,
  ExecutionContext,
  ForbiddenException,
} from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { SUBSCRIPTION_REQUIRED_KEY } from '../decorators/subscription.decorator';

@Injectable()
export class SubscriptionGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const subscriptionRequired = this.reflector.getAllAndOverride<boolean>(
      SUBSCRIPTION_REQUIRED_KEY,
      [context.getHandler(), context.getClass()],
    );

    if (!subscriptionRequired) {
      return true;
    }

    const request = context.switchToHttp().getRequest<Record<string, any>>();
    const user = request.user as Record<string, any> | undefined;

    if (!user) {
      return false;
    }

    // Check if user has active premium subscription
    // This will be properly implemented when we add the subscription module
    // For now, we'll check if user has a subscriptionTier field
    const hasPremium =
      user.subscriptionTier === 'PREMIUM' || user.subscriptionTier === 'PRO';

    if (!hasPremium) {
      throw new ForbiddenException(
        'This feature requires a premium subscription',
      );
    }

    return true;
  }
}
