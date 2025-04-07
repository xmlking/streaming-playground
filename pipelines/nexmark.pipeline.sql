CREATE TABLE nexmark with (
    connector = 'nexmark',
    event_rate = '100'
);

CREATE TABLE bids (
    auction    BIGINT,
    bidder     BIGINT,
    channel    VARCHAR,
    url        VARCHAR,
    datetime   DATETIME,
    price      BIGINT
) WITH (
    connector = 'filesystem',
    type = 'sink',
    path = '/home/data',
    format = 'parquet',
    parquet_compression = 'zstd',
    rollover_seconds = 60,
    time_partition_pattern = '%Y/%m/%d/%H',
    partition_fields = 'bidder'
);

-- SELECT bid from nexmark where bid is not null;

INSERT INTO bids
SELECT
    bid.auction, bid.bidder, bid.channel, bid.url, bid.datetime, bid.price
FROM
    nexmark
where
    bid is not null