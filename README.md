# Table Formats - Exploration

This repository demonstrates how to easily use various table formats (Apache Iceberg, Apache Paimon, and DuckLake) in development and test environments.

## Quick Start

### 1. Start Infrastructure
```bash
cd infra
docker compose -f minio-postgres.yaml up -d
```

This starts:
- **PostgreSQL**: Catalog metadata storage (port 5431)
- **MinIO**: S3-compatible object storage (ports 9000-9001)
- **Network**: `infra_datanet` for service communication

All required databases (`iceberg`, `paimon`, `ducklake`) are automatically created.

### 2. Choose Your Table Format

#### Apache Iceberg
```bash
cd iceberg
# See README.md for detailed setup options (REST catalog or direct JDBC)
```

#### Apache Paimon
```bash
cd paimon
# See README.md for setup instructions
```

#### DuckLake
```bash
cd ducklake
# See README.md for host-based setup instructions
```

## Repository Structure

```
├── infra/                    # Shared infrastructure (PostgreSQL + MinIO)
│   ├── minio-postgres.yaml   # Docker Compose for services
│   └── init-databases.sql    # Database initialization script
├── iceberg/                  # Apache Iceberg setup
│   ├── README.md            # Detailed setup instructions
│   ├── rest-catalog-compose.yaml
│   ├── spark-iceberg-rest-dockerfile
│   └── spark-iceberg-postgres-dockerfile
├── paimon/                   # Apache Paimon setup  
│   ├── README.md            # Detailed setup instructions
│   └── spark-paimon-postgres-dockerfile
└── ducklake/                 # DuckLake setup
    └── README.md            # Detailed setup instructions
```

## Configuration Details

### Infrastructure Services
- **PostgreSQL**: `localhost:5431` (admin/password)
- **MinIO Console**: `localhost:9001` (admin/password)
- **MinIO S3 API**: `localhost:9000`

### Storage Warehouses
- **Iceberg**: `s3a://warehouse0/`
- **Paimon**: `s3a://warehouse1/`
- **DuckLake**: `s3a://warehouse2/`

## Getting Help

Each table format folder contains detailed README files with:
- Prerequisites and setup instructions
- Testing examples
- Configuration details
- Troubleshooting tips

For specific issues, refer to the individual README files in each folder.

