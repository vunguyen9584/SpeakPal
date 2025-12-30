import { IsString, IsEnum, MaxLength, IsNotEmpty } from 'class-validator';
import { Voice, Personality, Level } from '@prisma/client';

export class CreatePersonaDto {
  @IsNotEmpty({ message: 'Name is required' })
  @IsString()
  @MaxLength(50, { message: 'Name must not exceed 50 characters' })
  name: string;

  @IsNotEmpty({ message: 'Voice is required' })
  @IsEnum(Voice, { message: 'Invalid voice option' })
  voice: Voice;

  @IsNotEmpty({ message: 'Personality is required' })
  @IsEnum(Personality, { message: 'Invalid personality option' })
  personality: Personality;

  @IsNotEmpty({ message: 'Target level is required' })
  @IsEnum(Level, { message: 'Invalid target level' })
  targetLevel: Level;
}
