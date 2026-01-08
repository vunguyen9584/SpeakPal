import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { google } from 'googleapis';
import type {
  PlayStoreConfig,
  SubscriptionPurchase,
  ProductPurchase,
} from './types';

@Injectable()
export class PlayStoreClient {
  private readonly logger = new Logger(PlayStoreClient.name);
  private readonly config: PlayStoreConfig;
  // eslint-disable-next-line @typescript-eslint/no-explicit-any
  private readonly androidPublisher: any; // google-api-client

  constructor(private readonly configService: ConfigService) {
    this.config = {
      packageName: this.configService.get<string>('PLAYSTORE_PACKAGE_NAME', ''),
      serviceAccountEmail: this.configService.get<string>(
        'PLAYSTORE_SERVICE_ACCOUNT_EMAIL',
        '',
      ),
      serviceAccountKey: this.configService.get<string>(
        'PLAYSTORE_SERVICE_ACCOUNT_KEY',
        '',
      ),
    };

    if (!this.config.serviceAccountKey) {
      this.logger.warn('PLAYSTORE_SERVICE_ACCOUNT_KEY not configured');
    }

    // Initialize Google Play Developer API client
    try {
      const auth = new google.auth.GoogleAuth({
        credentials: this.config.serviceAccountKey
          ? (JSON.parse(this.config.serviceAccountKey) as Record<
              string,
              unknown
            >)
          : undefined,
        scopes: ['https://www.googleapis.com/auth/androidpublisher'],
      });

      this.androidPublisher = google.androidpublisher({
        version: 'v3',
        auth,
      });

      this.logger.log('Play Store client initialized');
    } catch (error) {
      this.logger.error('Error initializing Play Store client:', error);
    }
  }

  getConfig(): PlayStoreConfig {
    return { ...this.config };
  }

  /**
   * Verify subscription purchase
   */
  async verifySubscription(
    productId: string,
    purchaseToken: string,
  ): Promise<SubscriptionPurchase | null> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      const response = (await this.androidPublisher.purchases.subscriptions.get(
        {
          packageName: this.config.packageName,
          subscriptionId: productId,
          token: purchaseToken,
        },
      )) as { data: unknown };

      return response.data as SubscriptionPurchase;
    } catch (error) {
      this.logger.error('Error verifying subscription:', error);
      return null;
    }
  }

  /**
   * Verify product purchase
   */
  async verifyProduct(
    productId: string,
    purchaseToken: string,
  ): Promise<ProductPurchase | null> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      const response = (await this.androidPublisher.purchases.products.get({
        packageName: this.config.packageName,
        productId,
        token: purchaseToken,
      })) as { data: unknown };

      return response.data as ProductPurchase;
    } catch (error) {
      this.logger.error('Error verifying product:', error);
      return null;
    }
  }

  /**
   * Acknowledge subscription purchase
   */
  async acknowledgeSubscription(
    productId: string,
    purchaseToken: string,
  ): Promise<boolean> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      await this.androidPublisher.purchases.subscriptions.acknowledge({
        packageName: this.config.packageName,
        subscriptionId: productId,
        token: purchaseToken,
      });

      this.logger.log(`Subscription acknowledged: ${productId}`);
      return true;
    } catch (error) {
      this.logger.error('Error acknowledging subscription:', error);
      return false;
    }
  }

  /**
   * Acknowledge product purchase
   */
  async acknowledgeProduct(
    productId: string,
    purchaseToken: string,
  ): Promise<boolean> {
    try {
      // eslint-disable-next-line @typescript-eslint/no-unsafe-member-access, @typescript-eslint/no-unsafe-call
      await this.androidPublisher.purchases.products.acknowledge({
        packageName: this.config.packageName,
        productId,
        token: purchaseToken,
      });

      this.logger.log(`Product acknowledged: ${productId}`);
      return true;
    } catch (error) {
      this.logger.error('Error acknowledging product:', error);
      return false;
    }
  }
}
