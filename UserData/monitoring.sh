#!/bin/bash
# check loadGenerator+NodeExporter.sh for detailed explanation of the code

set -e

export DEBIAN_FRONTEND=noninteractive

# region Install Docker
# following the guidlines given by the official Docker website: https://docs.docker.com/engine/install/ubuntu/

apt-get update
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

apt-key fingerprint 0EBFCD88

add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io
# endregion

# region create prometheus.yml
# yml taken from official prometheus documentation https://prometheus.io/docs/prometheus/latest/getting_started/
echo """
global:
  scrape_interval: 15s
scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']
  - job_name: 'scrape targets'
    file_sd_configs:
      - files:
          - ${targetFilePath}/config.json
        refresh_interval: 10s
""" >> /srv/prometheus.yml
# endregion

# region create grafana.yml files
echo """
apiVersion: 1
datasources:
- name: Prometheus
  type: prometheus
  access: proxy
  orgId: 1
  url: http://prometheus:9090
  version: 1
  editable: false
""" >> /srv/datasource.yml

echo """
notifiers:
  - name: Scale up
    type: webhook
    uid: scale-up
    org_id: 1
    is_default: false
    send_reminder: true
    disable_resolve_message: true
    frequency: \"2m\"
    settings:
      autoResolve: true
      httpMethod: \"POST\"
      severity: \"critical\"
      uploadImage: false
      url: \"http://autoscaler:8090/up\"
  - name: Scale down
    type: webhook
    uid: scale-down
    org_id: 1
    is_default: false
    send_reminder: true
    disable_resolve_message: true
    frequency: \"2m\"
    settings:
      autoResolve: true
      httpMethod: \"POST\"
      severity: \"critical\"
      uploadImage: false
      url: \"http://autoscaler:8090/down\"
""" >> /srv/notifier.yml

echo """
apiVersion: 1
providers:
- name: 'Home'
  orgId: 1
  folder: ''
  type: file
  updateIntervalSeconds: 10
  options:
    path: /etc/grafana/dashboards
""" >> /srv/dashboard.yml

