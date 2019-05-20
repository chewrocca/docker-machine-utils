#!/usr/bin/env bash
set -e

if [[ ! $1 =~ ^(virtualbox|do|gce)$ ]]; then
  echo "Argument must be 'virtualbox', 'do' or 'gce'."
  exit 1
fi

# Get number of machines
echo "Getting number of machines..."
GCE_MACHINES=$(docker-machine ls | grep -c gce) 
DO_MACHINES=$(docker-machine ls | grep -c dvc)
VB_MACHINES=$(docker-machine ls | grep -c vb) 

if [ $1 == virtualbox ]; then
    echo "Creating VirtualBox swarm..."
    LEADER_IP=$(docker-machine ssh vbvm1 ifconfig eth1 | grep 'inet addr' | \
                cut -d: -f2 | awk '{print $1}')

    # create a swarm as all managers
    docker-machine ssh vbvm1 docker swarm init --advertise-addr "$LEADER_IP"

    if [ "$VB_MACHINES" -gt "1" ]; then
      JOIN_TOKEN=$(docker-machine ssh vbvm1 docker swarm join-token -q manager)

      for i in $(seq 2 $VB_MACHINES); do
        echo "vbvm$i:"
        docker-machine ssh vbvm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
      exit 0
    fi

    docker-machine env vbvm1
    exit 0
fi

if [ $1 == do ]; then
    echo "Creating Digital Ocean swarm..."
    # created droplets with a private NIC on eth1
    LEADER_IP=$(docker-machine ssh dvcvm1 ip addr show eth1 | grep "inet\b" | \
                awk '{print $2}' | cut -d/ -f1)

    # create a swarm as all managers
    docker-machine ssh dvcvm1 docker swarm init --advertise-addr "$LEADER_IP"

    if [ "$DO_MACHINES" -gt "1" ]; then
      JOIN_TOKEN=$(docker-machine ssh dvcvm1 docker swarm join-token -q manager)

      for i in $(seq 2 $DO_MACHINES); do
        echo "dvcvm$i:"
        docker-machine ssh dvcvm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
      exit 0
    fi

    docker-machine env dvcvm1
    exit 0
fi

if [ $1 == gce ]; then
    echo "Creating Google Compute Engine swarm..."
    LEADER_IP=$(gcloud compute instances describe gcevm1 \
                --format='get(networkInterfaces[0].networkIP)')

    # create a swarm as all managers
    docker-machine ssh gcevm1 sudo docker swarm init --advertise-addr \
    "$LEADER_IP"

    if [ "$GCE_MACHINES" -gt "1" ]; then
      JOIN_TOKEN=$(docker-machine ssh gcevm1 sudo docker swarm join-token -q \
                   manager)

      for i in $(seq 2 $GCE_MACHINES); do
        echo "gcevm$i:"
        docker-machine ssh gcevm$i sudo docker swarm join --token \
        "$JOIN_TOKEN" "$LEADER_IP":2377
      done
      exit 0
     fi

    docker-machine env gcevm1
    exit 0
fi
