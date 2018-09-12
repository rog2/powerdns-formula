{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.repo

powerdns-recursor:
  pkg.installed:
    - name:  {{ powerdns.recursor.pkg }}
    - refresh_db: True
    - require:
      - sls: powerdns.repo

  service.running:
    - name: {{ powerdns.recursor.service }}
    - enable: True
    - require:
      - pkg: powerdns-recursor