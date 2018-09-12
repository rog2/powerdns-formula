{% from "powerdns/map.jinja" import powerdns with context %}

nginx-pkg:
  pkg.installed:
    - name:  nginx