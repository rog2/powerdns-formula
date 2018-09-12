{% from "powerdns/map.jinja" import powerdns with context %}

authoritative-mysql-config:
  file.managed:
    - name: {{ powerdns.authoritative.mysql_config_file }}
    - source: salt://powerdns/conf/pdns.d/pdns.gmysql.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 733
    - makedirs: True

authoritative-config:
  file.managed:
    - name: {{ powerdns.authoritative.config_file }}
    - source: salt://powerdns/conf/pdns.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 733
    - require:
      - file: authoritative-mysql-config

authoritative-server:
  service.running:
    - name: {{ powerdns.authoritative.service }}
    - enable: True
    - require:
      - file: authoritative-config
    - watch:
      - file: authoritative-config
      - file: authoritative-mysql-config