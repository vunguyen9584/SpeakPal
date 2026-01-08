import { Test, TestingModule } from '@nestjs/testing';
import { INestApplication } from '@nestjs/common';
import request from 'supertest';
import { AppModule } from './../src/app.module';

describe('UserModule (e2e)', () => {
  let app: INestApplication;
  let authToken: string;

  const testUser = {
    email: `test_user_e2e_${Date.now()}@example.com`,
    password: 'Password123!',
    username: `testuser_${Date.now()}`,
  };

  beforeAll(async () => {
    const moduleFixture: TestingModule = await Test.createTestingModule({
      imports: [AppModule],
    }).compile();

    app = moduleFixture.createNestApplication();
    await app.init();

    // Register a user to get a token
    const res = await request(app.getHttpServer())
      .post('/auth/register')
      .send(testUser)
      .expect(201);

    authToken = res.body.accessToken;
  });

  afterAll(async () => {
    await app.close();
  });

  describe('/users/me (GET)', () => {
    it('should return profile information', () => {
      return request(app.getHttpServer())
        .get('/users/me')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body.email).toBe(testUser.email);
          expect(res.body.username).toBe(testUser.username);
          expect(res.body).toHaveProperty('level');
          expect(res.body).toHaveProperty('totalXp');
        });
    });
  });

  describe('/users/me (PUT)', () => {
    it('should update profile successfully', () => {
      const updateData = {
        username: 'updated_user_name',
        aiSpeed: 1.5,
      };

      return request(app.getHttpServer())
        .put('/users/me')
        .set('Authorization', `Bearer ${authToken}`)
        .send(updateData)
        .expect(200)
        .expect((res) => {
          expect(res.body.username).toBe(updateData.username);
        });
    });

    it('should validate update data', () => {
      return request(app.getHttpServer())
        .put('/users/me')
        .set('Authorization', `Bearer ${authToken}`)
        .send({
          aiSpeed: 5.0, // Invalid value (max 2.0)
        })
        .expect(400);
    });
  });

  describe('/users/me/stats (GET)', () => {
    it('should return user statistics', () => {
      return request(app.getHttpServer())
        .get('/users/me/stats')
        .set('Authorization', `Bearer ${authToken}`)
        .expect(200)
        .expect((res) => {
          expect(res.body).toHaveProperty('currentLevel');
          expect(res.body).toHaveProperty('totalXp');
          expect(res.body).toHaveProperty('dailyStreak');
        });
    });
  });
});
