#!/bin/bash

echo "* Copy web app and database ..."
mkdir m4_homework && cd m4_homework
cp -r /vagrant/db/ .
cp -r /vagrant/web/ .
