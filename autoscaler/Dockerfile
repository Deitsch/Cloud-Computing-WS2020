FROM ubuntu
# FROM ruby

# copy service to container
COPY autoscaler.rb /
RUN chmod +x autoscaler.rb
COPY scale.py /
RUN chmod +x scale.py

# get CA cert and ruby
RUN apt-get update
RUN apt-get install -y ca-certificates
RUN apt-get install -y ruby

ENTRYPOINT ["ruby", "autoscaler.rb"]
