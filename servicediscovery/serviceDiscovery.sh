#!/bin/bash

set -e

echo """
defaultaccount = \"deitsch\"

[[accounts]]
  account = \"deitsch\"
  defaultTemplate = \"Linux Ubuntu 20.04 LTS 64-bit\"
  defaultZone = ${EXOSCALE_ZONE}
  endpoint = \"https://api.exoscale.ch/v1\"
  environment = \"api\"
  key = ${EXOSCALE_KEY}
  name = \"deitsch\"
  secret = ${EXOSCALE_SECRET}
""" >>  /root/.config/exoscale/exoscale.toml 

while true; do
    TMPFILE=/tmp/$$

    echo '[' > $TMPFILE
    echo '  {' >> $TMPFILE
    echo -n '    "targets": [' >> $TMPFILE

    INDEX=0
    RunningInstances=$(exo instancepool show InstancePool_MyService -z ${EXOSCALE_ZONE} --output-template "{{ .Instances }}" --output-format json | sed -e 's/\[//' -e 's/\]//')
    for instance in $RunningInstances; do
        if [ $INDEX -ne 0 ]; then
            echo -n ',' >>$TMPFILE
        fi
        instanceIP=$(exo vm show $instance --output-template "{{ .IPAddress }}")
        echo "$instance : $instanceIP"
        echo -n "\"${instanceIP}:9100\"" >> $TMPFILE
        let INDEX=${INDEX}+1
    done

    echo '],' >>$TMPFILE
    echo '    "labels": {}' >>$TMPFILE
    echo '  }' >>$TMPFILE
    echo ']' >>$TMPFILE

    mv $TMPFILE "/service-discovery/targets.json"

    sleep 5
done