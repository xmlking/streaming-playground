# BufStream

[BufStream](https://buf.build/docs/bufstream/) is a Kafka replacement platform with S3 storage and [Apache Iceberg](https://buf.build/docs/bufstream/iceberg/) integration.

## Setup

## Run

```shell
# start all services except optionals 
docker compose -f compose.bufstream.yml up
# verify running services and health
docker compose -f compose.bufstream.yml ps
# shutdown all services and delete data
docker compose -f compose.bufstream.yml down
# DANGER: shutdown all services and delete data
docker compose -f compose.bufstream.yml down -v
```

Create a bucket `warehouse` with `public` policy at: http://localhost:9001/buckets

## Using ClickHouse

Connect to ClickHouse and use the following commands to run queries. You can access data in 3 different ways.

```sql
SHOW DATABASES;
SHOW TABLES FROM default;
SHOW TABLES FROM meteroid;
```


### Direct query on Parquet files.

```sql
SELECT count() 
FROM s3('http://minio:9000/warehouse/bufstream/demo/**/**.parquet');

SELECT * 
FROM s3('http://minio:9000/warehouse/data/data/**/**.parquet');
```

### Query using Iceberg metadata without a catalog

```sql
SELECT count()
FROM iceberg('http://minio:9000/warehouse/data');

SELECT *
FROM iceberg('http://minio:9000/warehouse/data');
```

### Query using the Iceberg REST catalog

```sql
DROP DATABASE IF EXISTS datalake;
SET allow_experimental_database_iceberg=true;
CREATE DATABASE datalake
ENGINE = Iceberg('http://iceberg:8181/v1', 'minioadmin', 'minioadmin')
SETTINGS catalog_type = 'rest', storage_endpoint = 'http://minio:9000/warehouse', warehouse = 'iceberg' ;
SHOW TABLES from datalake;
SELECT count() FROM datalake.`iceberg.bids`;
SELECT * FROM datalake.`iceberg.bids`
```


## References

- [buf-examples](https://github.com/bufbuild/buf-examples)
- [Bufstream and Iceberg quickstart](https://github.com/bufbuild/buf-examples/tree/main/bufstream/iceberg-quickstart)