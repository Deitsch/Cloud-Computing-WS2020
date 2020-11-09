#!/bin/bash

# Abort if an error happens
set -e

# Do not ask any questions and assume the defaults
export DEBIAN_FRONTEND=noninteractive

# region Install Docker
# steps taken from official Docker Documentation: https://docs.docker.com/engine/install/ubuntu/

# updates installed packages
apt-get update
# installs new packages (-y to auto yes)
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

# https://explainshell.com/explain?cmd=curl+-fsSL+example.org
# download official public PGP Key for Docker on Linux/Ubuntu and add to local keys
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Verify key with fingerprint by checking last 8 didgits
apt-key fingerprint 0EBFCD88

# set up stable repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# update repositories (needed cause we jsut added new one)
apt-get update

# installing docker engin
apt-get install -y docker-ce docker-ce-cli containerd.io
# endregion

# region Launch containers

# Run the load generator
# -d -- silent
# --restart=always -- always restart on exit (independet of exit state)
# -p publish port on outside
docker run -d \
  --restart=always \
  -p 8080:8080 \
  janoszen/http-load-generator:1.0.1

# Run the node exporter
docker run -d \
 --restart=always \
 --net="host" \
 --pid="host" \
 -v "/:/host:ro,rslave" \
 quay.io/prometheus/node-exporter \
 --path.rootfs=/host

# endregion