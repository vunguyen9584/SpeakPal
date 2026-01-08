import {
  Controller,
  Get,
  Post,
  Body,
  Param,
  Query,
  Delete,
  UseGuards,
} from '@nestjs/common';
import { VocabularyService } from './vocabulary.service';
import { CreateVocabularyDto } from './dto/create-vocabulary.dto';
import { VocabularyQueryDto } from './dto/vocabulary-query.dto';
import { ReviewRequestDto } from './dto/review-request.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../../../common/decorators/current-user.decorator';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Learning - Vocabulary')
@ApiBearerAuth()
@Controller('vocabularies')
@UseGuards(JwtAuthGuard)
export class VocabularyController {
  constructor(private readonly vocabularyService: VocabularyService) {}

  @Get()
  @ApiOperation({ summary: 'List user vocabulary' })
  async list(
    @CurrentUser('id') userId: string,
    @Query() query: VocabularyQueryDto,
  ) {
    return this.vocabularyService.listByUser(userId, query);
  }

  @Post()
  @ApiOperation({ summary: 'Add new vocabulary' })
  async create(
    @CurrentUser('id') userId: string,
    @Body() dto: CreateVocabularyDto,
  ) {
    return this.vocabularyService.addWord(userId, dto);
  }

  @Get('due')
  @ApiOperation({ summary: 'Get vocabulary due for review' })
  async getDue(@CurrentUser('id') userId: string) {
    return this.vocabularyService.getDueForReview(userId);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get vocabulary by ID' })
  async getById(@CurrentUser('id') userId: string, @Param('id') id: string) {
    return this.vocabularyService.getById(userId, id);
  }

  @Post(':id/review')
  @ApiOperation({ summary: 'Record review result' })
  async recordReview(
    @CurrentUser('id') userId: string,
    @Param('id') id: string,
    @Body() dto: ReviewRequestDto,
  ) {
    return this.vocabularyService.recordReview(userId, id, dto.result);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Delete vocabulary' })
  async delete(@CurrentUser('id') userId: string, @Param('id') id: string) {
    await this.vocabularyService.deleteWord(userId, id);
    return { message: 'Vocabulary deleted successfully' };
  }
}
