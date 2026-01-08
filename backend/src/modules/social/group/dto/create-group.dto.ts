import {
  IsString,
  IsOptional,
  IsBoolean,
  Length,
  MaxLength,
} from 'class-validator';

export class CreateGroupDto {
  @IsString()
  @Length(3, 50)
  name: string;

  @IsOptional()
  @IsString()
  @MaxLength(200)
  description?: string;


}