# region dashboard json
echo """
{
  \"annotations\": {
    \"list\": [
      {
        \"builtIn\": 1,
        \"datasource\": \"-- Grafana --\",
        \"enable\": true,
        \"hide\": true,
        \"iconColor\": \"rgba(0, 211, 255, 1)\",
        \"name\": \"Annotations & Alerts\",
        \"type\": \"dashboard\"
      }
    ]
  },
  \"editable\": true,
  \"gnetId\": null,
  \"graphTooltip\": 0,
  \"id\": 1,
  \"links\": [],
  \"panels\": [
    {
      \"alert\": {
        \"alertRuleTags\": {},
        \"conditions\": [
          {
            \"evaluator\": {
              \"params\": [
                0.8
              ],
              \"type\": \"gt\"
            },
            \"operator\": {
              \"type\": \"and\"
            },
            \"query\": {
              \"params\": [
                \"A\",
                \"5m\",
                \"now\"
              ]
            },
            \"reducer\": {
              \"params\": [],
              \"type\": \"avg\"
            },
            \"type\": \"query\"
          }
        ],
        \"executionErrorState\": \"alerting\",
        \"for\": \"5m\",
        \"frequency\": \"1m\",
        \"handler\": 1,
        \"name\": \"Scale-up\",
        \"noDataState\": \"no_data\",
        \"notifications\": [
          {
            \"uid\": \"scale-up\"
          }
        ]
      },
      \"aliasColors\": {},
      \"bars\": false,
      \"dashLength\": 10,
      \"dashes\": false,
      \"datasource\": \"Prometheus\",
      \"fieldConfig\": {
        \"defaults\": {
          \"custom\": {}
        },
        \"overrides\": []
      },
      \"fill\": 1,
      \"fillGradient\": 0,
      \"gridPos\": {
        \"h\": 9,
        \"w\": 12,
        \"x\": 0,
        \"y\": 0
      },
      \"hiddenSeries\": false,
      \"id\": 2,
      \"legend\": {
        \"avg\": false,
        \"current\": false,
        \"max\": false,
        \"min\": false,
        \"show\": true,
        \"total\": false,
        \"values\": false
      },
      \"lines\": true,
      \"linewidth\": 1,
      \"nullPointMode\": \"null\",
      \"options\": {
        \"alertThreshold\": true
      },
      \"percentage\": false,
      \"pluginVersion\": \"7.3.6\",
      \"pointradius\": 2,
      \"points\": false,
      \"renderer\": \"flot\",
      \"seriesOverrides\": [],
      \"spaceLength\": 10,
      \"stack\": false,
      \"steppedLine\": false,
      \"targets\": [
        {
          \"expr\": \"sum by (instance) (rate(node_cpu_seconds_total{mode!=\\\"idle\\\"}[1m])) / sum by (instance) (rate(node_cpu_seconds_total[1m]))\",
          \"interval\": \"\",
          \"legendFormat\": \"\",
          \"queryType\": \"randomWalk\",
          \"refId\": \"A\"
        }
      ],
      \"thresholds\": [
        {
          \"colorMode\": \"critical\",
          \"fill\": true,
          \"line\": true,
          \"op\": \"gt\",
          \"value\": 0.8
        }
      ],
      \"timeFrom\": null,
      \"timeRegions\": [],
      \"timeShift\": null,
      \"title\": \"CPU Usage\",
      \"tooltip\": {
        \"shared\": true,
        \"sort\": 0,
        \"value_type\": \"individual\"
      },
      \"type\": \"graph\",
      \"xaxis\": {
        \"buckets\": null,
        \"mode\": \"time\",
        \"name\": null,
        \"show\": true,
        \"values\": []
      },
      \"yaxes\": [
        {
          \"format\": \"short\",
          \"label\": null,
          \"logBase\": 1,
          \"max\": null,
          \"min\": null,
          \"show\": true
        },
        {
          \"format\": \"short\",
          \"label\": null,
          \"logBase\": 1,
          \"max\": null,
          \"min\": null,
          \"show\": true
        }
      ],
      \"yaxis\": {
        \"align\": false,
        \"alignLevel\": null
      }
    }
  ],
  \"schemaVersion\": 26,
  \"style\": \"dark\",
  \"tags\": [],
  \"templating\": {
    \"list\": []
  },
  \"time\": {
    \"from\": \"now-6h\",
    \"to\": \"now\"
  },
  \"timepicker\": {},
  \"timezone\": \"\",
  \"title\": \"autoscaler\",
  \"uid\": \"3oht09aGk\",
  \"version\": 1
}
""" >> /srv/dashboard.json
# endregion
# endregion

# creating volume to share target.json
docker volume create --name TargetsVolume
# create docker network
docker network create monitor

docker run \
    -d \
    -p 9090:9090 \
    -v TargetsVolume:${targetFilePath} \
    -v /srv/prometheus.yml:/etc/prometheus/prometheus.yml \
    --name prometheus \
    --net=monitor \
    prom/prometheus

docker run \
    -d \
    -v TargetsVolume:${targetFilePath} \
    -e EXOSCALE_KEY=${exoscale_key} \
    -e EXOSCALE_SECRET=${exoscale_secret} \
    -e EXOSCALE_ZONE=${exoscale_zone} \
    -e EXOSCALE_INSTANCEPOOL_ID=${exoscale_instancepool_id} \
    -e TARGET_PORT=${target_port} \
    --name service-discovery \
    --net=monitor \
    deitsch/exoscale_sd
  
docker run \
  -d \
  -p 3000:3000 \
  -v /srv/datasource.yml:/etc/grafana/provisioning/datasources/datasource.yml \
  -v /srv/dashboard.yml:/etc/grafana/provisioning/dashboards/dashboard.yml \
  -v /srv/notifier.yml:/etc/grafana/provisioning/notifiers/notifier.yml \
  -v /srv/dashboard.json:/etc/grafana/dashboards/dashboard.json \
  --name grafana \
  --net=monitor \
  grafana/grafana

docker run \
  -d \
  -p 8090:8090 \
  --name autoscaler \
  --net=monitor \
  --restart=always \
  quay.io/janoszen/exoscale-grafana-autoscaler