#/bin/bash

echo "* Disable firewalld ..."
systemctl disable --now firewalld

echo "* Restart docker ..."
systemctl restart docker

echo "* Create docker network ..."
docker network create rabbitmq-net

echo "* Run prometheus container on port 9090 ..."
docker container run -d --name prometheus --net rabbitmq-net -p 9090:9090 -v /vagrant/prometheus.yml:/etc/prometheus/prometheus.yml prom/prometheus

echo "* Run grafana container on port 3000 ..."
docker volume create grafana
docker container run -d --rm --name grafana --net rabbitmq-net -p 3000:3000 -v grafana:/var/lib/grafana grafana/grafana-oss

echo "* Create cluster volume files ..."
for i in {1..3}; do mkdir -p rabbitmq/node-${i} && tee ./rabbitmq/node-${i}/rabbitmq<<-EOF
cluster_formation.peer_discovery_backend = rabbit_peer_discovery_classic_config
cluster_formation.classic_config.nodes.1 = rabbit@rabbitmq-1
cluster_formation.classic_config.nodes.2 = rabbit@rabbitmq-2
cluster_formation.classic_config.nodes.3 = rabbit@rabbitmq-3
EOF
done

echo "* Join RabbitMQ nodes in containerized cluster ..."
docker run -d --rm --name rabbitmq-1 --hostname rabbitmq-1 --net rabbitmq-net -p 8081:15672 -p 15692:15692 \
-v /home/vagrant/rabbitmq/node-1/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq  \
-e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.10-management

docker run -d --rm --name rabbitmq-2 --hostname rabbitmq-2 --net rabbitmq-net -p 8082:15672 \
-v /home/vagrant/rabbitmq/node-2/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq  \
-e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.10-management

docker run -d --rm --name rabbitmq-3 --hostname rabbitmq-3 --net rabbitmq-net -p 8083:15672 \
-v /home/vagrant/rabbitmq/node-3/:/config/ -e RABBITMQ_CONFIG_FILE=/config/rabbitmq  \
-e RABBITMQ_ERLANG_COOKIE=ABCDEFFGHIJKLMOP rabbitmq:3.10-management

echo "* Enable federation and prometheus plugins on the cluster's nodes ..."
docker container exec rabbitmq-1 rabbitmq-plugins enable rabbitmq_federation 
docker container exec rabbitmq-2 rabbitmq-plugins enable rabbitmq_federation
docker container exec rabbitmq-3 rabbitmq-plugins enable rabbitmq_federation
docker container exec rabbitmq-1 rabbitmq-plugins enable rabbitmq_prometheus
docker container exec rabbitmq-2 rabbitmq-plugins enable rabbitmq_prometheus
docker container exec rabbitmq-3 rabbitmq-plugins enable rabbitmq_prometheus

echo "* Set ha policy to replicate queues to all nodes ..."
docker container exec rabbitmq-1 rabbitmqctl set_policy ha-fed \
".*" '{"federation-upstream-set":"all", "ha-sync-mode":"automatic", "ha-mode":"nodes", "ha-params":["rabbit@rabbit-1","rabbit@rabbit-2","rabbit@rabbit-3"]}' \
--priority 1 --apply-to queues

echo "* Create docker image build context ..."
mkdir consumer
cp /vagrant/consumer/consumer.py consumer/
mkdir producer
cp /vagrant/producer/producer.py producer/

echo "* Build consumer and producer images ..."
docker image build -t cons -f /vagrant/consumer/Dockerfile .
docker image build -t prod -f /vagrant/producer/Dockerfile .

echo "* Run containerized consumers ..."
docker container run -d --name cons-crit-warn --rm --net rabbitmq-net cons "*.crit" "*.warn"
docker container run -d --name cons-ram --rm --net rabbitmq-net cons "ram.*"

echo "* Run containerized producer ..."
docker container run -d --name prod-con --rm --net rabbitmq-net prod
