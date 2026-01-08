import { Injectable } from '@nestjs/common';
import * as admin from 'firebase-admin';
import { FCMNotification } from '../../modules/notification/notification.types';

@Injectable()
export class FCMService {
  private app: admin.app.App;
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
      // Check if already initialized
      if (admin.apps.length > 0) {
        this.app = admin.apps[0];
        this.initialized = true;
        return;
      }

      // Initialize with service account credentials
      const projectId = process.env.FIREBASE_PROJECT_ID;
      const privateKey = process.env.FIREBASE_PRIVATE_KEY?.replace(
        /\\n/g,
        '\n',
      );
      const clientEmail = process.env.FIREBASE_CLIENT_EMAIL;

      if (!projectId || !privateKey || !clientEmail) {
        console.warn(
          'Firebase credentials not found. FCM notifications will be mocked.',
        );
        this.initialized = false;
        return;
      }

      this.app = admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          privateKey,
          clientEmail,
        }),
      });

      this.initialized = true;
      console.log('Firebase Admin SDK initialized successfully');
    } catch (error) {
      console.error('Failed to initialize Firebase Admin SDK:', error);
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
    if (!this.initialized) {
      console.log(`[MOCK] Would send notification to ${token}:`, notification);
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
      console.error('Failed to send FCM notification:', error);
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
    if (!this.initialized) {
      console.log(
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
      console.error('Failed to send batch FCM notifications:', error);
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
