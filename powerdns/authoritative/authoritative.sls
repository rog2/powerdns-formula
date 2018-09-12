{% from "powerdns/map.jinja" import powerdns with context %}

include:
  - powerdns.repo
      
powerdns-authoritative:
  pkg.installed:
    - name:  {{ powerdns.authoritative.pkg }}
    - refresh_db: True
    - require:
      - sls: powerdns.repo

  service.running:
    - name: {{ powerdns.authoritative.service }}
    - enable: True

powerdns_backend_mysql:
  pkg.installed:
    - name: {{ powerdns.authoritative.backend_mysql_pkg }}
    - refresh_db: True
    - require:
      - pkg: powerdns-authoritative

