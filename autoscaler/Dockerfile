FROM ubuntu

# copy service to container
COPY autoscaler.rb /
RUN chmod +x autoscaler.rb

# download cli from github
ADD https://github.com/exoscale/cli/releases/download/v1.20.2/exoscale-cli_1.20.2_linux_amd64.deb /
RUN dpkg -i exoscale-cli_1.20.2_linux_amd64.deb

# get CA cert and ruby
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN apt-get install -y ruby

# install ruby gems
# -N to remove docs
RUN gem install -N sinatra
RUN gem install -N cloudstack_client

ENTRYPOINT ["ruby", "autoscaler.rb"]
