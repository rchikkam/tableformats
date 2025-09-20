We don't need to use a container for exloring duckdb/lake.

Install duckdb on your host.

Goto a command prompt and run the following
    duckdb

Once inside duckdb you should run the following
    #This command establishes a connection with catalog (ducklakedb should exists prior to this command)
        INSTALL https;
        
    #These commands set the properties for object store (S3)
        SET s3_region='us-east-1';
        SET s3_url_style='path';
        SET s3_endpoint='localhost:9000';
        SET s3_access_key_id='admin';
        SET s3_secret_access_key='password';
        set s3_use_ssl=false;
        
    #These commands install the necessary extensions
        INSTALL https;
        LOAD https;
        INSTALL ducklake;
        LOAD ducklake;
        INSTALL postgres;
        LOAD postgres;

    #This command establishes a connection with catalog (ducklakedb should exists prior to this command)
        ATTACH 'ducklake:postgres:dbname=ducklakedb host=localhost user=admin password=password port=5431' AS mydl (DATA_PATH 's3://warehouse2');

    #These commands set the properties for object store (S3)
        SET s3_region='us-east-1';
        SET s3_url_style='path';
        SET s3_endpoint='localhost:9000';
        SET s3_access_key_id='admin';
        SET s3_secret_access_key='password';
        set s3_use_ssl=false;

    #Establish a session to ducklake by
        Use mydl;  #mydl is the name used in the Attach command

Follow information here 
    https://ducklake.select/docs/stable/duckdb/introduction
    
