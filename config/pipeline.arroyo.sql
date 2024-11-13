CREATE TABLE mastodon (
    id TEXT,
    uri TEXT,
    content TEXT
) WITH (
    connector = 'sse',
    format = 'json',
    endpoint = 'http://mastodon.arroyo.dev/api/v1/streaming/public',
    events = 'update'
);

CREATE TABLE output_table
WITH (
    connector = 'blackhole'
);

WITH post_filtering AS (
    SELECT
        id
        , arrow_cast(REGEXP_LIKE(content, '(kamala|har{1,3}is)', 'i'), 'Int64') AS harris_mentioned
        , arrow_cast(REGEXP_LIKE(content, 'trumps?', 'i'), 'Int64') AS trump_mentioned
    FROM mastodon
)

SELECT  TUMBLE(interval '30 seconds') AS window
    , SUM(harris_mentioned) AS number_of_post_mention_harris
    , SUM(trump_mentioned) AS number_of_post_mention_trump
FROM post_filtering
GROUP BY window

INSERT INTO output_table
    TUMBLE(interval '30 seconds') AS window
    , SUM(harris_mentioned) AS number_of_post_mention_harris
    , SUM(trump_mentioned) AS number_of_post_mention_trump
FROM post_filtering
GROUP BY window