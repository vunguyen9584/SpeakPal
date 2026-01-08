import { Injectable, Logger } from '@nestjs/common';
import { PlayStoreClient } from './playstore.client';
import type {
    PurchaseVerificationRequest,
    PlayStoreSubscriptionStatus,
    RTDNMessage,
    SubscriptionPurchase,
} from './types';

@Injectable()
export class PlayStoreService {
    private readonly logger = new Logger(PlayStoreService.name);

    constructor(private readonly playStoreClient: PlayStoreClient) { }

    /**
     * Verify subscription purchase
     */
    async verifySubscriptionPurchase(
        request: PurchaseVerificationRequest,
    ): Promise<{ valid: boolean; status: PlayStoreSubscriptionStatus | null }> {
        try {
            const purchase = await this.playStoreClient.verifySubscription(
                request.productId,
                request.purchaseToken,
            );

            if (!purchase) {
                return { valid: false, status: null };
            }

            // Verify package name
            const config = this.playStoreClient.getConfig();
            if (request.packageName !== config.packageName) {
                this.logger.warn(`Package name mismatch: ${request.packageName}`);
                return { valid: false, status: null };
            }

            const status = this.getSubscriptionStatus(purchase);

            // Acknowledge if not yet acknowledged
            if (purchase.acknowledgementState === 0) {
                await this.playStoreClient.acknowledgeSubscription(
                    request.productId,
                    request.purchaseToken,
                );
            }

            return { valid: true, status };
        } catch (error) {
            this.logger.error('Error verifying subscription purchase:', error);
            return { valid: false, status: null };
        }
    }

    /**
     * Get subscription status from purchase data
     */
    private getSubscriptionStatus(
        purchase: SubscriptionPurchase,
    ): PlayStoreSubscriptionStatus {
        const expiresAt = new Date(parseInt(purchase.expiryTimeMillis));
        const isActive = expiresAt > new Date();

        let cancelReason: string | null = null;
        if (purchase.cancelReason !== undefined) {
            const reasons = [
                'User cancelled',
                'System cancelled',
                'Replaced with new subscription',
                'Developer cancelled',
            ];
            cancelReason = reasons[purchase.cancelReason] || 'Unknown';
        }

        return {
            isActive,
            productId: '', // Will be set by caller
            expiresAt,
            willAutoRenew: purchase.autoRenewing,
            cancelReason,
            isAcknowledged: purchase.acknowledgementState === 1,
        };
    }

    /**
     * Handle Real-time Developer Notification (RTDN)
     */
    async handleRTDN(message: RTDNMessage): Promise<void> {
        try {
            this.logger.log(`Received RTDN: ${JSON.stringify(message)}`);

            // Verify package name
            const config = this.playStoreClient.getConfig();
            if (message.packageName !== config.packageName) {
                this.logger.warn(`Package name mismatch in RTDN: ${message.packageName}`);
                return;
            }

            // Handle subscription notification
            if (message.subscriptionNotification) {
                await this.handleSubscriptionNotification(message.subscriptionNotification);
            }

            // Handle one-time product notification
            if (message.oneTimeProductNotification) {
                await this.handleProductNotification(message.oneTimeProductNotification);
            }
        } catch (error) {
            this.logger.error('Error handling RTDN:', error);
        }
    }

    /**
     * Handle subscription notification
     */
    private async handleSubscriptionNotification(notification: any): Promise<void> {
        const notificationTypes = [
            'SUBSCRIPTION_RECOVERED',
            'SUBSCRIPTION_RENEWED',
            'SUBSCRIPTION_CANCELED',
            'SUBSCRIPTION_PURCHASED',
            'SUBSCRIPTION_ON_HOLD',
            'SUBSCRIPTION_IN_GRACE_PERIOD',
            'SUBSCRIPTION_RESTARTED',
            'SUBSCRIPTION_PRICE_CHANGE_CONFIRMED',
            'SUBSCRIPTION_DEFERRED',
            'SUBSCRIPTION_PAUSED',
            'SUBSCRIPTION_PAUSE_SCHEDULE_CHANGED',
            'SUBSCRIPTION_REVOKED',
            'SUBSCRIPTION_EXPIRED',
        ];

        const type = notificationTypes[notification.notificationType] || 'UNKNOWN';
        this.logger.log(`Subscription notification: ${type}`);

        // In production, update database based on notification type
        switch (notification.notificationType) {
            case 1: // SUBSCRIPTION_RECOVERED
            case 2: // SUBSCRIPTION_RENEWED
            case 4: // SUBSCRIPTION_PURCHASED
                this.logger.log('Subscription active/renewed');
                break;

            case 3: // SUBSCRIPTION_CANCELED
            case 12: // SUBSCRIPTION_REVOKED
            case 13: // SUBSCRIPTION_EXPIRED
                this.logger.log('Subscription ended');
                break;

            case 5: // SUBSCRIPTION_ON_HOLD
            case 6: // SUBSCRIPTION_IN_GRACE_PERIOD
                this.logger.log('Subscription in grace period');
                break;

            default:
                this.logger.log(`Unhandled notification type: ${notification.notificationType}`);
        }
    }

    /**
     * Handle product notification
     */
    private async handleProductNotification(notification: any): Promise<void> {
        const notificationTypes = [
            'ONE_TIME_PRODUCT_PURCHASED',
            'ONE_TIME_PRODUCT_CANCELED',
        ];

        const type = notificationTypes[notification.notificationType] || 'UNKNOWN';
        this.logger.log(`Product notification: ${type}`);

        // In production, update database based on notification type
    }

    /**
     * Check if subscription is active
     */
    isSubscriptionActive(status: PlayStoreSubscriptionStatus): boolean {
        return status.isActive && status.willAutoRenew;
    }

    /**
     * Get days until expiration
     */
    getDaysUntilExpiration(status: PlayStoreSubscriptionStatus): number {
        const now = new Date();
        const diff = status.expiresAt.getTime() - now.getTime();
        return Math.ceil(diff / (1000 * 60 * 60 * 24));
    }
}
