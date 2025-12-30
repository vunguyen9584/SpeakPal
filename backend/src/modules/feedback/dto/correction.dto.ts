import { IsString } from 'class-validator';

export class CorrectionDto {
  @IsString()
  type: string;

  @IsString()
  original: string;

  @IsString()
  corrected: string;

  @IsString()
  explanation: string;

  @IsString()
  severity: string;
}
