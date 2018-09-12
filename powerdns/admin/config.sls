config.py:
  file.managed:
    - name: /opt/pirates/powerdns-admin/config.py
    - source: salt://powerdns/admin/conf/config.py
    - template: jinja
    - user: pirates
    - group: pirates
    - mode: 755
    - makedirs: True

powerdns-admin.service:
  file.managed:
    - name: /usr/lib/systemd/system/powerdns-admin.service
    - source: salt://powerdns/admin/service/powerdns-admin.service
    - user: root
    - group: root
    - makedirs: True
    - require:
      - file: config.py

systemd powerdns-admin.service:
  cmd.run:
    - cwd: /usr/lib/systemd/system
    - name: systemctl enable powerdns-admin.service
    - unless: test -e /etc/systemd/system/multi-user.target.wants/powerdns-admin.service
    - require:
      - file: powerdns-admin.service

powerdns-admin:
  service.running:
    - name: powerdns-admin
    - enable: True
    - sig: powerdns-admin
    - require:
      - cmd: systemd powerdns-admin.service
    - watch:
      - file: config.py