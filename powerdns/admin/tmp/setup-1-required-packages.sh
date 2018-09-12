#!/bin/bash

sudo apt-get install -y python3-dev
sudo apt-get install -y libmysqlclient-dev libsasl2-dev libldap2-dev libssl-dev libxml2-dev libxslt1-dev libxmlsec1-dev libffi-dev pkg-config
sudo curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
sudo echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list
sudo apt-get update -y
sudo apt-get install -y yarn
sudo apt-get install -y virtualenv
sudo mkdir -p /opt/pirates
sudo chown -R pirates:pirates /opt