#!/bin/sh

# update
rpm -ivh http://dl.fedoraproject.org/pub/epel/6/x86_64/epel-release-6-8.noarch.rpm
rpm -ivh http://rpms.famillecollet.com/enterprise/remi-release-6.rpm

#yum -y update --enablerepo=rpmforge,epel,remi,remi-php55


# ntp, timezone
yum -y install ntp
/sbin/service ntpd start
/sbin/chkconfig ntpd on
cp -p /usr/share/zoneinfo/Japan /etc/localtime


# iptables
iptables -F
service iptables stop
chkconfig iptables off


# php
yum -y install --enablerepo=remi --enablerepo=remi-php55 php php-common php-opcache php-mbstring php-mcrypt php-mysqlnd php-phpunit-PHPUnit php-pecl-xdebug php-gd php-bcmath
yum -y install --enablerepo=remi gd-last
yum -y install --enablerepo=remi ImageMagick-last

mv /etc/php.ini /etc/php.ini.org
cp /vagrant/vagrant.config/php.ini /etc/php.ini


# apache2
yum -y install httpd
cp /vagrant/vagrant.config/httpd.conf /etc/httpd/conf.d/vagrant.conf
mv /etc/httpd/conf.d/welcome.conf /etc/httpd/conf.d/welcome.conf.org
chkconfig httpd on


# mysql
yum -y install --enablerepo=remi mysql-server
yum -y install --enablerepo=remi-php55 phpMyAdmin

chkconfig mysqld on
/etc/rc.d/init.d/mysqld start
mysqladmin -f -u root drop test
mysqladmin -u root password 'mysql'

# phpmyadmin
mv /etc/httpd/conf.d/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf.org
cp /vagrant/vagrant.config/phpMyAdmin.conf /etc/httpd/conf.d/phpMyAdmin.conf

mv  /etc/phpMyAdmin/config.inc.php /etc/phpMyAdmin/config.inc.php.org
cp /vagrant/vagrant.config/phpmyconfig.inc.php /etc/phpMyAdmin/config.inc.php

# git
yum -y install git

# services
service httpd start

# ToDo: xdebug
# ToDo: ssl
yum -y install mod_ssl
mv /etc/httpd/conf.d/ssl.conf /etc/httpd/conf.d/ssl.conf.org
cp /vagrant/vagrant.config/ssl.conf /etc/httpd/conf.d/ssl.conf
mv /etc/pki/tls/openssl.cnf /etc/httpd/conf.d/openssl.cnf.org
cp /vagrant/vagrant.config/openssl.cnf /etc/pki/tls/openssl.cnf


cp /vagrant/vagrant.config/ssl_testdomain.conf /etc/httpd/conf.d/ssl_testdomain.conf
mkdir /etc/pki/tls/private
cp /vagrant/vagrant.config/testdomain.crt /etc/pki/tls/testdomain.crt
cp /vagrant/vagrant.config/testdomain-nopass.key /etc/pki/tls/private/testdomain-nopass.key



# services
service httpd restart

# composer
curl -sS https://getcomposer.org/installer | php
mv composer.phar /usr/local/bin/composer


