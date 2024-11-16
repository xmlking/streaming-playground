# Redpanda

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

## Endpoints

### Registry Endpoints

- <http://localhost:8081/status/ready>
- <http://localhost:8081/config>
- <http://localhost:8081/mode>
- <http://localhost:8081/schemas/types>
- <http://localhost:8081/subjects>
- <http://localhost:8081//schemas/ids/{id}>

## RPK Commands

```shell
rpk version
```

### Profiles

```shell
rpk profile list
rpk profile use local
```

### Cluster

```shell
rpk cluster info
rpk cluster health
rpk cluster config status
rpk cluster logdirs describe
```

### Topic

```shell
rpk topic create -c cleanup.policy=compact -r 1 -p 1 customer-source
rpk topic create -c cleanup.policy=compact -r 1 -p 1 customer-sink
rpk topic list
```

### Groups

```shell
rpk group list
```

### Registry

```shell
rpk registry mode get 
rpk registry schema list
```

### Connect (Benthos)

```shell
rpk connect list
rpk connect create > pipelines/simple.connect.yaml
rpk connect create stdin/bloblang/stdout > pipelines/simple.connect.yaml
rpk connect echo pipelines/simple.connect.yaml

rpk connect create kafka_franz/mapping/stdout > pipelines/kafka.connect.yaml
rpk connect create kafka_franz/schema_registry_decode/stdout > pipelines/kafka2.connect.yaml

rpk connect lint pipelines/simple.connect.yaml
rpk connect test -h pipelines/simple.connect.yaml
rpk connect run pipelines/simple.connect.yaml

rpk connect streams 
rpk connect install
rpk connect upgrade
rpk connect uninstall
rpk connect studio
```
