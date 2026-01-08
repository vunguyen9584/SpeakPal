import { Injectable } from '@nestjs/common';
import { FCMService } from '../../integrations/firebase/fcm.service';
import { PrismaService } from '../../prisma/prisma.service';
import {
  NotificationType,
  FCMNotification,
  NotificationPreferences,
} from './notification.types';
import {
  NOTIFICATION_TEMPLATES,
  renderTemplate,
} from './templates/notification.templates';

@Injectable()
export class NotificationService {
  constructor(
    private readonly fcmService: FCMService,
    private readonly prisma: PrismaService,
  ) {}

  /**
   * Send notification to a user
   */
  async send(
    userId: string,
    type: NotificationType,
    variables: Record<string, string> = {},
  ): Promise<boolean> {
    // Get user's FCM token (would be stored in user preferences)
    // For now, we'll mock this
    const fcmToken = await this.getUserFCMToken(userId);
    if (!fcmToken) {
      console.log(`No FCM token for user ${userId}`);
      return false;
    }

    // Check user preferences
    const preferences = await this.getUserPreferences(userId);
    if (!this.shouldSendNotification(type, preferences)) {
      console.log(`User ${userId} has disabled ${type} notifications`);
      return false;
    }

    // Get and render template
    const template = NOTIFICATION_TEMPLATES[type];
    const rendered = renderTemplate(template, variables);

    // Send via FCM
    const notification: FCMNotification = {
      title: rendered.title,
      body: rendered.body,
      data: rendered.data,
    };

    const success = await this.fcmService.sendPush(fcmToken, notification);

    // Store notification history
    if (success) {
      await this.storeNotification(userId, type, rendered);
    }

    return success;
  }

  /**
   * Send notification to multiple users
   */
  async sendBatch(
    userIds: string[],
    type: NotificationType,
    variables: Record<string, string> = {},
  ): Promise<{ successCount: number; failureCount: number }> {
    let successCount = 0;
    let failureCount = 0;

    for (const userId of userIds) {
      const success = await this.send(userId, type, variables);
      if (success) {
        successCount++;
      } else {
        failureCount++;
      }
    }

    return { successCount, failureCount };
  }

  /**
   * Get user's FCM token
   * TODO: Implement actual token storage
   */
  private async getUserFCMToken(userId: string): Promise<string | null> {
    // Mock implementation
    // In production, this would fetch from user preferences or device table
    return `mock_fcm_token_${userId}`;
  }

  /**
   * Get user's notification preferences
   * TODO: Implement actual preferences storage
   */
  private async getUserPreferences(
    userId: string,
  ): Promise<NotificationPreferences> {
    // Mock implementation
    // In production, this would fetch from user preferences table
    return {
      dailyReminder: true,
      streakReminder: true,
      badgeNotifications: true,
      groupNotifications: true,
      weeklyReport: true,
    };
  }

  /**
   * Check if notification should be sent based on user preferences
   */
  private shouldSendNotification(
    type: NotificationType,
    preferences: NotificationPreferences,
  ): boolean {
    switch (type) {
      case NotificationType.STREAK_REMINDER:
      case NotificationType.STREAK_AT_RISK:
        return preferences.streakReminder;
      case NotificationType.BADGE_EARNED:
      case NotificationType.LEVEL_UP:
      case NotificationType.CHALLENGE_COMPLETED:
        return preferences.badgeNotifications;
      case NotificationType.GROUP_INVITATION:
        return preferences.groupNotifications;
      case NotificationType.WEEKLY_REPORT:
        return preferences.weeklyReport;
      default:
        return true;
    }
  }

  /**
   * Store notification in history
   * TODO: Implement actual notification history storage
   */
  private async storeNotification(
    userId: string,
    type: NotificationType,
    notification: any,
  ): Promise<void> {
    // Mock implementation
    // In production, this would store in notification_history table
    console.log(`Stored notification for user ${userId}:`, {
      type,
      title: notification.title,
      body: notification.body,
    });
  }

  /**
   * Mark notification as read
   * TODO: Implement when notification history is added
   */
  async markAsRead(notificationId: string): Promise<void> {
    // Mock implementation
    console.log(`Marked notification ${notificationId} as read`);
  }

  /**
   * Get user's notification history
   * TODO: Implement when notification history is added
   */
  async getHistory(userId: string, limit = 20): Promise<any[]> {
    // Mock implementation
    return [];
  }
}
