#!/bin/bash

echo "* Download and install Chef workstation ..."
wget -P /tmp https://packages.chef.io/files/stable/chef-workstation/22.4.861/el/8/chef-workstation-22.4.861-1.el8.x86_64.rpm
rpm -Uvh /tmp/chef-workstation-22.4.861-1.el8.x86_64.rpm

echo "* Install git ..."
dnf install -y git
