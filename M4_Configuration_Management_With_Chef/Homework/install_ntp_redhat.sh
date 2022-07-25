#!/bin/bash

echo "* Install chrony ..."
dnf install -y chrony

echo "* Enable and start chrony ..."
systemctl enable --now chronyd

echo "* Set SELinux to permissive mode ..."
setenforce permissive
sed -i 's\=enforcing\=permissive\g' /etc/sysconfig/selinux
