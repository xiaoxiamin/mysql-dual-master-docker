FROM mysql:5.7
MAINTAINER Tao Wang <twang2218@gmail.com> and Simin <simin_xia@qq.com>
COPY replica.sh /docker-entrypoint-initdb.d/
COPY mysql.sh /
COPY optimised.cnf /etc/mysql/conf.d/
