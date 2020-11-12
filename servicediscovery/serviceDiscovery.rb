#!/usr/bin/env ruby
require 'json'

# --- available ENV Vars --- (defined by Sprint2)
# EXOSCALE_KEY
# EXOSCALE_SECRET
# EXOSCALE_ZONE (e.g. at-vie-1)
# EXOSCALE_ZONE_ID
# EXOSCALE_INSTANCEPOOL_ID
# TARGET_PORT

isLocal = false

poolID = isLocal ? "InstancePool_MyService" : "#{ENV['EXOSCALE_INSTANCEPOOL_ID']}"
nodeExpPort = isLocal ? "9100" : "#{ENV['TARGET_PORT']}"
zone = isLocal ? "at-vie-1" : "#{ENV['EXOSCALE_ZONE']}"
filepath = isLocal ? "./config.json" : "/srv/service-discovery/config.json" # make this ENV configurable when strint 2 is over
scrapeTime = 15

while true
    instances = %x{ exo instancepool show #{poolID} -z #{zone} --output-template \"\{\{ .Instances \}\}\" --output-format json }

    # remove [] -> trim whitespaces, slpit by whitespaces
    instances = instances.tr('[]', '').strip.split(' ', -1)
    instanceIPs = []
    instances.each do |instance|
        instanceIP = %x{ exo vm show #{instance} --output-template \"\{\{ .IPAddress \}\}\" }

        if (isLocal)
            puts instance + " : " + instanceIP
        end

        # remove \n from ip (recieved from exo command)
        instanceIP = instanceIP.delete_suffix("\n")

        instanceIPs.push(instanceIP + ":" + nodeExpPort)
    end

    json = {
        'targets' => instanceIPs,
        'labels' => {}
    }

    json = "[" + JSON[json] + "]"

    File.write(filepath, json)
    if (isLocal)
        puts "#{scrapeTime}s pause"
    end
    sleep scrapeTime
end