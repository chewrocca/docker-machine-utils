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
    echo "Deleting VirtualBox machines..."
    # delete all docker machines starting with vm
    for server in $(seq 1 $MACHINES); do
      docker-machine rm -y vm${server}
    done
    exit 0
fi

if [ $1 == do ]
  then
    echo "Deleting Digital Ocean machines..."
    # delete all docker machines starting with dvc
    for server in $(seq 1 $MACHINES); do
      docker-machine rm -y dvc${server}
    # delete all storage in DO (be sure you are ok deleting ALL storage in an account)
    # doctl compute volume ls --format ID --no-header | while read -r id; do doctl compute volume rm -f "$id"; done
    done
    exit 0
fi

