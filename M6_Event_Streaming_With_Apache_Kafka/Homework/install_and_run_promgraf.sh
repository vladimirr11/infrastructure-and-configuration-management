#/bin/bash

echo "* Install nano ..."
dnf install -y nano

echo "* Install Prometheus ..."
wget https://github.com/prometheus/prometheus/releases/download/v2.35.0/prometheus-2.35.0.linux-amd64.tar.gz
tar xzvf prometheus-2.35.0.linux-amd64.tar.gz

echo "* Edit prometheus.yml file ..."
tee ./prometheus-2.35.0.linux-amd64/prometheus.yml<<EOF
global:
  scrape_interval: 30s
  evaluation_interval: 30s

scrape_configs:
  - job_name: 'prometheus'
    static_configs:
    - targets: ['monitor:9090']
  - job_name: 'kafka-exporter'
    static_configs:
    - targets: ['kafka:9308']
EOF

echo "* Install grafana ..."
wget https://dl.grafana.com/oss/release/grafana-8.5.2-1.x86_64.rpm
sudo yum install -y grafana-8.5.2-1.x86_64.rpm

echo "* Start grafana-server ..."
systemctl daemon-reload
systemctl enable --now grafana-server

echo "* Disable the firewall ..."
systemctl disable --now firewalld

echo "* Run prometheus ..."
cd prometheus-2.35.0.linux-amd64/ 
./prometheus --config.file prometheus.yml --web.enable-lifecycle &> /tmp/prometheus.log &
