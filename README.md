# Docker Machine Scripts

#### Description:
Create virtual machines using docker-machine with VirtualBox or Digital Ocean

> Must have [VirtualBox](https://www.virtualbox.org) installed or a [Digital Ocean](https://www.digitalocean.com) account or a [Google Cloud Platform](https://cloud.google.com) account.  You must have `doctl` installed if you're using Digital Ocean or `gcloud` for for Google Cloud Platform.

#### Create Virtual Machines:
Argument must be 'virtualbox', 'do' or 'gce', second argument is number of machines to create (default 1).

example:

`./create-servers.sh virtualbox 3`

#### Join Swarm:

`./create-swarm.sh virtualbox`

#### Delete Virtual Machines:

`./delete-servers.sh virtualbox`


##### Digital Ocean Environmental Variables:

<pre>
DIGITALOCEAN_ACCESS_TOKEN get the token from digitalocean.com (read/write)
DIGITALOCEAN_SIZE pick your droplet size from "doctl compute size list"
DIGITALOCEAN_SSH_KEY_FINGERPRINT in the format of "8d:30:8a..." with a comand like "ssh-keygen -E md5 -lf  ~/.ssh/id_rsa.pub"
DIGITALOCEAN_REGION pick your region from "doctl compute region list"
DIGITALOCEAN_IMAGE pick your distribution image "doctl compute image list-distribution"
</pre>


```bash
export DIGITALOCEAN_ACCESS_TOKEN="your_token_id"; \
export DIGITALOCEAN_SSH_KEY_FINGERPRINT="ssh-key-fingerprint"; \
export DIGITALOCEAN_IMAGE="centos-7-x64"; \
export DIGITALOCEAN_SIZE="1Gb"; \
export DIGITALOCEAN_REGION="nyc3"
```

##### Google Cloud Platform Variables:

<pre>
GOOGLE_APPLICATION_CREDENTIALS=$HOME/gce-credentials.json
GOOGLE_PROJECT_ID "gcloud projects list"
GOOGLE_ZONE "gcloud compute zones list"
GOOGLE_MACHINE_SIZE "gcloud compute machine-types list"
GOOGLE_MACHINE_IMAGE "gcloud compute images list --uri"
The absolute URL to a base VM image to instantiate
</pre>


```bash
export GOOGLE_APPLICATION_CREDENTIALS="$HOME/gce-crendentials.json" ; \
export GOOGLE_PROJECT_ID="your-project-id" ; \
export GOOGLE_ZONE="us-east1-b" ; \
export GOOGLE_MACHINE_SIZE="g1-small" ; \
export GOOGLE_MACHINE_IMAGE="https://www.googleapis.com/compute/v1/projects/centos-cloud/global/images/centos-7-v20190515" 
```

