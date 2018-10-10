{% from "powerdns/map.jinja" import powerdns with context %}

GRANT ALL PRIVILEGES ON {{ powerdns.mysql.admin.database }}.* TO '{{ powerdns.mysql.admin.admin_user }}'@'%' IDENTIFIED BY '{{ powerdns.mysql.admin.admin_password }}';
FLUSH PRIVILEGES;