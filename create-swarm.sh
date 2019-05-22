#!/usr/bin/env bash
set -e

if [[ ! $1 =~ ^(aws|do|gce|virtualbox)$ ]] && [[ ! $2 =~ ^(manager|worker)$ ]]; then
  echo "Argument must be 'aws','do','gce', or 'virtualbox' with 'manager' or 'worker' as second argument."
  exit 1
fi

if [ $1 == aws ] && [[ $2 =~ ^(manager|worker)$ ]]; then
    echo "Getting number of machines..."
    AWS_MACHINES=$(docker-machine ls -q | grep -c aws)

    echo "Creating Amazon Web Services EC2 swarm..."
    LEADER_IP=$(docker-machine ssh awsvm1 ifconfig eth0 | grep 'inet addr' | \
                cut -d: -f2 | awk '{print $1}')

    # create a swarm as all managers
    # aws requires sudo
    docker-machine ssh awsvm1 sudo docker swarm init --advertise-addr "$LEADER_IP"

    if [ "$AWS_MACHINES" -gt "1" -a $2 == manager ]; then
      echo "Adding manager nodes..."
      JOIN_TOKEN=$(docker-machine ssh awsvm1 sudo docker swarm join-token -q manager)

      for i in $(seq 2 $AWS_MACHINES); do
        echo "awsvm$i:"
        docker-machine ssh awsvm$i sudo docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    if [ "$AWS_MACHINES" -gt "1" -a $2 == worker ]; then
      echo "Adding worker nodes..."
      JOIN_TOKEN=$(docker-machine ssh awsvm1 sudo docker swarm join-token -q worker)

      for i in $(seq 2 $AWS_MACHINES); do
        echo "awsvm$i:"
        docker-machine ssh awsvm$i sudo docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    docker-machine env awsvm1
    exit 0
fi

if [ $1 == do ] && [[ $2 =~ ^(manager|worker)$ ]]; then
    echo "Getting number of machines..."
    DO_MACHINES=$(docker-machine ls -q | grep -c do)

    echo "Creating Digital Ocean swarm..."
    # created droplets with a private NIC on eth1
    LEADER_IP=$(docker-machine ssh dovm1 ip addr show eth1 | grep "inet\b" | \
                awk '{print $2}' | cut -d/ -f1)

    # create a swarm as all managers
    docker-machine ssh dovm1 docker swarm init --advertise-addr "$LEADER_IP"

    if [ "$DO_MACHINES" -gt "1" -a $2 == manager ]; then
      echo "Adding manager nodes..."
      JOIN_TOKEN=$(docker-machine ssh dovm1 docker swarm join-token -q manager)

      for i in $(seq 2 $DO_MACHINES); do
        echo "dovm$i:"
        docker-machine ssh dovm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    if [ "$DO_MACHINES" -gt "1" -a $2 == worker ]; then
      echo "Adding worker nodes..."
      JOIN_TOKEN=$(docker-machine ssh dovm1 docker swarm join-token -q worker)

      for i in $(seq 2 $DO_MACHINES); do
        echo "dovm$i:"
        docker-machine ssh dovm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    docker-machine env dovm1
    exit 0
fi

if [ $1 == gce ] && [[ $2 =~ ^(manager|worker)$ ]]; then
    echo "Getting number of machines..."
    GCE_MACHINES=$(docker-machine ls -q | grep -c gce)

    echo "Creating Google Compute Engine swarm..."
    LEADER_IP=$(gcloud compute instances describe gcevm1 \
                --format='get(networkInterfaces[0].networkIP)')

    # create a swarm as all managers
    # gce requires sudo
    docker-machine ssh gcevm1 sudo docker swarm init --advertise-addr \
    "$LEADER_IP"

    if [ "$GCE_MACHINES" -gt "1" -a $2 == manager ]; then
      echo "Adding manager nodes..."
      JOIN_TOKEN=$(docker-machine ssh gcevm1 sudo docker swarm join-token -q \
                   manager)

      for i in $(seq 2 $GCE_MACHINES); do
        echo "gcevm$i:"
        docker-machine ssh gcevm$i sudo docker swarm join --token \
        "$JOIN_TOKEN" "$LEADER_IP":2377
      done
    fi

    if [ "$GCE_MACHINES" -gt "1" -a $2 == worker ]; then
      echo "Adding worker nodes..."
      JOIN_TOKEN=$(docker-machine ssh gcevm1 sudo docker swarm join-token -q worker)

      for i in $(seq 2 $GCE_MACHINES); do
        echo "gcevm$i:"
        docker-machine ssh gcevm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    docker-machine env gcevm1
    exit 0
fi

if [ $1 == virtualbox ] && [[ $2 =~ ^(manager|worker)$ ]]; then
    echo "Getting number of machines..."
    VB_MACHINES=$(docker-machine ls -q | grep -c vb)

    echo "Creating VirtualBox swarm..."
    LEADER_IP=$(docker-machine ssh vbvm1 ifconfig eth1 | grep 'inet addr' | \
                cut -d: -f2 | awk '{print $1}')

    # create a swarm as all managers
    docker-machine ssh vbvm1 docker swarm init --advertise-addr "$LEADER_IP"

    if [ "$VB_MACHINES" -gt "1" -a $2 == manager ]; then
      echo "Adding manager nodes..."
      JOIN_TOKEN=$(docker-machine ssh vbvm1 docker swarm join-token -q manager)

      for i in $(seq 2 $VB_MACHINES); do
        echo "vbvm$i:"
        docker-machine ssh vbvm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    if [ "$VB_MACHINES" -gt "1" -a $2 == worker ]; then
      echo "Adding worker nodes..."
      JOIN_TOKEN=$(docker-machine ssh vbvm1 docker swarm join-token -q worker)

      for i in $(seq 2 $VB_MACHINES); do
        echo "vbvm$i:"
        docker-machine ssh vbvm$i docker swarm join --token "$JOIN_TOKEN" \
        "$LEADER_IP":2377
      done
    fi

    docker-machine env vbvm1
    exit 0
fi

echo "Argument must be 'aws','do','gce' or 'virtualbox', with 'manager' or 'worker' as second argument."
exit 1
