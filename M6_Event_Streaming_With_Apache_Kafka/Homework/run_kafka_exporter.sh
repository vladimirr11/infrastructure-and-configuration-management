#/bin/bash

echo "Switch to kafka dir..."
cd /home/vagrant/kafka_2.13-3.1.0

echo "* Download kafka_exporter ..."
wget https://github.com/danielqsj/kafka_exporter/releases/download/v1.4.2/kafka_exporter-1.4.2.linux-amd64.tar.gz

echo "* Extract the exporter ..."
tar xzvf kafka_exporter-1.4.2.linux-amd64.tar.gz

echo "* Switch to exporter dir ..."
cd kafka_exporter-1.4.2.linux-amd64/

echo "* Run the exporter ..."
./kafka_exporter --kafka.server=kafka:9092 &> /tmp/kafka-exporter.log &
