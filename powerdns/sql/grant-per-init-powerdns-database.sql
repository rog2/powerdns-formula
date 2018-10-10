{% from "powerdns/map.jinja" import powerdns with context %}

GRANT ALL PRIVILEGES ON {{ powerdns.mysql.pdns.database }}.* TO '{{ powerdns.mysql.pdns.powerdns_user }}'@'%' IDENTIFIED BY '{{ powerdns.mysql.pdns.powerdns_password }}';
FLUSH PRIVILEGES;