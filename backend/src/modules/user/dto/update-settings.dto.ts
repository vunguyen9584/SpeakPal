import { IsOptional, IsNumber, Min, Max, IsBoolean } from 'class-validator';

export class UpdateSettingsDto {
  @IsOptional()
  @IsNumber()
  @Min(0.5, { message: 'AI speed must be at least 0.5' })
  @Max(2.0, { message: 'AI speed must not exceed 2.0' })
  aiSpeed?: number;

  @IsOptional()
  @IsBoolean()
  confirmationMode?: boolean;
}
