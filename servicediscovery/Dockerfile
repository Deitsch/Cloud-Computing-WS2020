FROM ubuntu

# copy service to container
# COPY serviceDiscovery.sh /
# RUN chmod +x serviceDiscovery.sh
COPY serviceDiscovery.rb /
RUN chmod +x serviceDiscovery.rb

# download cli from github
ADD https://github.com/exoscale/cli/releases/download/v1.20.2/exoscale-cli_1.20.2_linux_amd64.deb /
RUN dpkg -i exoscale-cli_1.20.2_linux_amd64.deb

# get CA cert and ruby
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN apt-get install -y ruby

ENTRYPOINT ["ruby", "serviceDiscovery.rb"]
