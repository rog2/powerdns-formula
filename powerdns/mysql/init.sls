{% from "powerdns/map.jinja" import powerdns with context %}

mysql-setup:
  debconf.set:
    - name: mysql-server
    - data:
        'mysql-server/root_password': {'type': 'string', 'value': '{{ powerdns.mysql.pdns.root_password }}'}
        'mysql-server/root_password_again': {'type': 'string', 'value': '{{ powerdns.mysql.pdns.root_password }}'}

mysql-server:
  pkg:
    - installed
    - require:
      - debconf: mysql-setup

mysql-client: pkg.installed