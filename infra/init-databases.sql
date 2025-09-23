-- Initialize databases for different table formats
-- This script runs automatically when PostgreSQL container starts

-- Create databases if they don't exist
SELECT 'CREATE DATABASE iceberg'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'iceberg')\gexec

SELECT 'CREATE DATABASE paimon'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'paimon')\gexec

SELECT 'CREATE DATABASE ducklake'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'ducklake')\gexec

-- Grant permissions to admin user for all databases (safe to run multiple times)
\c iceberg
GRANT ALL PRIVILEGES ON DATABASE iceberg TO admin;

\c paimon  
GRANT ALL PRIVILEGES ON DATABASE paimon TO admin;

\c ducklake
GRANT ALL PRIVILEGES ON DATABASE ducklake TO admin;

\c postgres