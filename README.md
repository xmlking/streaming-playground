# Arroyo

## Prerequisites

Install rpk CLI to use as kafka CLI

```shell
brew install redpanda-data/tap/redpanda
# add zsh completions
rpk generate shell-completion zsh > "${fpath[1]}/_rpk"
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

This will start

1. Postgres Database
2. Bufstream (kafka)
3. Redpanda Console
4. Minio (optional)
5. Arroyo cluster

```shell
docker compose up
open http://localhost:5115/
open http://localhost:8080/
docker compose down
```

## Config

### Kafka

Add a new topics

> [!TIP]
> You can also [Redpanda Console](http://localhost:8080/overview) to create topics.

```shell
rpk topic list
rpk topic create -c cleanup.policy=compact -r 1 -p 1 customer-source
rpk topic create -c cleanup.policy=compact -r 1 -p 1 customer-sink
```

### Arroyo

in Arroyo Console, Create a pipeline with:

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

> [!WARN]
> Use TYPE: **JSON**

```json
{
    "name": "sumo",
    "age": 70,
    "phone": "111-222-4444"
}
```

Check any new messages in `customer-sink` topic.
