FROM apache/spark:3.5.6

# Version configuration
ENV SPARK_SCALA_VERSION=3.5_2.12
ENV ICEBERG_VERSION=1.9.1
ENV POSTGRES_VERSION=42.7.3

# Set working directory to Spark's jars folder
USER root
WORKDIR /opt/spark/jars

# Download necessary JARs from Maven Central
RUN curl -LO https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-spark-runtime-${SPARK_SCALA_VERSION}/${ICEBERG_VERSION}/iceberg-spark-runtime-${SPARK_SCALA_VERSION}-${ICEBERG_VERSION}.jar && \
    curl -LO https://repo1.maven.org/maven2/org/apache/iceberg/iceberg-aws-bundle/${ICEBERG_VERSION}/iceberg-aws-bundle-${ICEBERG_VERSION}.jar && \
    curl -LO https://repo1.maven.org/maven2/org/postgresql/postgresql/${POSTGRES_VERSION}/postgresql-${POSTGRES_VERSION}.jar

# Set environment variable for Spark shell
ENV HOME=/root

# Set Spark SQL as default command with Iceberg + JDBC + S3 configs
ENTRYPOINT ["/opt/spark/bin/spark-sql",\
    "--conf","spark.sql.extensions=org.apache.iceberg.spark.extensions.IcebergSparkSessionExtensions",\
    "--conf","spark.sql.defaultCatalog=ozone_backend",\
    "--conf","spark.sql.catalog.ozone_backend=org.apache.iceberg.spark.SparkCatalog",\
    "--conf","spark.sql.catalog.ozone_backend.catalog-impl=org.apache.iceberg.jdbc.JdbcCatalog",\
    "--conf","spark.sql.catalog.ozone_backend.uri=jdbc:postgresql://ozone-db:5432/iceberg_ozone",\
    "--conf","spark.sql.catalog.ozone_backend.jdbc.user=admin",\
    "--conf","spark.sql.catalog.ozone_backend.jdbc.password=password",\
    "--conf","spark.sql.catalog.ozone_backend.warehouse=s3://warehouse/",\
    "--conf","spark.sql.catalog.ozone_backend.io-impl=org.apache.iceberg.aws.s3.S3FileIO",\
    "--conf","spark.sql.catalog.ozone_backend.s3.endpoint=http://warehouse.s3.ozone:9878",\
    "--conf","spark.sql.catalog.ozone_backend.s3.access-key-id=admin",\
    "--conf","spark.sql.catalog.ozone_backend.s3.secret-access-key=password",\
    "--conf","spark.sql.catalog.ozone_backend.s3.path-style-access=true",\
    "--conf","spark.sql.catalog.ozone_backend.s3.region=us-east-1",\
    "--conf","spark.driver.extraJavaOptions=-Daws.region=us-east-1",\
    "--conf","spark.executor.extraJavaOptions=-Daws.region=us-east-1"]