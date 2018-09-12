{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.mysql.python-mysql
  
grant-per-init-powerdns-database.sql:
  file.managed:
    - name: /tmp/grant-per-init-powerdns-database.sql
    - source: salt://powerdns/sql/grant-per-init-powerdns-database.sql
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - require:
      - pip: python-mysql

init-powerdns-database.sql:
  file.managed:
    - name: /tmp/init-powerdns-database.sql
    - source: salt://powerdns/sql/init-powerdns-database.sql
    - user: root
    - group: root
    - mode: 600
    - require:
      - file: grant-per-init-powerdns-database.sql

root-connection:
  mysql_database.present:
    - name: {{ powerdns.mysql.pdns.database }}
    - connection_host: {{ powerdns.mysql.pdns.host }}
    - connection_port: {{ powerdns.mysql.pdns.port }}
    - connection_user: {{ powerdns.mysql.pdns.root_user }}
    - connection_pass: "{{ powerdns.mysql.pdns.root_password }}"
    - require:
      - file: init-powerdns-database.sql

grant-per-init-powerdns-database:
  mysql_query.run_file:
    - name: grant-per-init-powerdns-database
    - database:  {{ powerdns.mysql.pdns.database }}
    - query_file: /tmp/grant-per-init-powerdns-database.sql
    - use:
      - mysql_database: root-connection


init-powerdns-database:
  mysql_query.run_file:
    - name: init-powerdns-database
    - database:  {{ powerdns.mysql.pdns.database }}
    - query_file: /tmp/init-powerdns-database.sql
    - require:
      - mysql_query: grant-per-init-powerdns-database
    - use:
      - mysql_database: root-connection