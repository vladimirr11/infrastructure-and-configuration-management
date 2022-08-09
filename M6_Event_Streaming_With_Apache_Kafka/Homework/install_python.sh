#/bin/bash

echo "* Install python 3 ..."
sudo dnf install -y python3

echo "* Install kafka-python package ..."
sudo pip3 install kafka-python
