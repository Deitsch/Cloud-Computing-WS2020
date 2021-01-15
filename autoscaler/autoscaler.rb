#!/usr/bin/env ruby
require "cloudstack_client"
require 'sinatra'

# run ruby autoscaler.rb [-p PORT] [-o HOST]

# --- available ENV Vars --- (defined by Sprint3)
# EXOSCALE_SECRET
# EXOSCALE_KEY
# EXOSCALE_ZONE (e.g. at-vie-1)
# EXOSCALE_ZONE_ID
# EXOSCALE_INSTANCEPOOL_ID
# LISTEN_PORT

isLocal = true

secret = isLocal ? "" : "#{ENV['EXOSCALE_SECRET']}"
key = isLocal ? "" : "#{ENV['EXOSCALE_KEY']}"
poolID = isLocal ? "InstancePool_MyService" : "#{ENV['EXOSCALE_INSTANCEPOOL_ID']}"
zoneID = isLocal ? "4da1b188-dcd6-4ff5-b7fd-bde984055548" : "#{ENV['EXOSCALE_ZONE_ID']}"
listenPort = isLocal ? "8090" : "#{ENV['LISTEN_PORT']}"

cs = CloudstackClient::Client.new("https://api.exoscale.com/compute", key, secret)

def scaleTo(cs, size, pid, zid)
    puts "scale poolID: #{pid} in zoneID: #{zid} to size: #{size}"
    # cs.scale_instance_pool(id: pid, size: size, zoneid: zid)                                  # <--- not supported sadly
    %x{ python3 scale.py #{size} }                                                              # <--- hacky workaround
    return "scaleTo #{pid} to #{size}"
end

def getCurrentPoolSize(cs)
    return cs.list_virtual_machines(state: "running").count - 1 # -1 to remove monitoring instance
end


post '/up' do
    response = scaleTo(cs, getCurrentPoolSize(cs) + 1, poolID, zoneID)
    "Scaling up\n#{response}"
end

post '/down' do
    response = "Pool can't be smaller than 1 instance"
    currentPoolSize = getCurrentPoolSize(cs)
    if currentPoolSize > 1
        response = scaleTo(cs, currentPoolSize - 1, poolID, zoneID)
    end
    "Scaling down\n#{response}"
end

