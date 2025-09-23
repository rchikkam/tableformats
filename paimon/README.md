# Apache Paimon Table Format Setup

Apache Paimon is a streaming data lake platform that supports both batch and streaming workloads.

## Prerequisites

1. Start infrastructure services:
   ```bash
   docker compose -f ../infra/minio-postgres.yaml up -d
   ```

2. Create the `paimon` database in PostgreSQL (optional - auto-created):
   ```bash
   docker exec -it iceberg_pg_catalog psql -U admin -d postgres -c "CREATE DATABASE paimon;"
   ```

## Setup Instructions

1. **Build the Paimon Spark image:**
   ```bash
   docker build -f spark-paimon-postgres-dockerfile -t spark-paimon .
   ```

2. **Run Spark with Paimon:**
   ```bash
   docker run -it --network infra_datanet spark-paimon
   ```

## Testing the Setup

Once in the Spark SQL shell, test with these commands:

```sql
-- Show available catalogs
SHOW CATALOGS;

-- Switch to Paimon catalog
USE paimon;

-- Create a test table
CREATE TABLE default.test_table (
    id BIGINT,
    name STRING,
    created_at TIMESTAMP,
    updated_at TIMESTAMP
) USING PAIMON
TBLPROPERTIES (
    'primary-key' = 'id',
    'bucket' = '2'
);

-- Insert test data
INSERT INTO default.test_table VALUES 
(1, 'test1', current_timestamp(), current_timestamp()),
(2, 'test2', current_timestamp(), current_timestamp());

-- Query the table
SELECT * FROM default.test_table;

-- Update data (Paimon supports UPSERT)
INSERT INTO default.test_table VALUES 
(1, 'updated_test1', current_timestamp(), current_timestamp());

-- Query again to see the update
SELECT * FROM default.test_table ORDER BY id;

-- Show table properties
SHOW TBLPROPERTIES default.test_table;
```

## Configuration Details

### Warehouse Location
- **Storage**: MinIO S3-compatible storage at `s3a://warehouse1/`
- **Endpoint**: `http://minio:9000`
- **Credentials**: admin/password

### Catalog Configuration
- **Type**: JDBC catalog
- **Database**: PostgreSQL at `catalog-db:5432/paimon` (internal) / `localhost:5431` (external)
- **Credentials**: admin/password

### Paimon Features
- **Primary Keys**: Supports primary key constraints for UPSERT operations
- **Bucketing**: Data organization for better performance
- **Schema Evolution**: Supports adding/dropping columns
- **Time Travel**: Query historical data snapshots

## Advanced Usage

### Creating Partitioned Tables
```sql
CREATE TABLE default.partitioned_table (
    id BIGINT,
    name STRING,
    date_col DATE,
    created_at TIMESTAMP
) USING PAIMON
PARTITIONED BY (date_col)
TBLPROPERTIES (
    'primary-key' = 'id,date_col',
    'bucket' = '4'
);
```

### Time Travel Queries
```sql
-- Query table at specific snapshot
SELECT * FROM default.test_table /*+ OPTIONS('scan.snapshot-id' = '1') */;

-- Query table at specific timestamp
SELECT * FROM default.test_table /*+ OPTIONS('scan.timestamp-millis' = '1640995200000') */;
```

## Troubleshooting

1. **Network Issues**: Ensure containers are on the `infra_datanet` network
2. **S3 Connection**: Verify MinIO accessibility and credentials
3. **Database Connection**: Check PostgreSQL is running and `paimon` database exists
4. **Primary Key Violations**: Ensure primary key constraints are respected in UPSERT operations

## Documentation
- [Apache Paimon Documentation](https://paimon.apache.org/)
- [Paimon Spark Integration](https://paimon.apache.org/docs/master/engines/spark/)