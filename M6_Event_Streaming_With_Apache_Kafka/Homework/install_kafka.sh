#/bin/bash

echo "* Install Java and nano ..."
sudo dnf install -y java-17-openjdk nano

echo "* Disable the firewall ..."
sudo systemctl disable --now firewalld

echo "* Download the latest Apache Kafak package ..."
wget https://dlcdn.apache.org/kafka/3.1.0/kafka_2.13-3.1.0.tgz

echo "* Extract the Apache Kafka package ..."
tar xzvf kafka_2.13-3.1.0.tgz
