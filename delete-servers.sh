#!/usr/bin/env bash
set -e

if [[ ! $1 =~ ^(virtualbox|do|gce)$ ]]; then
  echo "Argument must be 'virtualbox', 'do', or 'gce'."
  exit 1
fi

# Get number of machines
echo "Getting number of machines..."
GCE_MACHINES=$(docker-machine ls | grep gce | sed '/^$/d'| awk '{print NR}'| \
sort -nr| sed -n '1p')
DO_MACHINES=$(docker-machine ls | grep dvc | sed '/^$/d'| awk '{print NR}'| \
sort -nr| sed -n '1p')
VB_MACHINES=$(docker-machine ls | grep vb | sed '/^$/d'| awk '{print NR}'| \
sort -nr| sed -n '1p')

if [ $1 == virtualbox ]; then
    echo "Deleting VirtualBox machines..."
    # delete all docker machines starting with vm
    for server in $(seq 1 $VB_MACHINES); do
      docker-machine rm -y vbvm${server}
    done
    exit 0
fi

if [ $1 == do ]; then
    echo "Deleting Digital Ocean machines..."
    # delete all docker machines starting with dvc
    for server in $(seq 1 $DO_MACHINES); do
      docker-machine rm -y dvcvm${server}
    done
    exit 0
fi

if [ $1 == gce ]; then
    echo "Deleting Google Compute Engine machines..."
    # delete all docker machines starting with vm
    for server in $(seq 1 $GCE_MACHINES); do
      docker-machine rm -y gcevm${server}
    done
    exit 0
fi
