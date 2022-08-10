#!/bin/bash

echo "# Add the repository"
dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "# Install the packages"
dnf install -y docker-ce docker-ce-cli containerd.io

echo "# Start and enable the Docker daemon"
systemctl enable --now docker

echo "# Add vagrant user to the docker group"
usermod -aG docker vagrant
