import { Injectable } from '@nestjs/common';
import { PrismaService } from '../../../prisma/prisma.service';
import { RecordReviewResultDto } from '../vocabulary/dto/record-review-result.dto';

@Injectable()
export class ReviewService {
    constructor(private readonly prisma: PrismaService) { }

    async recordQuizResult(userId: string, dto: RecordReviewResultDto) {
        // Calculate XP earned based on score
        const xpEarned = Math.floor((dto.score / 100) * 50); // Max 50 XP per quiz

        // Update user's total XP
        await this.prisma.user.update({
            where: { id: userId },
            data: {
                totalXp: {
                    increment: xpEarned,
                },
            },
        });

        // Store quiz result (you may want to create a QuizResult table)
        // For now, we'll just return the result
        return {
            success: true,
            xpEarned,
            score: dto.score,
            correctAnswers: dto.correctAnswers,
            totalQuestions: dto.totalQuestions,
            message: `Great job! You earned ${xpEarned} XP`,
        };
    }
}
