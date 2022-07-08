mariadb-server:
  pkg.installed

mariadb-client:
   pkg.installed

mysql_service_enabled:
  service.running:
    - name: mysql
    - enable: True
