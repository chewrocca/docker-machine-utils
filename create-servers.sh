#!/usr/bin/env bash
set -e

# Use second argument to get number of Virtual Machines to build (default 1)
END=$2

if [[ ! $1 =~ ^(virtualbox|do|gce)$ ]]; then
  echo "Argument must be 'virtualbox', 'do' or 'gce', second argument is" \
"number of machines to create (defaults to 1)."
  exit 1
fi

if [ $1 == virtualbox ]; then
    echo "Creating VirtualBox machines..."
    for server in $(seq 1 $END); do
      docker-machine create \
      --driver=virtualbox \
      vbvm${server}
    done
    exit 0
fi

if [ $1 == do ]; then
    echo "Creating Digital Ocean machines..."
    # create managers servers in digital ocean with pre-set environment vars
    # https://docs.docker.com/machine/drivers/digital-ocean/

    # DIGITALOCEAN_ACCESS_TOKEN get the token from digitalocean.com (read/write)
    # DIGITALOCEAN_SIZE pick your droplet size from "doctl compute size list"
    # DIGITALOCEAN_SSH_KEY_FINGERPRINT in the format of "8d:30:8a..."
    # with a comand like "ssh-keygen -E md5 -lf  ~/.ssh/id_rsa.pub"
    # DIGITALOCEAN_REGION pick your region from "doctl compute region list"
    # DIGITALOCEAN_IMAGE pick your distribution image
    # "doctl compute image list-distribution

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
      dvcvm${server}
    done
    exit 0
fi

if [ $1 == gce ]; then
    echo "Creating Google Compute Engine machines..."

    # GOOGLE_APPLICATION_CREDENTIALS=$HOME/gce-credentials.json
    # GOOGLE_PROJECT_ID "gcloud projects list"
    # GOOGLE_ZONE "gcloud compute zones list"
    # GOOGLE_MACHINE_SIZE "gcloud compute machine-types list"
    # GOOGLE_MACHINE_IMAGE "gcloud compute images list --uri"
    # The absolute URL to a base VM image to instantiate

    for server in $(seq 1 $END); do
      docker-machine create \
      --driver=google \
      --google-project ${GOOGLE_PROJECT_ID} \
      --google-zone ${GOOGLE_ZONE} \
      --google-machine-type ${GOOGLE_MACHINE_SIZE} \
      --google-machine-image ${GOOGLE_MACHINE_IMAGE} \
      gcevm${server}
    done
    exit 0
fi
