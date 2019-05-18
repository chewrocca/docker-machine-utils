#!/usr/bin/env bash
set -e
END=$2

if [[ ! $1 =~ ^(virtualbox|do)$ ]]; then
  echo "Argument must be 'virtualbox' or 'do', second argument is number of machines to create (default 1)."
  exit 1
fi

if [ $1 == virtualbox ]
  then
    echo "Creating VirtualBox machines..."
    for server in $(seq 1 $END); do
      docker-machine create \
      --driver=virtualbox \
      --virtualbox-memory 8096 \
      vm${server}
    done
    exit 0
fi


if [ $1 == do ]
  then
    echo "Creating Digital Ocean machines..."
    # create managers servers in digital ocean with pre-set environment vars
    # https://docs.docker.com/machine/drivers/digital-ocean/

    # DIGITALOCEAN_ACCESS_TOKEN get the token from digitalocean.com (read/write)
    # DIGITALOCEAN_SIZE pick your droplet size from "doctl compute size list"
    # DIGITALOCEAN_SSH_KEY_FINGERPRINT in the format of "8d:30:8a..." with a comand like "ssh-keygen -E md5 -lf  ~/.ssh/id_rsa.pub"
    # DIGITALOCEAN_REGION pick your region from "doctl compute region list"
    # DIGITALOCEAN_IMAGE pick your distribution image "doctl compute image list-distribution

    for server in $(seq 1 $END); do
      docker-machine create \
      --driver=digitalocean \
      --digitalocean-access-token="${DIGITALOCEAN_ACCESS_TOKEN}" \
      --digitalocean-size="${DIGITALOCEAN_SIZE}" \
      --digitalocean-ssh-key-fingerprint="${DIGITALOCEAN_SSH_KEY_FINGERPRINT}" \
      --digitalocean-region="${DIGITALOCEAN_REGION}" \
      --digitalocean-image="${DIGITALOCEAN_IMAGE}" \
      --digitalocean-tags="docker-machine" \
      --digitalocean-private-networking=true \
       dvc${server}
    done
    exit 0
fi
