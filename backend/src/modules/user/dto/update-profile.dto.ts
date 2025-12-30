import { IsOptional, IsString, MinLength, MaxLength, Matches, IsNumber, Min, Max, IsBoolean } from 'class-validator';

export class UpdateProfileDto {
  @IsOptional()
  @IsString()
  @MinLength(3, { message: 'Username must be at least 3 characters long' })
  @MaxLength(50, { message: 'Username must not exceed 50 characters' })
  @Matches(/^[a-zA-Z0-9_]+$/, {
    message: 'Username must contain only alphanumeric characters and underscores',
  })
  username?: string;

  @IsOptional()
  @IsNumber()
  @Min(0.5, { message: 'AI speed must be at least 0.5' })
  @Max(2.0, { message: 'AI speed must not exceed 2.0' })
  aiSpeed?: number;

  @IsOptional()
  @IsBoolean()
  confirmationMode?: boolean;
}
