#!/bin/bash

set -e

apt-get update
apt-get install -y wget tcl build-essential

source /etc/profile
DATA_DIR=/tmp/kitchen/data
RUBY_HOME=${MY_RUBY_HOME}

# Set the locale
apt-get install -y locales
locale-gen en_US.UTF-8
export LANG="en_US.UTF-8"
export LANGUAGE="en_US:en"
export LC_ALL="en_US.UTF-8"

cd $DATA_DIR
wget http://download.redis.io/redis-stable.tar.gz
tar xvzf redis-stable.tar.gz
cd redis-stable
make distclean
make
make install

cd $DATA_DIR
cp redis-stable/redis.conf /etc/redis.conf
sed -i 's/# requirepass foobared/requirepass foobared/' /etc/redis.conf
sed -i 's/# unixsocket \/tmp\/redis.sock/unixsocket \/tmp\/redis.sock/' /etc/redis.conf
sed -i 's/# unixsocketperm 700/unixsocketperm 700/' /etc/redis.conf

cp redis-stable/redis.conf /etc/redis_slave.conf
sed -i 's/# slaveof <masterip> <masterport>/slaveof 127.0.0.1 6379/' /etc/redis_slave.conf
sed -i 's/port 6379/port 6380/' /etc/redis_slave.conf
sed -i 's/# masterauth <master-password>/masterauth foobared/' /etc/redis_slave.conf

cp redis-stable/redis.conf /etc/redis_slave_down.conf
sed -i 's/# slaveof <masterip> <masterport>/slaveof 127.0.0.1 8000/' /etc/redis_slave_down.conf
sed -i 's/port 6379/port 6381/' /etc/redis_slave_down.conf

redis-server /etc/redis.conf & 
sleep 5

redis-server /etc/redis_slave.conf &
sleep 5

redis-server /etc/redis_slave_down.conf &
sleep 5

redis-cli -a foobared rpush alpha_key_list a b c d e
redis-cli -a foobared set beta_key beta
redis-cli -a foobared set charlie_val charlie

SIGN_GEM=false gem build sensu-plugins-redis.gemspec
gem install sensu-plugins-redis-*.gem