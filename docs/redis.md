# Redis

Run [Redis Stack](https://hub.docker.com/r/redis/redis-stack) on Docker Compose

```shell
docker compose up redis
# to stop
docker compose down redis
```

## redis-cli

You can then connect to the server using `redis-cli`, just as you connect to any Redis instance.

If you don’t have redis-cli installed locally, you can run it from the Docker container:
```shell
docker compose exec -it redis redis-cli
```

## RedisInsight

Docker also exposes **RedisInsight** on port **8001**

You can use RedisInsight by pointing your browser to http://localhost:8001