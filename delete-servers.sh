#!/usr/bin/env bash
set -e

if [[ ! $1 =~ ^(aws|do|gce|virtualbox)$ ]]; then
  echo "Argument must be 'aws','do','gce', or 'virtualbox'."
  exit 1
fi

if [ $1 == aws ]; then
    # Get number of machines
    echo "Getting number of machines..."
    AWS_MACHINES=$(docker-machine ls -q | grep -c aws)
    echo "Deleting Amazon Web Services EC2 machines..."
    # delete all docker machines starting with aws
    for server in $(seq 1 $AWS_MACHINES); do
      docker-machine rm -y awsvm${server}
    done
    exit 0
fi

if [ $1 == do ]; then
    # Get number of machines
    echo "Getting number of machines..."
    DO_MACHINES=$(docker-machine ls -q | grep -c do)
    echo "Deleting Digital Ocean machines..."
    # delete all docker machines starting with do
    for server in $(seq 1 $DO_MACHINES); do
      docker-machine rm -y dovm${server}
    done
    exit 0
fi

if [ $1 == gce ]; then
    # Get number of machines
    echo "Getting number of machines..."
    GCE_MACHINES=$(docker-machine ls -q | grep -c gce)
    echo "Deleting Google Compute Engine machines..."
    # delete all docker machines starting with gce
    for server in $(seq 1 $GCE_MACHINES); do
      docker-machine rm -y gcevm${server}
    done
    exit 0
fi

if [ $1 == virtualbox ]; then
    # Get number of machines
    echo "Getting number of machines..."
    VB_MACHINES=$(docker-machine ls -q | grep -c vb)
    echo "Deleting VirtualBox machines..."
    # delete all docker machines starting with vb
    for server in $(seq 1 $VB_MACHINES); do
      docker-machine rm -y vbvm${server}
    done
    exit 0
fi
