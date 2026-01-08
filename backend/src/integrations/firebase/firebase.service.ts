import {
  Injectable,
  UnauthorizedException,
  OnModuleInit,
  Logger,
} from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import * as admin from 'firebase-admin';

@Injectable()
export class FirebaseService implements OnModuleInit {
  private readonly logger = new Logger(FirebaseService.name);
  private app: admin.app.App;

  constructor(private configService: ConfigService) {}

  onModuleInit() {
    // Initialize Firebase Admin SDK
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const privateKey = this.configService
      .get<string>('FIREBASE_PRIVATE_KEY')
      ?.replace(/\\n/g, '\n'); // Handle escaped newlines
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');

    // Only initialize if credentials are provided
    if (projectId && privateKey && clientEmail) {
      this.app = admin.initializeApp({
        credential: admin.credential.cert({
          projectId,
          privateKey,
          clientEmail,
        }),
      });
      this.logger.log('Firebase Admin SDK initialized successfully');
    } else {
      this.logger.warn(
        'Firebase credentials not configured. OAuth login will not work.',
      );
    }
  }

  async verifyIdToken(idToken: string): Promise<admin.auth.DecodedIdToken> {
    if (!this.app) {
      throw new UnauthorizedException(
        'Firebase not configured. Please set up Firebase credentials.',
      );
    }

    try {
      const decodedToken = await this.app.auth().verifyIdToken(idToken);
      return decodedToken;
    } catch (error) {
      throw new UnauthorizedException('Invalid Firebase ID token');
    }
  }

  async getUser(uid: string): Promise<admin.auth.UserRecord> {
    if (!this.app) {
      throw new UnauthorizedException(
        'Firebase not configured. Please set up Firebase credentials.',
      );
    }

    try {
      return await this.app.auth().getUser(uid);
    } catch (error) {
      throw new UnauthorizedException('Firebase user not found');
    }
  }
}
