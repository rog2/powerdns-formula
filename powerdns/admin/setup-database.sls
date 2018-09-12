{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.mysql.python-mysql

grant-per-init-admin-database.sql:
  file.managed:
    - name: /tmp/grant-per-init-admin-database.sql
    - source: salt://powerdns/sql/grant-per-init-admin-database.sql
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pip: python-mysql

admin-root-connection:
  mysql_database.present:
    - name: {{ powerdns.mysql.admin.database }}
    - connection_host: {{ powerdns.mysql.admin.host }}
    - connection_port: {{ powerdns.mysql.admin.port }}
    - connection_user: {{ powerdns.mysql.admin.root_user }}
    - connection_pass: "{{ powerdns.mysql.admin.root_password }}"
    - require:
      - file: grant-per-init-admin-database.sql

grant-per-init-admin-database:
  mysql_query.run_file:
    - name: grant-per-init-powerdns-database
    - database:  {{ powerdns.mysql.admin.database }}
    - query_file: /tmp/grant-per-init-admin-database.sql
    - use:
      - mysql_database: admin-root-connection