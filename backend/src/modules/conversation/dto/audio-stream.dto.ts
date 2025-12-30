import { IsString, IsNumber, IsBoolean, IsOptional } from 'class-validator';

export class AudioStreamDto {
  @IsString()
  chunk: string; // Base64 encoded audio

  @IsNumber()
  sequence: number;

  @IsNumber()
  @IsOptional()
  sampleRate?: number;

  @IsNumber()
  @IsOptional()
  channels?: number;

  @IsBoolean()
  @IsOptional()
  isFinal?: boolean;
}
