#!/bin/bash

echo "* Install Apache Web Server ..."
dnf install -y httpd

echo "* Enable and start Apache ..."
systemctl enable --now httpd

echo "* Copy web app ..."
cp -r /vagrant/web/* /var/www/html/

echo "* Install php 7.2 ..."
dnf install -y php php-mysqlnd

echo "* Restart Apache ..."
systemctl restart httpd

echo "* Adjust firewall ..."
firewall-cmd --permanent --zone=public --add-service=http
firewall-cmd --reload
