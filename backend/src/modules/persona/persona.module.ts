import { Module } from '@nestjs/common';
import { PersonaController } from './persona.controller';
import { PersonaService } from './persona.service';
import { PersonaRepository } from './persona.repository';
import { PrismaModule } from '../../prisma/prisma.module';

@Module({
  imports: [PrismaModule],
  controllers: [PersonaController],
  providers: [PersonaService, PersonaRepository],
  exports: [PersonaService, PersonaRepository],
})
export class PersonaModule {}
