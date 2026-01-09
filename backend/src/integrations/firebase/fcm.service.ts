import { Injectable, Logger } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { FCMNotification } from '../../modules/notification/notification.types';

@Injectable()
export class FCMService {
  private readonly logger = new Logger(FCMService.name);
  private app: admin.app.App | null = null;
  private initialized = false;

  constructor() {
    this.initializeFirebase();
  }

  /**
   * Initialize Firebase Admin SDK
   * Uses environment variables for configuration
   */
  private initializeFirebase() {
    try {
      // Check if already initialized by another service (e.g., FirebaseService)
      if (admin.apps.length > 0) {
        this.app = admin.apps[0] as admin.app.App;
        this.initialized = true;
        this.logger.log('Using existing Firebase Admin SDK instance');
        return;
      }

      // Initialize with service account credentials
      const projectId = process.env.FIREBASE_PROJECT_ID;
      const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(
        /\\n/g,
        '\n',
      );
      const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;

      // Only initialize if ALL credentials are provided and non-empty
      if (
        projectId &&
        projectId.trim().length > 0 &&
        privateKey &&
        privateKey.trim().length > 0 &&
        clientEmail &&
        clientEmail.trim().length > 0
      ) {
        this.app = admin.initializeApp({
          credential: admin.credential.cert({
            projectId,
            privateKey,
            clientEmail,
          }),
        });

        this.initialized = true;
        this.logger.log('Firebase Admin SDK initialized successfully');
      } else {
        this.logger.warn(
          'Firebase credentials not configured. FCM notifications will be mocked.',
        );
        this.initialized = false;
      }
    } catch (error) {
      this.logger.error(
        `Failed to initialize Firebase Admin SDK: ${(error as Error).message}`,
      );
      this.initialized = false;
    }
  }

  /**
   * Send push notification to a single device
   */
  async sendPush(
    token: string,
    notification: FCMNotification,
  ): Promise<boolean> {
    if (!this.initialized || !this.app) {
      this.logger.debug(
        `[MOCK] Would send notification to ${token}:`,
        notification,
      );
      return true;
    }

    try {
      await this.app.messaging().send({
        token,
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: notification.data || {},
        android: {
          priority: 'high',
          notification: {
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      });

      return true;
    } catch (error) {
      this.logger.error('Failed to send FCM notification:', error);
      return false;
    }
  }

  /**
   * Send push notifications to multiple devices
   */
  async sendBatchPush(
    tokens: string[],
    notification: FCMNotification,
  ): Promise<{ successCount: number; failureCount: number }> {
    if (!this.initialized || !this.app) {
      this.logger.debug(
        `[MOCK] Would send batch notification to ${tokens.length} devices:`,
        notification,
      );
      return { successCount: tokens.length, failureCount: 0 };
    }

    try {
      const message = {
        notification: {
          title: notification.title,
          body: notification.body,
        },
        data: notification.data || {},
        android: {
          priority: 'high' as const,
          notification: {
            sound: 'default',
          },
        },
        apns: {
          payload: {
            aps: {
              sound: 'default',
              badge: 1,
            },
          },
        },
      };

      const response = await this.app.messaging().sendEachForMulticast({
        tokens,
        ...message,
      });

      return {
        successCount: response.successCount,
        failureCount: response.failureCount,
      };
    } catch (error) {
      this.logger.error('Failed to send batch FCM notifications:', error);
      return { successCount: 0, failureCount: tokens.length };
    }
  }

  /**
   * Check if FCM is properly initialized
   */
  isInitialized(): boolean {
    return this.initialized;
  }
}
