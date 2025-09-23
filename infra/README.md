# Infrastructure Setup

This folder provides the shared infrastructure services for all table formats.

## Services Overview

| Service | Internal Name | Container Name | Purpose |
|---------|---------------|----------------|---------|
| PostgreSQL | `catalog-db` | `iceberg_pg_catalog` | Metadata storage for all catalogs |
| MinIO | `minio` | `iceberg_minio` | S3-compatible object storage |
| Bucket Helper | - | `mc_helper` | Creates storage buckets |

## Naming Convention

Following the lakewatch pattern:
- **Service names** (`catalog-db`, `minio`) are used for internal Docker network communication
- **Container names** (`iceberg_pg_catalog`, `iceberg_minio`) are used for external access via `docker exec` etc.

## Quick Start

```bash
# Start all infrastructure services
docker compose -f minio-postgres.yaml up -d

# Verify services are running
docker ps

# Access PostgreSQL externally
docker exec -it iceberg_pg_catalog psql -U admin -d postgres

# Access MinIO console
open http://localhost:9001
```

## Configuration

### PostgreSQL
- **Host**: `localhost:5431` (external) / `catalog-db:5432` (internal)
- **Credentials**: admin/password
- **Auto-created databases**: `iceberg`, `paimon`, `ducklake`

### MinIO
- **S3 API**: `localhost:9000` (external) / `minio:9000` (internal)  
- **Console**: `localhost:9001` (external)
- **Credentials**: admin/password
- **Auto-created buckets**: `warehouse0` through `warehouse4`

### Docker Network
- **Name**: `infra_datanet`
- **Type**: Bridge network for service communication

## Database Initialization

The `init-databases.sql` script automatically creates required databases when PostgreSQL starts:
- `iceberg` - For Apache Iceberg metadata
- `paimon` - For Apache Paimon metadata  
- `ducklake` - For DuckLake metadata

## Troubleshooting

1. **Port conflicts**: Ensure ports 5431, 9000, and 9001 are available
2. **Network issues**: Verify `infra_datanet` network exists
3. **Database access**: Check if databases were created properly
4. **Storage access**: Verify MinIO buckets were created

## Cleanup

```bash
# Stop all services
docker compose -f minio-postgres.yaml down

# Remove volumes (WARNING: deletes all data)
docker compose -f minio-postgres.yaml down -v
```