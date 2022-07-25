#!/bin/bash

echo "* Download and install Chef ..."
wget -P /tmp https://packages.chef.io/files/stable/chef-server/14.14.1/el/8/chef-server-core-14.14.1-1.el7.x86_64.rpm
rpm -Uvh /tmp/chef-server-core-14.14.1-1.el7.x86_64.rpm
