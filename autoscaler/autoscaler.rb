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
    puts "size: #{size}"
    puts "zoneID: #{zid}"
    puts "poolID: #{pid}"
    cs.scale_instance_pool(id: pid, size: size, zoneid: zid)
    return "scaleTo #{size}, #{id}"
end

def getCurrentPoolSize(cs)
    return cs.list_virtual_machines(state: "running").count - 1 # -1 to remove monitoring instance
end


post '/up' do
    response = scaleTo(cs, getCurrentPoolSize(cs) + 1, poolID, zoneID)
    "Scaling up\n#{response}"
end

post '/down' do
    response = "Failed"
    currentPoolSize = getCurrentPoolSize(cs)
    if currentPoolSize > 1
        response = scaleTo(cs, currentPoolSize - 1, poolID, zoneID)
    end
    "Scaling down\n#{response}"
end

