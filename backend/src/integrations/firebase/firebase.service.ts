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
  private app: admin.app.App | null = null;
  private initialized = false;

  constructor(private configService: ConfigService) { }

  onModuleInit() {
    // Check if already initialized by another service (e.g., FCMService)
    if (admin.apps.length > 0) {
      this.app = admin.apps[0] as admin.app.App;
      this.initialized = true;
      this.logger.log('Using existing Firebase Admin SDK instance');
      return;
    }

    // Get Firebase credentials from environment
    const projectId = this.configService.get<string>('FIREBASE_PROJECT_ID');
    const privateKey = this.configService
      .get<string>('FIREBASE_PRIVATE_KEY')
      ?.replace(/\\n/g, '\n'); // Handle escaped newlines
    const clientEmail = this.configService.get<string>('FIREBASE_CLIENT_EMAIL');

    // Only initialize if ALL credentials are provided and non-empty
    if (
      projectId &&
      projectId.trim().length > 0 &&
      privateKey &&
      privateKey.trim().length > 0 &&
      clientEmail &&
      clientEmail.trim().length > 0
    ) {
      try {
        this.app = admin.initializeApp({
          credential: admin.credential.cert({
            projectId,
            privateKey,
            clientEmail,
          }),
        });
        this.initialized = true;
        this.logger.log('Firebase Admin SDK initialized successfully');
      } catch (error) {
        this.logger.error(
          `Failed to initialize Firebase Admin SDK: ${(error as Error).message}`,
        );
        this.initialized = false;
      }
    } else {
      this.logger.warn(
        'Firebase credentials not configured. OAuth login will not work.',
      );
      this.initialized = false;
    }
  }

  /**
   * Check if Firebase is properly initialized
   */
  isAvailable(): boolean {
    return this.initialized && this.app !== null;
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
    } catch {
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
    } catch {
      throw new UnauthorizedException('Firebase user not found');
    }
  }
}
