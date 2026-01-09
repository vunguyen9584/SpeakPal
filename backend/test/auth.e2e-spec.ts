import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { createTestingModule } from './test-helper.module';

describe('AuthModule (e2e)', () => {
  let app: INestApplication;
  let authToken: string;
  let refreshToken: string;

  const testUser = {
    email: `test_e2e_${Date.now()}@example.com`,
    password: 'Password123!',
    username: `testuser_${Date.now()}`,
  };

  beforeAll(async () => {
    const moduleFixture = await createTestingModule().compile();
    app = moduleFixture.createNestApplication();
    await app.init();
  });

  afterAll(async () => {
    if (app) {
      await app.close();
    }
  });

  describe('/auth/register (POST)', () => {
    it('should register a new user', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send(testUser)
        .expect(201)
        .expect((res) => {
          expect(res.body).toHaveProperty('accessToken');
          expect(res.body).toHaveProperty('refreshToken');
          expect(res.body).toHaveProperty('user');
          expect(res.body.user.email).toBe(testUser.email);
          expect(res.body.user.username).toBe(testUser.username);

          authToken = res.body.accessToken;
          refreshToken = res.body.refreshToken;
        });
    });

    it('should fail if email already exists', () => {
      return request(app.getHttpServer())
        .post('/auth/register')
        .send(testUser)
        .expect(409); // Conflict
    });
  });

  describe('/auth/login (POST)', () => {
    it('should login with valid credentials', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: testUser.email,
          password: testUser.password,
        })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('accessToken');
          expect(res.body).toHaveProperty('refreshToken');
          authToken = res.body.accessToken;
        });
    });

    it('should fail with invalid credentials', () => {
      return request(app.getHttpServer())
        .post('/auth/login')
        .send({
          email: testUser.email,
          password: 'WrongPassword!',
        })
        .expect(401);
    });
  });

  describe('/auth/refresh (POST)', () => {
    it('should refresh tokens', () => {
      return request(app.getHttpServer())
        .post('/auth/refresh')
        .send({ refreshToken })
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('accessToken');
          expect(res.body).toHaveProperty('refreshToken');
          authToken = res.body.accessToken; // Update with new token
          refreshToken = res.body.refreshToken;
        });
    });
  });

  describe('/users/me (GET)', () => {
    it('should get current user profile', () => {
      return request(app.getHttpServer())
        .get('/users/me')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.email).toBe(testUser.email);
        });
    });

    it('should fail without token', () => {
      return request(app.getHttpServer()).get('/users/me').expect(401);
    });
  });

  describe('/auth/logout (POST)', () => {
    it('should logout successfully', () => {
      return request(app.getHttpServer())
        .post('/auth/logout')
        .set('Authorization', `Bearer ${authToken}`)
        .send({ refreshToken })
        .expect(204);
    });
  });
});
