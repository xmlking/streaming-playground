CREATE TABLE customer_source (
    name TEXT,
    age INT,
    phone TEXT
) WITH (
    connector = 'kafka',
    format = 'json',
    type = 'source',
    bootstrap_servers = 'localhost:19092',
    topic = 'customer-source'
);

CREATE TABLE customer_sink (
    count BIGINT,
    age INT
) WITH (
    connector = 'kafka',
    format = 'json',
    type = 'sink',
    bootstrap_servers = 'localhost:19092',
    topic = 'customer-sink'
);

SELECT count(*),  age
FROM customer_source
GROUP BY age, hop(interval '2 seconds', interval '10 seconds');

INSERT INTO customer_sink SELECT count(*),  age
FROM customer_source
GROUP BY age, hop(interval '2 seconds', interval '10 seconds');