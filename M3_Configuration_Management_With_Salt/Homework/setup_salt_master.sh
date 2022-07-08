#!/bin/bash

echo "* Edit the roster file ..."
tee /etc/salt/roster <<EOF
db:
  host: 192.168.99.101
  user: vagrant
  passwd: vagrant
  sudo: True
EOF

echo "* Register the minion ..."
salt-key -y -A

echo "* Initialize Salt State Tree ..."
sed -i '677,679s/^#//' /etc/salt/master

echo "* Restart the master ..."
systemctl restart salt-master

echo "* Switch to working dir ..."
mkdir -p /srv/salt/ && cd /srv/salt

echo "* Copy sls files ..."
cp /vagrant/install-mariadb.sls .
cp /vagrant/top.sls .

echo "* Install and start MariaDB Server and Client on the minion ..."
salt 'db*' state.highstate

echo "* Configure MariaDB Server on the minion to allow remote connection ..."
salt-ssh -i 'db*' cmd.run 'sudo sed -i "s/bind-address *= 127.0.0.1/bind-address = 192.168.99.101/g" /etc/mysql/mariadb.conf.d/50-server.cnf'
salt-ssh -i 'db*' cmd.run 'sudo systemctl restart mariadb'

echo "* Add target database on the minion..."
salt-ssh -i 'db*' cmd.run 'mysql -uroot < /home/vagrant/m3_homework/db_setup.sql'
