#!/bin/bash

#--------------------------------------------#
# Install docker and docker-compose          #
#--------------------------------------------#
                 
## Install docker and apps
sudo yum install -y yum-utils device-mapper-persistent-data lvm2
sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
#sudo usermod -aG docker $(whoami)

## Start and enable docker service
sudo systemctl start docker
sudo systemctl enable docker

## Download and make executable docker-compose binary file
sudo curl -L "https://github.com/docker/compose/releases/download/1.23.1/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

#--------------------------------------------#
# Create docker-compose file for Prometheus  #
#--------------------------------------------#
mkdir /tmp/prometheus
cat << EOF > /tmp/prometheus/prometheus.yml 
global:
  scrape_interval:     5s
  evaluation_interval: 5s

  external_labels:
      monitor: 'prometheus-metrics'

alerting:
  alertmanagers:
  - static_configs:
    - targets:
      - alertmanager:9093

rule_files:
  - "alert.rules"

scrape_configs:
  - job_name: 'prometheus'
    scrape_interval: 5s
    static_configs:
      - targets: ['localhost:9090']

  - job_name: 'blackbox_web'
    metrics_path: /probe
    params:
      module: [http_2xx]
    static_configs:
      - targets:
        - http://bntu.by
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackbox:9115
EOF

## Create yaml file for alert rules
cat << EOF > /tmp/prometheus/alert.rules
groups:
- name: blackbox_web
  rules:
  - alert: blackbox_web_down
    expr: probe_success{instance="http://bntu.by",job="blackbox_web"} == 0
    for: 3s
    labels:
      severity: critical
    annotations:
      summary: "web is down"

EOF

mkdir /tmp/alertmanager
## Create a config file of alerting
cat << EOF > /tmp/alertmanager/config.yml
route:
  repeat_interval: 1h
  receiver: email
  routes:
    - match:
        alertname: blackbox_web_down
      receiver: email


receivers:
- name: email
  email_configs:
  - to: $TO_EMAIL
    from: $EMAIL
    smarthost: $PORT
    auth_username: $EMAIL
    auth_identity: $EMAIL
    auth_password: $PASSWORD
EOF

mkdir /tmp/grafana

mkdir /tmp/grafana/dashboards
wget -O node-item.json https://grafana.com/api/dashboards/11074/revisions/4/download
cd /tmp

cat << EOF > /tmp/docker-compose.yml
version: '3'

networks:
  vpc-network:
    driver: bridge

volumes:
    prometheus_data: {}
    grafana_data: {}

services:
  prometheus:
    image: prom/prometheus:latest
    container_name: prometheus
    volumes:
      - ./prometheus/:/etc/prometheus/
      - prometheus_data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'  
    restart: unless-stopped
    expose:
      - 9090
    ports:
      - "9090:9090"
    networks:
      - vpc-network
      
  node-exporter:
    image: prom/node-exporter
    ports:
      - 9100:9100
    restart: unless-stopped
    deploy:
      mode: global
      
  alertmanager:
   image: prom/alertmanager
   container_name: alertmanager
   volumes: 
     - ./alertmanager/:/etc/alertmanager/
   command:
     - '--config.file=/etc/alertmanager/config-email.yml'
     - '--storage.path=/alertmanager'
     - '--web.listen-address=0.0.0.0:9093'
   restart: unless-stopped
   ports:
     - "9093:9093"
   networks:
     - vpc-network

  blackbox-exporter:
   image: prom/blackbox-exporter
   container_name: blackbox
   restart: unless-stopped
   ports:
     - "9115:9115"
   networks:
     - vpc-network

  grafana:
   image: grafana/grafana:latest
   container_name: grafana
   volumes:
#     - grafana_data:/var/lib/grafana
     - ./grafana/dashboards:/etc/grafana/dashboards
#     - ./grafana/setup.sh:/setup.sh
#   entrypoint: /setup.sh
   environment:
     - GF_SECURITY_ADMIN_USER=admin
     - GF_SECURITY_ADMIN_PASSWORD=admin
     - GF_USERS_ALLOW_SIGN_UP=false
   restart: unless-stopped
   expose:
     - 3000
   ports:
     - 3000:3000
   networks:
     - vpc-network
EOF

cd /tmp
## Start the container by docker-compose
sudo /usr/local/bin/docker-compose up -d
