# Arroyo

## Arroyo Connections

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
