#!/bin/bash
# check loadGenerator+NodeExporter.sh for detailed explanation of the code

set -e

export DEBIAN_FRONTEND=noninteractive

# region Install Docker
# following the guidlines given by the official Docker website: https://docs.docker.com/engine/install/ubuntu/

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# create prometheus.yml on instance
# yml taken from official prometheus documentation https://prometheus.io/docs/prometheus/latest/getting_started/
echo """
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
""" >> /srv/prometheus.yml

# pass it to docker
docker run \
    -d \
    -p 9090:9090 \
    -v /srv/prometheus.yml:/etc/prometheus/prometheus.yml \
    prom/prometheus