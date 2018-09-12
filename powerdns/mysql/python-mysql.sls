{% from "powerdns/map.jinja" import powerdns with context %}

python-mysql:
  pip.installed:
    - name: PyMySQL
    - user: root