#!/usr/bin/env bash
set -e

# Get number of machines
MACHINES=$(docker-machine ls | grep \b | sed '/^$/d'| awk '{print NR}'| sort -nr| sed -n '1p')

if [[ ! $1 =~ ^(virtualbox|do)$ ]]; then
  echo "Argument must be 'virtualbox' or 'do'."
  exit 1
fi

if [ $1 == virtualbox ]
  then
    echo "Creating VirtualBox swarm..."
    LEADER_IP=$(docker-machine ssh vm1 ifconfig eth1 | grep 'inet addr' | cut -d: -f2 | awk '{print $1}')

    # create a swarm as all managers
    docker-machine ssh vm1 docker swarm init --advertise-addr "$LEADER_IP"

    JOIN_TOKEN=$(docker-machine ssh vm1 docker swarm join-token -q manager)

    for i in $(seq 2 $MACHINES); do
      docker-machine ssh vm$i docker swarm join --token "$JOIN_TOKEN" "$LEADER_IP":2377
    done

    docker-machine env vm1

    exit 0
fi

if [ $1 == do ]
  then
    echo "Creating Digital Ocean swarm..."
    # since we created droplets with a private NIC on eth1, lets use that for swarm comms
    LEADER_IP=$(docker-machine ssh dvc1 ip addr show eth1 | grep "inet\b" | awk '{print $2}' | cut -d/ -f1)

    # create a swarm as all managers
    docker-machine ssh dvc1 docker swarm init --advertise-addr "$LEADER_IP"

    # note that if you use eth1 above (private network in digitalocean) it makes the below
    # a bit tricky, because docker-machine lists the public IP's but we need the
    # private IP of manager for join commands, so we can't simply envvar the token
    # like lots of scripts do... we'd need to fist get private IP of first node

    # TODO: provide flexable numbers at cli for x managers and x workers
    JOIN_TOKEN=$(docker-machine ssh dvc1 docker swarm join-token -q manager)

    for i in $(seq 2 $MACHINES); do
      docker-machine ssh dvc$i docker swarm join --token "$JOIN_TOKEN" "$LEADER_IP":2377
    done

    docker-machine env dvc1

    exit 0
fi
