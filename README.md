# Streaming Playground

Experiment with [Arroyo](https://www.arroyo.dev/), [Redpanda Connect](https://www.redpanda.com/connect), [Bufstream](https://buf.build/product/bufstream)

## Prerequisites

Install rpk CLI to use as kafka CLI

```shell
brew install redpanda-data/tap/redpanda
# add zsh completions
rpk generate shell-completion zsh > "${fpath[1]}/_rpk"
```

Create profile to connect to local redpanda kafka cluster

```shell
rpk profile create local \
-s brokers=localhost:19092 \
-s registry.hosts=localhost:8081 \
-s admin.hosts=localhost:9644
```

Install psql CLI for Mac

```shell
brew install libpq
# Finally, symlink psql (and other libpq tools) into /usr/local/bin:
brew link --force libpq
# to connect to local database
psql "postgresql://postgres:postgres@localhost/postgres?sslmode=require"
```

## Start

```shell
docker compose up
open http://localhost:5115/ # Arroyo Console
open http://localhost:8080/ # Redpanda Console
http://localhost:8081/subjects # Redpanda Registry
docker compose down
# (DANGER) - shutdown and delete volumes
docker compose down -v
```

This will start:

1. Postgres Database
2. Kafka - [Redpanda](https://www.redpanda.com/) or [Bufstream](https://buf.build/product/bufstream)
3. [Redpanda Console](https://www.redpanda.com/redpanda-console-kafka-ui)
4. [Redpanda Connect](https://www.redpanda.com/connect) (optional)
5. [MinIO](https://min.io/) (optional)
6. [ClickHouse](https://clickhouse.com/) (optional)
7. [Arroyo](https://www.arroyo.dev/)

## Config

### Kafka

Add a new topics

> [!TIP]
> You can also use [Redpanda Console](http://localhost:8080/overview) to create topics.

```shell
rpk topic list
rpk topic create -c cleanup.policy=compact -r 1 -p 1 customer-source
rpk topic create -c cleanup.policy=compact -r 1 -p 1 customer-sink
```

### Arroyo Pipeline

in from [Arroyo Console](http://localhost:5115/), Create a pipeline with:

> [!WARNING]
> By default preview doesn't write to sinks to avoid accidentally writing bad data.
> You can run the pipeline for real by clicking "Launch" or you can enable sinks in preview:

```sql
CREATE TABLE customer_source (
    name TEXT,
    age INT,
    phone TEXT,
) WITH (
    connector = 'kafka',
    format = 'json',
    type = 'source',
    bootstrap_servers = 'bufstream:9092',
    topic = 'customer-source'
);

CREATE TABLE customer_sink (
    count BIGINT,
    age INT,
) WITH (
    connector = 'kafka',
    format = 'json',
    type = 'sink',
    bootstrap_servers = 'bufstream:9092',
    topic = 'customer-sink'
);

SELECT count(*),  age
FROM customer_source
GROUP BY age, hop(interval '2 seconds', interval '10 seconds');

INSERT INTO customer_sink SELECT count(*),  age
FROM customer_source
GROUP BY age, hop(interval '2 seconds', interval '10 seconds');
```

## Test

publish couple of messages to `customer-source` topic using **Redpanda Console** e.g:

> [!IMPORTANT]  
> Use TYPE: **JSON**

```json
{
    "name": "sumo",
    "age": 70,
    "phone": "111-222-4444"
}
```

Check any new messages in `customer-sink` topic.
