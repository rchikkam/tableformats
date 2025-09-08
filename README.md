# Tableformats - Exploration
This is the repo for how to easily use tableformats on dev/test environments.

This is organized into multiple folders.
    infra folder contains a bare minimum minio + posgres docker compose file. You would normally not needing to deploy this often.

        Bring up the infra 
            docker compose -f ./minio-postgres.yml up -d

        Use the following command to get the network name. This may be named as infra_datanet.
            docker network ls 

    paimon folder contains a dockerfile to create paimon related images.

        Create spark-sql image that use paimon as tableformat and can connect to infra.

            docker build -t <image-name> -f spark-paimon-dockerfile . 
        
        Create a database to hold paimon catalog info. (iceberg is also password)
            psql -h localhost -p 5432 -U iceberg -d iceberg

            create database paimondb;

            
        Start a container to connect to the infra 
        
            docker run -it --network <network_name> <image_name>

        Please refer the following to explore paimon
            https://paimon.apache.org/docs/master/spark/quick-start

    iceberg folder contains a docker file to create iceberg related images.

        Create spark-sql image that use iceberg as table format and can connect to infra.
        
            docker build -t <image-name> 0f spark-iceberg-dockerfile .

        Create a database to hold iceberg catalog info. (iceberg is also password)
            psql -h localhost -p 5432 -U icenerg -d iceberg
    
            create database iceberg;

        Start a container to connect to the infra
            docker run -it --network <network_name> <image_name>

        Please refer the following to explore iceberg
            https://iceberg.apache.org/docs/1.9.1/spark-getting-started/

 
