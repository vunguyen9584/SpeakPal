export enum NotificationType {
  STREAK_REMINDER = 'streak_reminder',
  STREAK_AT_RISK = 'streak_at_risk',
  BADGE_EARNED = 'badge_earned',
  LEVEL_UP = 'level_up',
  WEEKLY_REPORT = 'weekly_report',
  CHALLENGE_COMPLETED = 'challenge_completed',
  GROUP_INVITATION = 'group_invitation',
}

export interface NotificationTemplate {
  type: NotificationType;
  title: string;
  body: string;
  data?: Record<string, any>;
}

export interface FCMNotification {
  title: string;
  body: string;
  data?: Record<string, any>;
}

export interface NotificationPreferences {
  dailyReminder: boolean;
  streakReminder: boolean;
  badgeNotifications: boolean;
  groupNotifications: boolean;
  weeklyReport: boolean;
}
