#/bin/bash

echo "* Switch to working dir ..."
cd kafka_2.13-3.1.0/

echo "* Edit zookeeper main configuration file ..."
tee -a ./config/zookeeper.properties<<EOF
tickTime = 2000
initLimit = 5
syncLimit = 2
server.1=kafka:2888:3888
EOF

echo "* Create default folder and my ID file ..."
mkdir /tmp/zookeeper
cat << EOF > /tmp/zookeeper/myid
1
EOF

echo "* Adjust confgi/server.properties file ..."
sed -i 's/broker.id=0/broker.id=1/g' ./config/server.properties
sed -i 's@#advertised.listeners=PLAINTEXT://your.host.name:9092@advertised.listeners=PLAINTEXT://kafka:9092@g' ./config/server.properties
sed -i 's/zookeeper.connect=localhost:2181/zookeeper.connect=kafka:2181/g' ./config/server.properties

echo "* Start the zookeepr in background mode ..."
./bin/zookeeper-server-start.sh -daemon config/zookeeper.properties

echo "* Start the broker server in background mode ..."
./bin/kafka-server-start.sh -daemon config/server.properties

# echo "* Create topic m6-homework and run producer and consumer for a while ..."
# bin/kafka-topics.sh --create --bootstrap-server localhost:9092 --replication-factor 1 --partitions 3 --topic m6-homework
# python3 /vagrant/code/m6hw_producer.py &> /tmp/m6hw_producer.log &
# python3 /vagrant/code/m6hw_consumer_subscribe.py &> /tmp/m6hw_consumer.log &
