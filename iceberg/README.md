# Apache Iceberg Table Format Setup

Apache Iceberg supports multiple catalog configurations. This folder provides two deployment options:

## Deployment Options

### Option 1: REST Catalog (Recommended)
Uses the Iceberg REST catalog with PostgreSQL backend for metadata storage.

**Files:**
- `rest-catalog-compose.yaml` - REST catalog service configuration
- `spark-iceberg-rest-dockerfile` - Spark with REST catalog integration

### Option 2: Direct JDBC Catalog
Connects Spark directly to PostgreSQL for metadata storage.

**Files:**
- `spark-iceberg-postgres-dockerfile` - Spark with direct JDBC catalog

## Prerequisites

1. Start infrastructure services:
   ```bash
   docker compose -f ../infra/minio-postgres.yaml up -d
   ```

2. Create the `iceberg` database in PostgreSQL (optional - auto-created):
   ```bash
   docker exec -it iceberg_pg_catalog psql -U admin -d postgres -c "CREATE DATABASE iceberg;"
   ```

## Setup Instructions

### Option 1: REST Catalog Setup

1. **Start the REST catalog service:**
   ```bash
   docker compose -f rest-catalog-compose.yaml up -d
   ```

2. **Build and run Spark with REST catalog:**
   ```bash
   docker build -f spark-iceberg-rest-dockerfile -t spark-iceberg-rest .
   docker run -it --network infra_datanet spark-iceberg-rest
   ```

### Option 2: Direct JDBC Setup

1. **Build and run Spark with JDBC catalog:**
   ```bash
   docker build -f spark-iceberg-postgres-dockerfile -t spark-iceberg-jdbc .
   docker run -it --network infra_datanet spark-iceberg-jdbc
   ```

## Testing the Setup

Once in the Spark SQL shell, test with these commands:

```sql
-- Show available catalogs
SHOW CATALOGS;

-- Create a test table
CREATE TABLE rest_backend.default.test_table (
    id BIGINT,
    name STRING,
    created_at TIMESTAMP
) USING ICEBERG;

-- Insert test data
INSERT INTO rest_backend.default.test_table VALUES 
(1, 'test1', current_timestamp()),
(2, 'test2', current_timestamp());

-- Query the table
SELECT * FROM rest_backend.default.test_table;

-- Show table metadata
DESCRIBE EXTENDED rest_backend.default.test_table;
```

## Configuration Details

### Warehouse Locations
- **Storage**: MinIO S3-compatible storage at `s3a://warehouse0/`
- **Endpoint**: `http://minio:9000`
- **Credentials**: admin/password

### Catalog Configuration
- **REST Catalog**: Available at `http://rest-catalog:8181`
- **JDBC URL**: `jdbc:postgresql://catalog-db:5432/iceberg` (internal) / `localhost:5431` (external)
- **Database Credentials**: admin/password

## Troubleshooting

1. **Network Issues**: Ensure all services are on the `infra_datanet` network
2. **S3 Connection**: Verify MinIO is accessible and credentials are correct
3. **Database Connection**: Check PostgreSQL is running and database exists
4. **REST Catalog**: Confirm the REST service is healthy at port 8181

## Documentation
- [Apache Iceberg Documentation](https://iceberg.apache.org/)
- [Iceberg Spark Integration](https://iceberg.apache.org/docs/latest/spark/)