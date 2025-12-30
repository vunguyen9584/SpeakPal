import { IsString, IsIn } from 'class-validator';

export class OAuthDto {
  @IsString()
  idToken: string;

  @IsString()
  @IsIn(['google', 'apple'])
  provider: 'google' | 'apple';
}
