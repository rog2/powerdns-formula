#!/bin/bash

git clone https://github.com/rog2/PowerDNS-Admin.git /opt/pirates/powerdns-admin --depth=1
cd /opt/pirates/powerdns-admin
virtualenv -p python3 flask
. ./flask/bin/activate
pip install -r requirements.txt
pip install gunicorn
pip install python-dotenv
