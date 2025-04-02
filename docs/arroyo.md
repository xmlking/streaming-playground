# Arroyo

## Install

```shell
brew install arroyosystems/tap/arroyo
```

> [!NOTE]  
> First, start local **redis** via docker-compose, if you are using it in Arroyo pipeline. follow : [redis](./redis.md) docs

A local Pipeline can be started with:
```shell
# state can be stored on a local filesystem or on an object store
arroyo run pipelines/wikiedits.pipeline.sql
# or if you have local minio s3 server
arroyo run --state-dir s3://my-bucket/pipelines/my-pipeline pipelines/wikiedits.pipeline.sql
```

you can also start a cluster with:
```shell
arroyo cluster
```

and open the Arroyo Web UI at http://localhost:5115

## Examples

This example is based on [blog](https://www.arroyo.dev/blog/fly-tutorial), [code](https://github.com/ArroyoSystems/arroyo-fly-tutorial/tree/main)

### Wikipedia Top Editors

We're going to build a pipeline that
1. Reads in the raw event data from Wikipedia
2. Computes the top editors by number of changes over a sliding window
3. Writes the results to Redis, where they're consumed by a simple Python Flask web app

First start Redis:

```shell
docker compose up redis
# to stop
docker compose down redis
```

Then run [wikiedits.pipeline.sql](../pipelines/wikiedits.pipeline.sql)

```shell
arroyo run pipelines/wikiedits.pipeline.sql
```

Check RedisInsight [console](http://localhost:8001/redis-stack/browser) for fresh data in `top_editors` HASH

#### Webapp (optional)

Run python [webApp](../webapp)

### Lookup Joins

This demo showcase [lookup-joins](https://doc.arroyo.dev/sql/joins#lookup-joins)

Lookup joins allow you to enrich streams by referencing external or static data stored in external systems (e.g., Redis, relational databases).

First start `Redis` and `Redpanda` (kafka) and `Redpanda Console`

```shell
docker compose up redis console
# to stop
docker compose down redis console
```

Create kafka topic
```shell
rpk topic create  -r 1 -p 1 events
```

Insert customers data into Redis

```shell
cat ./scripts/customers.redis | redis-cli --pipe
# or if you don't have redis-cli installed
cat ./scripts/customers.redis | docker compose exec -T redis redis-cli --pipe
```

> [!NOTE]  
> The `lookup.cache.max_bytes` and `lookup.cache.ttl` are optional arguments that control the behavior of the built-in cache, which avoids the need to query the same keys over and over again.  
> Lookup joins can be either INNER (the default) or LEFT.

Then run [lookup.pipeline.sql](../pipelines/lookup.pipeline.sql)

```shell
arroyo run pipelines/lookup.pipeline.sql
```

Publish events into kafka topic

```shell
./scripts/gen_fake_events.sh
```

Access RedisInsight [console](http://localhost:8001/redis-stack/browser) to created test data  

Access Redpanda [console](http://localhost:8080/) to view `events` topic



### Mastodon

Run [mastodon.pipeline.sql](../pipelines/mastodon.pipeline.sql) 

Arroyo Connections

Create new SSE connection from [Arroyo Console](http://localhost:5115/) with:

```json
{
  "events": "update",
  "endpoint": "http://mastodon.arroyo.dev/api/v1/streaming/public"
}
```

To get sample data:

```shell
curl -N http://mastodon.arroyo.dev/api/v1/streaming/public 
# or, even better
http http://mastodon.arroyo.dev/api/v1/streaming/public
```

To infer JSON Schema, use tools like: <https://transform.tools/json-to-json-schema>

## Reference
- Serverless Arroyo pipelines [blog](https://www.arroyo.dev/blog/fly-tutorial), [code](https://github.com/ArroyoSystems/arroyo-fly-tutorial/tree/main)
- Arroyo example [queries](https://github.com/ArroyoSystems/arroyo/tree/master/crates/arroyo-planner/src/test/queries)