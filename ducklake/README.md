# DuckLake Table Format Setup

DuckLake uses a host-based installation approach rather than containers.

## Prerequisites

1. Install DuckDB on your host system
2. Ensure the infrastructure services are running (`docker compose -f ../infra/minio-postgres.yaml up -d`)
3. Create the `ducklake` database in PostgreSQL

## Setup Instructions

### 1. Start DuckDB
```bash
duckdb
```

### 2. Install Required Extensions
```sql
-- Install necessary extensions
INSTALL https;
LOAD https;
INSTALL ducklake;
LOAD ducklake;
INSTALL postgres;
LOAD postgres;
```

### 3. Configure S3 Connection
```sql
-- Set S3/MinIO properties
SET s3_region='us-east-1';
SET s3_url_style='path';
SET s3_endpoint='localhost:9000';
SET s3_access_key_id='admin';
SET s3_secret_access_key='password';
SET s3_use_ssl=false;
```

### 4. Connect to Catalog
```sql
-- Attach DuckLake catalog (requires 'ducklake' database in PostgreSQL)
ATTACH 'ducklake:postgres:dbname=ducklake host=localhost user=admin password=password port=5431' AS mydl (DATA_PATH 's3://warehouse2');

-- Switch to DuckLake catalog
USE mydl;
```

## Testing the Setup
```sql
-- Create a test table
CREATE TABLE test_table (id INTEGER, name VARCHAR);

-- Insert test data
INSERT INTO test_table VALUES (1, 'test');

-- Query the table
SELECT * FROM test_table;
```

## Documentation
For more details, visit: https://ducklake.select/docs/stable/duckdb/introduction
    
