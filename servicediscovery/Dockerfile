FROM ubuntu

# copy service to container
COPY serviceDiscovery.sh /
RUN chmod +x serviceDiscovery.sh

# download cli from github
ADD https://github.com/exoscale/cli/releases/download/v1.20.2/exoscale-cli_1.20.2_linux_amd64.deb /
RUN dpkg -i exoscale-cli_1.20.2_linux_amd64.deb

# prepare folder for exoscale.toml
RUN mkdir root/.config
RUN mkdir root/.config/exoscale/

# get certificate stuff
RUN apt update
RUN apt-get install -y ca-certificates

ENTRYPOINT ["/serviceDiscovery.sh"]
