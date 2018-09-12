nginx.conf:
  file.managed:
    - name: /etc/nginx/nginx.conf
    - source: salt://powerdns/admin/nginx/conf/nginx.conf
    - user: root
    - group: root
    - mode: 644
    - makedirs: True

powerdns-admin.conf:
  file.managed:
    - name: /etc/nginx/conf.d/powerdns-admin.conf
    - source: salt://powerdns/admin/nginx/conf/powerdns-admin.conf
    - template: jinja
    - user: root
    - group: root
    - mode: 644
    - makedirs: True
    - require:
      - file: nginx.conf

nginx-service:
  service.running:
    - name: nginx
    - enable: True
    - reload: True
    - require:
      - file: powerdns-admin.conf
    - watch:
      - file: powerdns-admin.conf
      - file: nginx.conf