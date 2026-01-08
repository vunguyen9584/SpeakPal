import { Controller, Get, Param, Query, UseGuards } from '@nestjs/common';
import { ScenarioService } from './scenario.service';
import { ScenarioQueryDto } from './dto/scenario-query.dto';
import { JwtAuthGuard } from '../../auth/guards/jwt-auth.guard';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';

@ApiTags('Learning - Scenarios')
@ApiBearerAuth()
@Controller('scenarios')
@UseGuards(JwtAuthGuard)
export class ScenarioController {
  constructor(private readonly scenarioService: ScenarioService) {}

  @Get()
  @ApiOperation({ summary: 'List scenarios with filters' })
  async list(@Query() query: ScenarioQueryDto) {
    return this.scenarioService.list(query);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get scenario detail' })
  async getById(@Param('id') id: string) {
    return this.scenarioService.getById(id);
  }
}
