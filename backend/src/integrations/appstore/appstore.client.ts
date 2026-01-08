import { Injectable, Logger } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import axios from 'axios';
import type {
  AppStoreConfig,
  ReceiptVerificationRequest,
  ReceiptVerificationResponse,
} from './types';

@Injectable()
export class AppStoreClient {
  private readonly logger = new Logger(AppStoreClient.name);
  private readonly config: AppStoreConfig;
  private readonly productionUrl: string;
  private readonly sandboxUrl: string;

  constructor(private readonly configService: ConfigService) {
    // Get URLs from centralized config
    this.productionUrl = this.configService.get<string>(
      'externalServices.appStore.productionUrl',
      'https://buy.itunes.apple.com/verifyReceipt',
    );
    this.sandboxUrl = this.configService.get<string>(
      'externalServices.appStore.sandboxUrl',
      'https://sandbox.itunes.apple.com/verifyReceipt',
    );

    this.config = {
      sharedSecret: this.configService.get<string>(
        'externalServices.appStore.sharedSecret',
        '',
      ),
      bundleId: this.configService.get<string>(
        'externalServices.appStore.bundleId',
        '',
      ),
      useSandbox: this.configService.get<boolean>(
        'externalServices.appStore.useSandbox',
        true,
      ),
    };

    if (!this.config.sharedSecret) {
      this.logger.warn('APPSTORE_SHARED_SECRET not configured');
    }

    this.logger.log(
      `App Store client initialized (${this.config.useSandbox ? 'sandbox' : 'production'} mode)`,
    );
  }

  getConfig(): AppStoreConfig {
    return { ...this.config };
  }

  /**
   * Verify receipt with Apple servers
   */
  async verifyReceipt(
    request: ReceiptVerificationRequest,
  ): Promise<ReceiptVerificationResponse> {
    try {
      const url = this.config.useSandbox ? this.sandboxUrl : this.productionUrl;

      const payload = {
        'receipt-data': request.receiptData,
        password: this.config.sharedSecret,
        'exclude-old-transactions': request.excludeOldTransactions || false,
      };

      const response = await axios.post<ReceiptVerificationResponse>(
        url,
        payload,
      );

      // If production returns 21007 (sandbox receipt), retry with sandbox
      if (response.data.status === 21007 && !this.config.useSandbox) {
        this.logger.log('Retrying with sandbox URL');
        const sandboxResponse = await axios.post<ReceiptVerificationResponse>(
          this.sandboxUrl,
          payload,
        );
        return sandboxResponse.data;
      }

      return response.data;
    } catch (error) {
      this.logger.error('Error verifying receipt:', error);
      throw error;
    }
  }

  /**
   * Verify bundle ID matches
   */
  verifyBundleId(bundleId: string): boolean {
    return bundleId === this.config.bundleId;
  }
}
