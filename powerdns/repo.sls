{% from "powerdns/map.jinja" import powerdns with context %}

powerdns-authoritative-repo:
  pkgrepo.managed:
    - humanname: PowerDNS
    - name: deb [arch=amd64] https://repo.powerdns.com/{{ salt['grains.get']('os').lower() }} {{ salt['grains.get']('oscodename') }}-auth-{{ powerdns.repo.release }} main
    - file: /etc/apt/sources.list.d/pdns.list
    - keyid: {{ powerdns.repo.keyid }}
    - keyserver: keys.gnupg.net

powerdns-recursor-repo:
  pkgrepo.managed:
    - humanname: PowerDNS
    - name: deb [arch=amd64] https://repo.powerdns.com/{{ salt['grains.get']('os').lower() }} {{ salt['grains.get']('oscodename') }}-rec-{{ powerdns.repo.release }} main
    - file: /etc/apt/sources.list.d/pdns.list
    - keyid: {{ powerdns.repo.keyid }}
    - keyserver: keys.gnupg.net