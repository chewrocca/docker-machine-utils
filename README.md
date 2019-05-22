# Docker Machine Scripts

#### Description:
Create virtual machines using docker-machine with VirtualBox or Digital Ocean

> Must have [VirtualBox](https://www.virtualbox.org) installed or an [AWS](https://aws.amazone.com), a [Digital Ocean](https://www.digitalocean.com) account, or a [Google Cloud Platform](https://cloud.google.com) account.  You must have `doctl` installed if you're using Digital Ocean or `gcloud` for for Google Cloud Platform.  If you're using AWS having `aws cli` could be beneficial. 

#### Create Virtual Machines:
Argument must be 'virtualbox', 'do' or 'gce', second argument is number of machines to create (defaults to 1 vm).

example:

`./create-servers.sh virtualbox 3`

#### Join Swarm with all managers:

`./create-swarm.sh virtualbox manager`

#### Join Swarm with workers:

`./create-swarm.sh virtual worker`

##### example output:
```plain
Getting number of machines...
Creating VirtualBox swarm...
Swarm initialized: current node (ipx2hi38ka8lj5ew9mqm7dea8) is now a manager.

To add a worker to this swarm, run the following command:

    docker swarm join --token SWMTKN-1-5qu1bvjtlgwdszz0c4iuloqku3uj2sfa1h2df8p1zcfi631a1s-673n9kovdqm70ztzubi6003yu 192.168.99.140:2377

To add a manager to this swarm, run 'docker swarm join-token manager' and follow the instructions.

Adding worker nodes...
vbvm2:
This node joined a swarm as a worker.
vbvm3:
This node joined a swarm as a worker.
export DOCKER_TLS_VERIFY="1"
export DOCKER_HOST="tcp://192.168.99.140:2376"
export DOCKER_CERT_PATH="$HOME/.docker/machine/machines/vbvm1"
export DOCKER_MACHINE_NAME="vbvm1"
# Run this command to configure your shell:
# eval $(docker-machine env vbvm1)
```

Run `eval $(docker-machine env vbvm1)`

Now docker commands in the shell execute on the vm.
  
```plain
$ docker node ls
ID                            HOSTNAME            STATUS              AVAILABILITY        MANAGER STATUS      ENGINE VERSION
ipx2hi38ka8lj5ew9mqm7dea8 *   vbvm1               Ready               Active              Leader              18.09.6
nkipwypogtonly62pp2187olo     vbvm2               Ready               Active                                  18.09.6
7y4mkg2k649v6zqgdnh6fkad6     vbvm3               Ready               Active                                  18.09.6
```

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

##### AWS EC2:

Create a populated ~/.aws/credentials file.

example:

```plain
[default]
aws_access_key_id = your_access_key
aws_secret_access_key = your_secret_access_key
region=us-east-1
vpc_id = your_vpc_id
```

`--amazonec2-open-port 2377` is added to `create-servers.sh` allow Docker Swarm to work with AWS.