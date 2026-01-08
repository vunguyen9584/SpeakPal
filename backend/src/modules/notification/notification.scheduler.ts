import { Injectable } from '@nestjs/common';
import { Cron, CronExpression } from '@nestjs/schedule';
import { NotificationService } from './notification.service';
import { NotificationType } from './notification.types';
import { PrismaService } from '../../prisma/prisma.service';

@Injectable()
export class NotificationScheduler {
    constructor(
        private readonly notificationService: NotificationService,
        private readonly prisma: PrismaService,
    ) { }

    /**
     * Send daily practice reminders at 19:00 UTC (7 PM)
     * Runs every day at 19:00
     */
    @Cron('0 19 * * *', {
        name: 'daily-practice-reminder',
        timeZone: 'UTC',
    })
    async sendDailyReminders() {
        console.log('Running daily practice reminders...');

        try {
            // Get users who haven't practiced today
            const usersWithoutActivity = await this.getUsersWithoutActivityToday();

            console.log(
                `Found ${usersWithoutActivity.length} users without activity today`,
            );

            // Send reminders
            const result = await this.notificationService.sendBatch(
                usersWithoutActivity,
                NotificationType.STREAK_REMINDER,
            );

            console.log(
                `Daily reminders sent: ${result.successCount} success, ${result.failureCount} failed`,
            );
        } catch (error) {
            console.error('Error sending daily reminders:', error);
        }
    }

    /**
     * Send streak at-risk reminders at 23:00 UTC (11 PM)
     * Runs every day at 23:00
     */
    @Cron('0 23 * * *', {
        name: 'streak-at-risk-reminder',
        timeZone: 'UTC',
    })
    async sendStreakAtRiskReminders() {
        console.log('Running streak at-risk reminders...');

        try {
            // Get users with active streaks who haven't practiced today
            const atRiskUsers = await this.getUsersWithStreakAtRisk();

            console.log(`Found ${atRiskUsers.length} users with streak at risk`);

            // Send urgent reminders
            const result = await this.notificationService.sendBatch(
                atRiskUsers,
                NotificationType.STREAK_AT_RISK,
            );

            console.log(
                `Streak at-risk reminders sent: ${result.successCount} success, ${result.failureCount} failed`,
            );
        } catch (error) {
            console.error('Error sending streak at-risk reminders:', error);
        }
    }

    /**
     * Send weekly reports every Monday at 09:00 UTC
     */
    @Cron('0 9 * * 1', {
        name: 'weekly-report',
        timeZone: 'UTC',
    })
    async sendWeeklyReports() {
        console.log('Running weekly reports...');

        try {
            // Get all active users
            const activeUsers = await this.getActiveUsers();

            console.log(`Sending weekly reports to ${activeUsers.length} users`);

            // Send weekly reports
            const result = await this.notificationService.sendBatch(
                activeUsers,
                NotificationType.WEEKLY_REPORT,
            );

            console.log(
                `Weekly reports sent: ${result.successCount} success, ${result.failureCount} failed`,
            );
        } catch (error) {
            console.error('Error sending weekly reports:', error);
        }
    }

    /**
     * Get users who haven't had any conversation today
     */
    private async getUsersWithoutActivityToday(): Promise<string[]> {
        const today = new Date();
        today.setUTCHours(0, 0, 0, 0);

        const usersWithActivity = await this.prisma.conversation.findMany({
            where: {
                startedAt: {
                    gte: today,
                },
            },
            select: {
                userId: true,
            },
            distinct: ['userId'],
        });

        const activeUserIds = new Set(usersWithActivity.map((c) => c.userId));

        // Get all users except those who were active today
        const allUsers = await this.prisma.user.findMany({
            where: {
                id: {
                    notIn: Array.from(activeUserIds),
                },
            },
            select: {
                id: true,
            },
        });

        return allUsers.map((u) => u.id);
    }

    /**
     * Get users with active streaks who haven't practiced today
     */
    private async getUsersWithStreakAtRisk(): Promise<string[]> {
        const today = new Date();
        today.setUTCHours(0, 0, 0, 0);

        // Get users with current streak > 0
        const streaks = await this.prisma.streak.findMany({
            where: {
                currentStreak: {
                    gt: 0,
                },
            },
            select: {
                userId: true,
            },
        });

        const userIdsWithStreak = streaks.map((s) => s.userId);

        // Get users who have practiced today
        const usersWithActivity = await this.prisma.conversation.findMany({
            where: {
                userId: {
                    in: userIdsWithStreak,
                },
                startedAt: {
                    gte: today,
                },
            },
            select: {
                userId: true,
            },
            distinct: ['userId'],
        });

        const activeUserIds = new Set(usersWithActivity.map((c) => c.userId));

        // Return users with streak who haven't practiced
        return userIdsWithStreak.filter((id) => !activeUserIds.has(id));
    }

    /**
     * Get active users (users who have logged in within last 30 days)
     */
    private async getActiveUsers(): Promise<string[]> {
        const thirtyDaysAgo = new Date();
        thirtyDaysAgo.setDate(thirtyDaysAgo.getDate() - 30);

        const users = await this.prisma.user.findMany({
            where: {
                lastLoginAt: {
                    gte: thirtyDaysAgo,
                },
            },
            select: {
                id: true,
            },
        });

        return users.map((u) => u.id);
    }
}
