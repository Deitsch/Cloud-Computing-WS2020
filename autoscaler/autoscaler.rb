#!/usr/bin/env ruby
require 'cloudstack_client'
require 'sinatra'

# run ruby autoscaler.rb [-p PORT] [-o HOST]

# --- available ENV Vars --- (defined by Sprint3)
# EXOSCALE_SECRET
# EXOSCALE_KEY
# EXOSCALE_ZONE (e.g. at-vie-1)
# EXOSCALE_ZONE_ID
# EXOSCALE_INSTANCEPOOL_ID
# LISTEN_PORT

isLocal = false

secret = isLocal ? "" : "#{ENV['EXOSCALE_SECRET']}"
key = isLocal ? "" : "#{ENV['EXOSCALE_KEY']}"
poolID = isLocal ? "InstancePool_MyService" : "#{ENV['EXOSCALE_INSTANCEPOOL_ID']}"
zone = isLocal ? "at-vie-1" : "#{ENV['EXOSCALE_ZONE']}"
listenPort = isLocal ? "8090" : "#{ENV['LISTEN_PORT']}"

cs = CloudstackClient::Client.new("https://api.exoscale.com/compute", key, secret)

# sinatra setup
set :run, true
set :port, listenPort
set :bind, '0.0.0.0'

def scaleTo(cs, poolSize, exoPoolId, exoZone)
    puts "scale poolID: #{exoPoolId} in zone: #{exoZone} to size: #{poolSize}"
    # cs.scale_instance_pool(id: exoPoolId, size: poolSize, zoneid: exoZone)                        # <--- not supported sadly
    %x{ exo instancepool update #{exoPoolId} -z #{exoZone} -s #{poolSize} }                         # <--- hacky workaround
    return "scaleTo #{exoPoolId} to #{poolSize}"
end

def getCurrentPoolSize(cs)
    return cs.list_virtual_machines(state: "running").count - 1 # -1 to remove monitoring instance
end


post '/up' do
    response = scaleTo(cs, getCurrentPoolSize(cs) + 1, poolID, zone)
    "Scaling up\n#{response}"
end

post '/down' do
    response = "Pool can't be smaller than 1 instance"
    currentPoolSize = getCurrentPoolSize(cs)
    if currentPoolSize > 1
        response = scaleTo(cs, currentPoolSize - 1, poolID, zone)
    end
    "Scaling down\n#{response}"
end

# only needed because of mistake in testing tool !!

get '/up' do
    response = scaleTo(cs, getCurrentPoolSize(cs) + 1, poolID, zone)
    "Scaling up\n#{response}"
end

get '/down' do
    response = "Pool can't be smaller than 1 instance"
    currentPoolSize = getCurrentPoolSize(cs)
    if currentPoolSize > 1
        response = scaleTo(cs, currentPoolSize - 1, poolID, zone)
    end
    "Scaling down\n#{response}"
end
