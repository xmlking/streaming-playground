-- Lookup joins to enrich your streaming data
-- https://www.arroyo.dev/blog/arroyo-0-14-0
-- https://doc.arroyo.dev/sql/joins#lookup-joins

CREATE TEMPORARY TABLE customers (
    -- For Redis lookup tables, it's required that there be a single
    -- METADATA FROM 'key' marked as PRIMARY KEY, as Redis only supports
    -- efficient lookups by key
    customer_id TEXT METADATA FROM 'key' PRIMARY KEY,
    name TEXT,
    plan TEXT
) with (
    connector = 'redis',
    address = 'redis://localhost:6379',
    format = 'json',
    'lookup.cache.max_bytes' = 1000000,
    'lookup.cache.ttl' = interval '5 seconds'
);

CREATE TABLE events (
    event_id TEXT,
    timestamp TIMESTAMP,
    customer_id TEXT,
    event_type TEXT
) WITH (
    connector = 'kafka',
    topic = 'events',
    type = 'source',
    format = 'json',
    bootstrap_servers = 'localhost:19092'
);

SELECT  e.event_id,  e.timestamp,  c.name, c.plan
FROM  events e
LEFT JOIN customers c
-- you may use SQL expressions like concat to generate the exact key
-- format in Redis
ON concat('customer.', e.customer_id) = c.customer_id
WHERE c.plan = 'Premium';