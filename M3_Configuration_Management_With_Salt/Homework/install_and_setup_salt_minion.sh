#!/bin/bash

echo "* Download the Salt bootstrap script ..."
wget -O bootstrap-salt.sh https://bootstrap.saltstack.com

echo "* Install the Salt minion ..."
sh bootstrap-salt.sh

echo "* Set up the Salt master ..."
sed -i 's/#master: salt/master: web/g' /etc/salt/minion

echo "* Restart Salt minion ..."
systemctl restart salt-minion
