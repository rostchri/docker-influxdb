http://acidwords.com/posts/2016-02-28-installing-grafana-riemann-and-influxdb.html

influxdb:
CREATE DATABASE collectdb1
CREATE DATABASE snmp1
CREATE DATABASE riemann
CREATE USER riemann WITH PASSWORD 'riemann_password'
GRANT ALL ON riemann TO riemann

