# Tableformats - Exploration
This is the repo for how to easily use tableformats on dev/test environments.

This is organized into multiple folders.

infra folder contains a bare minimum minio + posgres docker compose file. You would normally not needing to deploy this often.

    #Bring up the infra 
        docker compose -f ./minio-postgres.yml up -d

    #Use the following command to get the network name. This may be named as infra_datanet.
        docker network ls 

paimon folder contains a dockerfile(s) to create paimon related images.

    #Create spark-sql that use paimon as tableformat and can connect to infra.
        docker build -t <image-name> -f spark-paimon-dockerfile . 
        
    #Create a database to hold paimon catalog info. (iceberg is also password)
        psql -h localhost -p 5430 -U iceberg -d iceberg
        create database paimondb;
            
    #Start a container to connect to the infra 
        docker run -it --network <network_name> <image_name>

Please refer the following to explore paimon
    https://paimon.apache.org/docs/master/spark/quick-start/
