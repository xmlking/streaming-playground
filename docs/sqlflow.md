# SQLFlow

Enables SQL-based stream-processing, powered by DuckDB.

## Start

```shell
docker compose up sqlflow
```

## Setup

Create `input-simple-agg-mem` topic for demo flow

```shell
rpk topic create -c cleanup.policy=compact -r 1 -p 1 input-simple-agg-mem
#rpk topic create -c cleanup.policy=compact -r 1 -p 1 output-simple-agg-mem
rpk topic list
```

## Test

publish a couple of messages to `input-simple-agg-mem` topic using **Redpanda Console** e.g:

> [!IMPORTANT]  
> Use TYPE: **JSON**

```json
{
  "event": "search",
  "properties": {
    "city": "New York"
  },
  "user": {
    "id": "123412ds"
  }
}
```

```json
{
  "event": "search",
  "properties": {
    "city": "Baltimore"
  },
  "user": {
    "id": "123412ds1"
  }
}
```

Or use the shell script below:

```shell
# run this couple of times, so that enough messages are produced for batch to trigger
./scripts/gen_fake_data_pub.sh 
```

Check any new messages in `output-simple-agg-mem` topic.