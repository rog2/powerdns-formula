{% from "powerdns/map.jinja" import powerdns with context %}

resolved.conf:
  file.managed:
    - name: /etc/systemd/resolved.conf
    - source: salt://powerdns/conf/resolved.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 666
    - makedirs: True

systemd-resolved:
  service.running:
    - name: systemd-resolved
    - enable: True
    - require:
      - file: resolved.conf
    - watch:
      - file: resolved.conf

modify-dns-setting.sh:
  file.managed:
    - name: /tmp/modify-dns-setting.sh
    - source: salt://powerdns/authoritative/tmp/modify-dns-setting.sh
    - template: jinja
    - user: root
    - group: root
    - mode: 722

exec modify-dns-setting.sh:
  cmd.run:
    - cwd: /tmp
    - name: ./modify-dns-setting.sh
    - runas: root
    - require:
      - file: modify-dns-setting.sh
