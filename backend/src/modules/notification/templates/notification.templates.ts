import { NotificationType, NotificationTemplate } from '../notification.types';

export const NOTIFICATION_TEMPLATES: Record<
  NotificationType,
  NotificationTemplate
> = {
  [NotificationType.STREAK_REMINDER]: {
    type: NotificationType.STREAK_REMINDER,
    title: "Don't forget to practice today!",
    body: 'Keep your streak alive! Practice for just 5 minutes.',
    data: { action: 'open_practice' },
  },
  [NotificationType.STREAK_AT_RISK]: {
    type: NotificationType.STREAK_AT_RISK,
    title: 'Your streak is at risk!',
    body: 'Only a few hours left! Complete a lesson to keep your streak.',
    data: { action: 'open_practice', urgent: 'true' },
  },
  [NotificationType.BADGE_EARNED]: {
    type: NotificationType.BADGE_EARNED,
    title: 'Congratulations!',
    body: 'You earned a new badge: {badgeName}',
    data: { action: 'open_badges' },
  },
  [NotificationType.LEVEL_UP]: {
    type: NotificationType.LEVEL_UP,
    title: 'Level Up!',
    body: 'You reached level {level}! Keep up the great work!',
    data: { action: 'open_profile' },
  },
  [NotificationType.WEEKLY_REPORT]: {
    type: NotificationType.WEEKLY_REPORT,
    title: 'Your weekly report is ready',
    body: 'Check out your progress this week!',
    data: { action: 'open_progress' },
  },
  [NotificationType.CHALLENGE_COMPLETED]: {
    type: NotificationType.CHALLENGE_COMPLETED,
    title: 'Challenge Completed!',
    body: 'You completed the {challengeName} challenge!',
    data: { action: 'open_challenges' },
  },
  [NotificationType.GROUP_INVITATION]: {
    type: NotificationType.GROUP_INVITATION,
    title: 'Group Invitation',
    body: '{userName} invited you to join {groupName}',
    data: { action: 'open_groups' },
  },
};

/**
 * Replace template variables with actual values
 */
export function renderTemplate(
  template: NotificationTemplate,
  variables: Record<string, string>,
): NotificationTemplate {
  let title = template.title;
  let body = template.body;

  // Replace variables in title and body
  Object.entries(variables).forEach(([key, value]) => {
    const placeholder = `{${key}}`;
    title = title.replace(placeholder, value);
    body = body.replace(placeholder, value);
  });

  return {
    ...template,
    title,
    body,
  };
}
