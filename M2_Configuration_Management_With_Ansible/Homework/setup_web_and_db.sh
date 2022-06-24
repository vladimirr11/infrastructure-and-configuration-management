#!/bin/bash

echo "* Switch to working dir ..."
mkdir m2_homework && cd m2_homework

echo "* Copy app ..."
cp -r /vagrant/web .

echo "* Copy inventory, ansible.cfg, and playbook files ..."
cp /vagrant/inventory .
cp /vagrant/ansible.cfg .
cp /vagrant/playbook_web.yml .
cp /vagrant/playbook_db.yml .

echo "* Adjust SELinux ..."
setsebool -P httpd_can_network_connect 1

echo "* Run playbooks ..."
ansible-playbook playbook_web.yml
ansible-playbook playbook_db.yml

echo "* Configure MariaDB server to allow remote connection ..."
ansible dbservers -i inventory -a "sed -i 's/bind-address *= 127.0.0.1/bind-address = 192.168.99.101/g' /etc/mysql/mariadb.conf.d/50-server.cnf" --become
ansible dbservers -i inventory -a "systemctl restart mariadb" --become

echo "* Add database ..."
ansible dbservers -i inventory -m shell -a "mysql -uroot < /home/vagrant/m2_homework/db_setup.sql" --become
