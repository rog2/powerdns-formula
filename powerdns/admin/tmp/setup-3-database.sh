#!/bin/bash

cd /opt/pirates/powerdns-admin/
 . ./flask/bin/activate
export FLASK_APP=app/__init__.py
export LC_ALL=C.UTF-8
export LANG=C.UTF-8
flask db upgrade
yarn install --pure-lockfile
flask assets build

