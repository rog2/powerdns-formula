{% from "powerdns/map.jinja" import powerdns with context %}

forward-zones-config:
  file.managed:
    - name: {{ powerdns.recursor.forward_zones_file}}
    - source: salt://powerdns/conf/forward/zones
    - user: root
    - group: root
    - mode: 655
    - makedirs: True

recursor-config:
  file.managed:
    - name: {{ powerdns.recursor.config_file }}
    - source: salt://powerdns/conf/recursor.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 600
    - makedirs: True
    - require:
      - file: forward-zones-config

recursor-server:
  service.running:
    - name: {{ powerdns.recursor.service }}
    - enable: True
    - require:
      - file: recursor-config
    - watch:
      - file: recursor-config