import { Controller, Post, Body, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../../common/decorators/current-user.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { RecordReviewResultDto } from '../vocabulary/dto/record-review-result.dto';
import { ReviewService } from './review.service';

@ApiTags('Learning - Review')
@ApiBearerAuth()
@Controller('learning/review')
@UseGuards(JwtAuthGuard)
export class ReviewController {
    constructor(private readonly reviewService: ReviewService) { }

    @Post('result')
    @ApiOperation({ summary: 'Record review quiz result' })
    async recordResult(
        @CurrentUser('userId') userId: string,
        @Body() dto: RecordReviewResultDto,
    ) {
        return this.reviewService.recordQuizResult(userId, dto);
    }
}
