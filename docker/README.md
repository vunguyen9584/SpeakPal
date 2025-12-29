# Docker Setup for SpeakPal AI

This directory contains Docker configuration files for local development environment.

## Services

### PostgreSQL (Port 5432)
- **Image**: postgres:15
- **User**: speakpal_app
- **Password**: dev_password
- **Databases**:
  - speakpal_dev (development)
  - speakpal_test (testing)
- **Features**: UUID and crypto extensions enabled

### Redis (Port 6379)
- **Image**: redis:7-alpine
- **Max Memory**: 256MB
- **Policy**: allkeys-lru
- **Persistence**: AOF enabled

### MinIO (Ports 9000, 9001)
- **Image**: minio/minio
- **API Port**: 9000
- **Console Port**: 9001
- **Root User**: minioadmin
- **Root Password**: minioadmin
- **Purpose**: S3-compatible storage for local development

## Quick Start

### Start all services
```bash
docker-compose up -d
```

### Stop all services
```bash
docker-compose down
```

### View logs
```bash
docker-compose logs -f
```

### Check service health
```bash
docker ps --filter name=speakpal
```

## Service URLs

- **PostgreSQL**: `postgresql://speakpal_app:dev_password@localhost:5432/speakpal_dev`
- **Redis**: `redis://localhost:6379`
- **MinIO API**: `http://localhost:9000`
- **MinIO Console**: `http://localhost:9001`

## Data Persistence

All data is persisted in Docker volumes:
- `speakpal_postgres_data` - PostgreSQL data
- `speakpal_redis_data` - Redis data
- `speakpal_minio_data` - MinIO data

### Clean up volumes (WARNING: This deletes all data)
```bash
docker-compose down -v
```

## Troubleshooting

### Reset a specific service
```bash
docker-compose restart <service-name>
# Example: docker-compose restart postgres
```

### View service logs
```bash
docker-compose logs <service-name>
# Example: docker-compose logs redis
```

### Connect to PostgreSQL
```bash
docker exec -it speakpal-postgres psql -U speakpal_app -d speakpal_dev
```

### Connect to Redis CLI
```bash
docker exec -it speakpal-redis redis-cli
```

## Configuration Files

- `docker-compose.yml` - Main orchestration file
- `docker/postgres/init.sql` - PostgreSQL initialization script
- `docker/redis/redis.conf` - Redis configuration

## Health Checks

All services include health checks:
- **PostgreSQL**: pg_isready check every 10s
- **Redis**: redis-cli ping every 10s
- **MinIO**: HTTP health endpoint every 30s

Services will show as "healthy" once they pass their health checks.
