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

## References

- [buf-examples](https://github.com/bufbuild/buf-examples)
- [Bufstream and Iceberg quickstart](https://github.com/bufbuild/buf-examples/tree/main/bufstream/iceberg-quickstart)