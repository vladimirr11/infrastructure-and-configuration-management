#!/bin/bash

echo "* Add EPEL repository ..."
dnf install -y epel-release

echo "* Install Ansible ..."
dnf install -y ansible

echo "* Open port 3306 ..."
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --reload
