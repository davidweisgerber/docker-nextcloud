FROM ubuntu:16.10

EXPOSE 80

# update and upgrade packages
RUN apt-get update && apt-get upgrade -y
RUN DEBIAN_FRONTEND=noninteractive apt-get install mysql-server apache2 php unzip wget php-mysql php-gd php-json php-xml php-mbstring php-zip php-curl php-bz2 php-intl php-ldap php-net-ldap2 php-net-ldap3 php-smbclient php-imagick ffmpeg php-mcrypt libreoffice php-apcu -y
RUN apt-get clean

RUN mkdir /nextcloud
RUN cd /nextcloud && wget https://download.nextcloud.com/server/releases/nextcloud-9.0.53.zip && unzip nextcloud-9.0.53.zip
RUN rm /nextcloud/nextcloud-9.0.53.zip
RUN ln -s /nextcloud/nextcloud /var/www/html
RUN a2enmod rewrite
RUN a2enmod headers
RUN a2enmod env
RUN a2enmod dir
RUN a2enmod mime
RUN a2enmod setenvif

RUN mkdir /data

ADD setup.sh /nextcloud/setup.sh
RUN chmod 755 /nextcloud/setup.sh
ADD startup.sh /nextcloud/startup.sh
RUN chmod 755 /nextcloud/startup.sh
RUN rm /etc/apache2/sites-available/000-default.conf
ADD 000-default.conf /etc/apache2/sites-available/
RUN rm /etc/php/7.0/apache2/php.ini
ADD php.ini /etc/php/7.0/apache2/php.ini

CMD ["/nextcloud/startup.sh"]
