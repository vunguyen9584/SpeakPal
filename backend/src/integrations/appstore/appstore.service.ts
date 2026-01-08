import { Injectable, Logger } from '@nestjs/common';
import { AppStoreClient } from './appstore.client';
import type {
    ReceiptVerificationRequest,
    SubscriptionStatus,
    ServerNotification,
    LatestReceiptInfo,
} from './types';

@Injectable()
export class AppStoreService {
    private readonly logger = new Logger(AppStoreService.name);

    constructor(private readonly appStoreClient: AppStoreClient) { }

    /**
     * Verify and process receipt
     */
    async verifyReceipt(
        receiptData: string,
    ): Promise<{ valid: boolean; status: SubscriptionStatus | null }> {
        try {
            const request: ReceiptVerificationRequest = {
                receiptData,
                excludeOldTransactions: true,
            };

            const response = await this.appStoreClient.verifyReceipt(request);

            // Check status code
            if (response.status !== 0) {
                this.logger.warn(`Receipt verification failed with status: ${response.status}`);
                return { valid: false, status: null };
            }

            // Verify bundle ID
            const bundleId = response.receipt.bundle_id;
            if (!this.appStoreClient.verifyBundleId(bundleId)) {
                this.logger.warn(`Bundle ID mismatch: ${bundleId}`);
                return { valid: false, status: null };
            }

            // Get subscription status
            const status = this.getSubscriptionStatus(response);

            return { valid: true, status };
        } catch (error) {
            this.logger.error('Error verifying receipt:', error);
            return { valid: false, status: null };
        }
    }

    /**
     * Get subscription status from receipt
     */
    private getSubscriptionStatus(
        response: any,
    ): SubscriptionStatus {
        const latestReceipt = this.getLatestReceiptInfo(response);

        if (!latestReceipt) {
            return {
                isActive: false,
                productId: '',
                expiresAt: null,
                isTrialPeriod: false,
                willAutoRenew: false,
                cancellationDate: null,
            };
        }

        const expiresAt = latestReceipt.expires_date_ms
            ? new Date(parseInt(latestReceipt.expires_date_ms))
            : null;

        const isActive = expiresAt ? expiresAt > new Date() : false;

        const cancellationDate = latestReceipt.cancellation_date_ms
            ? new Date(parseInt(latestReceipt.cancellation_date_ms))
            : null;

        // Check auto-renew status
        const pendingRenewal = response.pending_renewal_info?.[0];
        const willAutoRenew = pendingRenewal?.auto_renew_status === '1';

        return {
            isActive,
            productId: latestReceipt.product_id,
            expiresAt,
            isTrialPeriod: latestReceipt.is_trial_period === 'true',
            willAutoRenew,
            cancellationDate,
        };
    }

    /**
     * Get latest receipt info
     */
    private getLatestReceiptInfo(response: any): LatestReceiptInfo | null {
        const receipts = response.latest_receipt_info || [];

        if (receipts.length === 0) {
            return null;
        }

        // Sort by expires_date_ms descending
        receipts.sort((a: LatestReceiptInfo, b: LatestReceiptInfo) => {
            const aExpires = parseInt(a.expires_date_ms || '0');
            const bExpires = parseInt(b.expires_date_ms || '0');
            return bExpires - aExpires;
        });

        return receipts[0];
    }

    /**
     * Handle server notification from Apple
     */
    async handleServerNotification(
        notification: ServerNotification,
    ): Promise<void> {
        try {
            const { notification_type, unified_receipt } = notification;

            this.logger.log(`Received notification: ${notification_type}`);

            // Verify password matches shared secret
            const config = this.appStoreClient.getConfig();
            if (notification.password !== config.sharedSecret) {
                this.logger.warn('Invalid notification password');
                return;
            }

            // Process notification based on type
            switch (notification_type) {
                case 'INITIAL_BUY':
                    this.logger.log('New subscription purchased');
                    break;

                case 'DID_RENEW':
                    this.logger.log('Subscription renewed');
                    break;

                case 'DID_FAIL_TO_RENEW':
                    this.logger.log('Subscription renewal failed');
                    break;

                case 'DID_CHANGE_RENEWAL_STATUS':
                    this.logger.log('Subscription renewal status changed');
                    break;

                case 'CANCEL':
                    this.logger.log('Subscription cancelled');
                    break;

                case 'REFUND':
                    this.logger.log('Subscription refunded');
                    break;

                default:
                    this.logger.log(`Unknown notification type: ${notification_type}`);
            }

            // In production, update database with new subscription status
            // const status = this.getSubscriptionStatus({ latest_receipt_info: unified_receipt.latest_receipt_info });
            // await this.updateUserSubscription(userId, status);
        } catch (error) {
            this.logger.error('Error handling server notification:', error);
        }
    }

    /**
     * Check if subscription is active
     */
    isSubscriptionActive(status: SubscriptionStatus): boolean {
        return status.isActive && !status.cancellationDate;
    }

    /**
     * Get days until expiration
     */
    getDaysUntilExpiration(status: SubscriptionStatus): number | null {
        if (!status.expiresAt) {
            return null;
        }

        const now = new Date();
        const diff = status.expiresAt.getTime() - now.getTime();
        return Math.ceil(diff / (1000 * 60 * 60 * 24));
    }
}
