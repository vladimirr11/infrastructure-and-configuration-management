#/bin/bash

echo "* Import RabbitMQ signing keys ..."
rpm --import https://github.com/rabbitmq/signing-keys/releases/download/2.0/rabbitmq-release-signing-key.asc
rpm --import https://packagecloud.io/rabbitmq/erlang/gpgkey
rpm --import https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey

echo "* Copy RabbitMQ repository file ..."
cp /vagrant/rabbitmq.repo /etc/yum.repos.d/

echo "* Update packages metadata ..."
dnf -q makecache -y --disablerepo='*' --enablerepo='rabbitmq_erlang' --enablerepo='rabbitmq_server'

echo "* Install socat and logrotate ..."
dnf install -y socat logrotate

echo "* Install RbbitMQ server and Erlang ..."
dnf install --repo rabbitmq_erlang --repo rabbitmq_server erlang-24.3.4 rabbitmq-server -y

echo "* Enable and start RabbitMQ server..."
systemctl enable --now rabbitmq-server

echo "* Disable firewalld ..."
systemctl disable --now firewalld
