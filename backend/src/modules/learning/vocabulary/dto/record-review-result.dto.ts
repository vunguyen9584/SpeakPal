import { IsString, IsNumber, IsArray, ValidateNested, IsBoolean } from 'class-validator';
import { Type } from 'class-transformer';
import { ApiProperty } from '@nestjs/swagger';

class QuizAnswerDto {
    @ApiProperty({ description: 'Question ID' })
    @IsString()
    questionId: string;

    @ApiProperty({ description: 'User answer' })
    @IsString()
    userAnswer: string;

    @ApiProperty({ description: 'Whether the answer is correct' })
    @IsBoolean()
    correct: boolean;
}

export class RecordReviewResultDto {
    @ApiProperty({ description: 'Quiz ID' })
    @IsString()
    quizId: string;

    @ApiProperty({ description: 'Score (0-100)' })
    @IsNumber()
    score: number;

    @ApiProperty({ description: 'Number of correct answers' })
    @IsNumber()
    correctAnswers: number;

    @ApiProperty({ description: 'Total number of questions' })
    @IsNumber()
    totalQuestions: number;

    @ApiProperty({ description: 'Time spent in seconds' })
    @IsNumber()
    timeSpent: number;

    @ApiProperty({ description: 'Array of answers', type: [QuizAnswerDto] })
    @IsArray()
    @ValidateNested({ each: true })
    @Type(() => QuizAnswerDto)
    answers: QuizAnswerDto[];
}
