{% from "powerdns/map.jinja" import powerdns with context %}

setup-1-required-packages.sh:
  file.managed:
    - name: /tmp/setup-1-required-packages.sh
    - source: salt://powerdns/admin/tmp/setup-1-required-packages.sh
    - user: root
    - group: root
    - mode: 755

setup-2-project-code.sh:
  file.managed:
    - name: /tmp/setup-2-project-code.sh
    - source: salt://powerdns/admin/tmp/setup-2-project-code.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: setup-1-required-packages.sh

exec setup-1-required-packages.sh:
  cmd.run:
    - cwd: /tmp
    - name: ./setup-1-required-packages.sh
    - runas: root
    - require:
      - file: setup-2-project-code.sh

exec setup-2-project-code.sh:
  cmd.run:
    - cwd: /tmp
    - name: ./setup-2-project-code.sh
    - runas: pirates
    - require:
      - cmd: exec setup-1-required-packages.sh

config.py:
  file.managed:
    - name: /opt/pirates/powerdns-admin/config.py
    - source: salt://powerdns/admin/conf/config.py
    - template: jinja
    - user: pirates
    - group: pirates
    - mode: 755
    - require:
      - cmd: exec setup-2-project-code.sh

setup-3-database.sh:
  file.managed:
    - name: /tmp/setup-3-database.sh
    - source: salt://powerdns/admin/tmp/setup-3-database.sh
    - user: root
    - group: root
    - mode: 755
    - require:
      - file: config.py

exec setup-3-database.sh:
  cmd.run:
    - cwd: /tmp
    - name: ./setup-3-database.sh
    - runas: pirates
    - require:
      - file: setup-3-database.sh

powerdns-admin.service:
  file.managed:
    - name: /usr/lib/systemd/system/powerdns-admin.service
    - source: salt://powerdns/admin/service/powerdns-admin.service
    - user: root
    - group: root
    - makedirs: True
    - require:
      - cmd: exec setup-3-database.sh

systemd powerdns-admin.service:
  cmd.run:
    - cwd: /usr/lib/systemd/system
    - name: systemctl enable powerdns-admin.service
    - unless: test -e /etc/systemd/system/multi-user.target.wants/powerdns-admin.service
    - require:
      - file: powerdns-admin.service
      
powerdns-admin:
  service.running:
    - enable: True
    - sig: powerdns-admin
    - require:
      - cmd: systemd powerdns-admin.service
    - watch:
      - file: config.py