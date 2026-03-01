# Apache Iceberg Table Format Setup with Ozone 

This folder provides the integration setup of iceberg with ozone

## Prerequisites
1. Start ``PostgreSQL`` service:
```bash 
docker compose -f ozone-postgres.yml up -d
```

2. Create ``iceberg_ozone`` database in PostgresSQL:
```bash 
docker exec -it ozone_pg_catalog psql -U admin -c "CREATE DATABASE iceberg_ozone;"
```

3. Start ``Apache Ozone`` services:
```bash 
docker compose -f ozone-compose.yml up -d
```

## Setup Instructions
1. Build the ``Ozone Spark image``:
```bash 
docker build -t ozone-spark-image .
```

2. Run ``Spark with Ozone``:
```bash 
docker run -it --network ozone_net ozone-spark-image
```

## Testing the Setup 
Once in the Spark SQL shell, test with these commands:
```bash 
-- Show available catalogs
SHOW CATALOGS;

-- Switch to ozone catalog
USE ozone_backend;

-- Create database(namespace)
CREATE DATABASE testdb;

-- Switch to testdb
USE testdb;

-- Create a test table
CREATE TABLE test_table (id BIGINT,name STRING,created_at TIMESTAMP,updated_at TIMESTAMP) USING ICEBERG;

-- Insert test data
INSERT INTO test_table VALUES (1, 'test1', current_timestamp(), current_timestamp()),(2, 'test2', current_timestamp(), current_timestamp());

-- Query the table
SELECT * FROM test_table;
```

Verify files are stored in ozone s3: 
```bash 
docker exec -it iceberg_ozone-s3g-1 ozone fs -ls -R ofs://om/s3v/warehouse/
```

## Troubleshooting
1. Network Issues: Ensure services are on the ``ozone_net`` network
2. Ozone s3 Connection: Ensure all Ozone services are running
3. Database Connection: Check PostgreSQL is running and iceberg_ozone database exists