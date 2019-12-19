[![Sensu Bonsai Asset](https://img.shields.io/badge/Bonsai-Download%20Me-brightgreen.svg?colorB=89C967&logo=sensu)](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-redis)
[![Build Status](https://travis-ci.org/sensu-plugins/sensu-plugins-redis.svg?branch=master)](https://travis-ci.org/sensu-plugins/sensu-plugins-redis)
[![Gem Version](https://badge.fury.io/rb/sensu-plugins-redis.svg)](http://badge.fury.io/rb/sensu-plugins-redis)
[![Code Climate](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis/badges/gpa.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis)
[![Test Coverage](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis/badges/coverage.svg)](https://codeclimate.com/github/sensu-plugins/sensu-plugins-redis)
[![Dependency Status](https://gemnasium.com/sensu-plugins/sensu-plugins-redis.svg)](https://gemnasium.com/sensu-plugins/sensu-plugins-redis)

## Sensu Plugins Redis Plugin

- [Overview](#overview)
- [Files](#files)
- [Usage examples](#usage-examples)
- [Configuration](#configuration)
  - [Sensu Go](#sensu-go)
    - [Asset registration](#asset-registration)
    - [Asset definition](#asset-definition)
    - [Check definition](#check-definition)
  - [Sensu Core](#sensu-core)
    - [Check definition](#check-definition)
- [Installation from source](#installation-from-source)
- [Additional notes](#additional-notes)
- [Contributing](#contributing)

### Overview

This plugin provides native Redis instrumentation for monitoring and metrics collection, including service health, database connectivity, replication status, `INFO` metrics, key counts, list lengths, and more.

### Files
 * bin/check-redis-info.rb
 * bin/check-redis-keys.rb
 * bin/check-redis-list-length.rb
 * bin/check-redis-memory.rb
 * bin/check-redis-memory-percentage.rb
 * bin/check-redis-ping.rb
 * bin/check-redis-slave-status.rb
 * bin/check-redis-connections-available.rb
 * bin/metrics-redis-graphite.rb
 * bin/metrics-redis-keys.rb
 * bin/metrics-redis-llen.rb
 
**check-redis-info**
Checks variables from redis [INFO](http://redis.io/commands/INFO).

**check-redis-keys**
Checks the number of keys that match a key's command that are above the provided warn/critical levels.

**check-redis-list-length**
Checks the number of items in a Redis list key.

**check-redis-memory**
Checks Redis [INFO](http://redis.io/commands/INFO) stats and limits values.

**check-redis-memory-percentage**
Checks Redis memory usage in percent.

**check-redis-ping**
Runs Redis ping command to see if Redis is alive.

**check-redis-slave-status**
Checks Redis slave Replication.

**check-redis-connections-available**
Checks the number of connections available on Redis.

**metrics-redis-graphite**
Pushes Redis [INFO](http://redis.io/commands/INFO) stats into graphite.

**metrics-redis-keys**
Gets the number of keys and pushes it to Graphite.

**metrics-redis-llen**
Gets the length of a list and pushes it to Graphite.

## Usage examples

### Help

**check-redis-info.rb**
```
Usage: check-redis-info.rb (options)
        --conn-failure-status EXIT_STATUS
                                     Returns the following exit status for Redis connection failures (included in ['unknown', 'warning', 'critical'])
    -n, --dbnumber DATABASE          Redis database number to connect to
    -h, --host HOST                  Redis Host to connect to
    -P, --password PASSWORD          Redis Password to connect with
    -p, --port PORT                  Redis Port to connect to
    -r, --reconnect ATTEMPTS         Reconnect attempts to Redis host
    -K, --redis-info-key KEY         Redis info key to monitor
    -V, --redis-info-key-value VALUE Redis info key value to trigger alarm
    -s, --socket SOCKET              Redis socket to connect to (overrides Host and Port)
    -t, --timeout TIMEOUT            Redis connection timeout
    -T, --transport TRANSPORT        Redis transport protocol to use (included in ['redis', 'rediss'])
```

**metrics-redis-keys.rb**
```
Usage: metrics-redis-keys.rb (options)
        --conn-failure-status EXIT_STATUS
                                     Returns the following exit status for Redis connection failures (included in ['unknown', 'warning', 'critical'])
    -n, --dbnumber DATABASE          Redis database number to connect to
    -h, --host HOST                  Redis Host to connect to
    -M, --metric-name METRICNAME     Name of the metric key. Defaults to "keys"
    -P, --password PASSWORD          Redis Password to connect with
        --pattern PATTERN            Argument passed into keys command. Defaults to *
    -p, --port PORT                  Redis Port to connect to
    -r, --reconnect ATTEMPTS         Reconnect attempts to Redis host
    -S, --scheme SCHEME              Metric naming scheme, text to prepend to metric
    -s, --socket SOCKET              Redis socket to connect to (overrides Host and Port)
    -t, --timeout TIMEOUT            Redis connection timeout
    -T, --transport TRANSPORT        Redis transport protocol to use (included in ['redis', 'rediss'])
```

## Configuration
### Sensu Go
#### Asset registration

Assets are the best way to make use of this plugin. If you're not using an asset, please consider doing so! If you're using sensuctl 5.13 or later, you can use the following command to add the asset: 

`sensuctl asset add sensu-plugins/sensu-plugins-redis`

If you're using an earlier version of sensuctl, you can download the asset definition from [this project's Bonsai asset index page](https://bonsai.sensu.io/assets/sensu-plugins/sensu-plugins-redis).

#### Asset definition

```yaml
---
type: Asset
api_version: core/v2
metadata:
  name: sensu-plugins-redis
spec:
  url: https://assets.bonsai.sensu.io/bfe5bc7de4ab00e71fc3017737cb501ae076bd1f/sensu-plugins-redis_4.2.0_centos_linux_amd64.tar.gz
  sha512: 5df87e7d2c4db85e6a4bdf1f1eb802b2baef933542528e09b3a36d10019ab93e37a7fde7ba3c06334cd22908135ad8704cb5fbef1d1e608f32a2446322222f3b
```

#### Check definition

```yaml
---
type: CheckConfig
spec:
  command: "check-redis-info.rb"
  handlers: []
  high_flap_threshold: 0
  interval: 10
  low_flap_threshold: 0
  publish: true
  runtime_assets:
  - sensu-plugins/sensu-plugins-redis
  - sensu/sensu-ruby-runtime
  subscriptions:
  - linux
```

### Sensu Core

#### Check definition
```json
{
  "checks": {
    "check-redis-info": {
      "command": "check-redis-info.rb",
      "subscribers": ["linux"],
      "interval": 10,
      "refresh": 10,
      "handlers": ["influxdb"]
    }
  }
}
```

## Installation from source

### Sensu Go

See the instructions above for [asset registration](#asset-registration).

### Sensu Core

Install and setup plugins on [Sensu Core](https://docs.sensu.io/sensu-core/latest/installation/installing-plugins/).

## Additional notes

None

## Contributing

See [CONTRIBUTING.md](https://github.com/sensu-plugins/sensu-plugins-redis/blob/master/CONTRIBUTING.md) for information about contributing to this plugin.

