-- SpeakPal PostgreSQL Initialization Script
-- This script runs automatically when the container starts for the first time

-- Create test database
CREATE DATABASE speakpal_test;

-- Grant privileges to the app user on test database
GRANT ALL PRIVILEGES ON DATABASE speakpal_test TO speakpal_app;

-- Connect to dev database and setup extensions
\c speakpal_dev;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Connect to test database and setup extensions
\c speakpal_test;
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";
