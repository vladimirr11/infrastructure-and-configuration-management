#!/bin/bash

echo "* Add Salt's repository key ..."
rpm --import https://repo.saltproject.io/py3/redhat/8/x86_64/latest/SALTSTACK-GPG-KEY.pub

echo "* Add Salt's repository ..."
curl -fsSL https://repo.saltproject.io/py3/redhat/8/x86_64/latest.repo | sudo tee /etc/yum.repos.d/salt.repo

echo "* Install Salt SSH ..."
dnf install -y salt-ssh

echo "* Install Salt Master ..."
wget -O  bootstrap-salt.sh https://bootstrap.saltstack.com
sh bootstrap-salt.sh -M -N -X

echo "* Enable and start Salt ..."
systemctl enable --now salt-master

echo "* Adjust SELinux ..."
setsebool -P httpd_can_network_connect 1

echo "* Open necessary ports ..."
firewall-cmd --permanent --add-port=4505-4506/tcp
firewall-cmd --permanent --zone=public --add-port=3306/tcp
firewall-cmd --reload
