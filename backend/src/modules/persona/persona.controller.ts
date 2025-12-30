import {
  Controller,
  Get,
  Post,
  Put,
  Delete,
  Body,
  Param,
  UseGuards,
  HttpCode,
  HttpStatus,
} from '@nestjs/common';
import { PersonaService } from './persona.service';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { CurrentUser } from '../auth/decorators/current-user.decorator';
import { CreatePersonaDto } from './dto/create-persona.dto';
import { UpdatePersonaDto } from './dto/update-persona.dto';
import { PersonaDto } from './dto/persona-response.dto';

@Controller('personas')
@UseGuards(JwtAuthGuard)
export class PersonaController {
  constructor(private readonly personaService: PersonaService) {}

  @Get()
  async findAll(
    @CurrentUser() user: { userId: string },
  ): Promise<PersonaDto[]> {
    return this.personaService.findAll(user.userId);
  }

  @Post()
  @HttpCode(HttpStatus.CREATED)
  async create(
    @CurrentUser() user: { userId: string },
    @Body() dto: CreatePersonaDto,
  ): Promise<PersonaDto> {
    return this.personaService.create(user.userId, dto);
  }

  @Get(':id')
  async findById(
    @CurrentUser() user: { userId: string },
    @Param('id') id: string,
  ): Promise<PersonaDto> {
    return this.personaService.findById(user.userId, id);
  }

  @Put(':id')
  async update(
    @CurrentUser() user: { userId: string },
    @Param('id') id: string,
    @Body() dto: UpdatePersonaDto,
  ): Promise<PersonaDto> {
    return this.personaService.update(user.userId, id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async delete(
    @CurrentUser() user: { userId: string },
    @Param('id') id: string,
  ): Promise<void> {
    return this.personaService.delete(user.userId, id);
  }

  @Put(':id/default')
  async setDefault(
    @CurrentUser() user: { userId: string },
    @Param('id') id: string,
  ): Promise<PersonaDto> {
    return this.personaService.setDefault(user.userId, id);
  }
}
