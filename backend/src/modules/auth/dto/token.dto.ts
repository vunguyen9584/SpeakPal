import { IsString, IsNumber, ValidateNested } from 'class-validator';
import { Type } from 'class-transformer';

export class UserInfoDto {
  @IsString()
  id: string;

  @IsString()
  email: string;

  @IsString()
  username: string;

  @IsString()
  level: string;

  @IsNumber()
  totalXp: number;
}

export class TokenDto {
  @IsString()
  accessToken: string;

  @IsString()
  refreshToken: string;

  @IsNumber()
  expiresIn: number;

  @ValidateNested()
  @Type(() => UserInfoDto)
  user: UserInfoDto;
}
