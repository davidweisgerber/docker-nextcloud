#!/bin/bash

cd /nextcloud/nextcloud

if [ ! -d "/data/config" ]; then
  mv config /data
fi
rm -rf config
ln -s /data/config config

if [ ! -d "/data/mysql" ]; then
  rm -rf /var/lib/mysql && mkdir /data/mysql && ln -s /data/mysql /var/lib/mysql && chmod 777 /var/lib/mysql 
  /usr/sbin/mysqld --initialize-insecure
  /etc/init.d/mysql start

  source <(grep = /etc/mysql/debian.cnf | sed 's/ *= */=/g')
  mysql -uroot -e "CREATE USER 'debian-sys-maint'@'localhost' IDENTIFIED BY '$password'"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'debian-sys-maint'@'localhost' WITH GRANT OPTION"
  mysql -uroot -e "CREATE DATABASE nextcloud"
  mysql -uroot -e "CREATE USER 'nextcloud'@'%' IDENTIFIED BY 'nextcloud'"
  mysql -uroot -e "GRANT ALL PRIVILEGES ON *.* TO 'nextcloud'@'%' WITH GRANT OPTION"
  
else
  rm -rf /var/lib/mysql
  ln -s /data/mysql /var/lib/mysql
  chmod -R 777 /var/lib/mysql
fi

chmod -R 777 /data

