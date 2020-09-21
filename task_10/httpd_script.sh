#!/bin/bash
yum install httpd -y
cp /vagrant/data/httpd@.service /etc/systemd/system/httpd@.service
cp /etc/sysconfig/httpd /etc/sysconfig/httpd-first
cp /etc/sysconfig/httpd /etc/sysconfig/httpd-second
echo "OPTIONS=-f conf/httpd_first.conf" > /etc/sysconfig/httpd-first
echo "OPTIONS=-f conf/httpd_second.conf" > /etc/sysconfig/httpd-second
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_first.conf
cp /etc/httpd/conf/httpd.conf /etc/httpd/conf/httpd_second.conf
sed -i 's/Listen 80/Listen 3001/' /etc/httpd/conf/httpd_first.conf
sed -i 's/Listen 80/Listen 3002/' /etc/httpd/conf/httpd_second.conf
echo 'PidFile /var/run/httpd_first.pid' >> /etc/httpd/conf/httpd_first.conf
echo 'PidFile /var/run/httpd_second.pid' >> /etc/httpd/conf/httpd_second.conf
sed -i 's/"logs\/error_log"/"logs\/error_httpd_first"/' /etc/httpd/conf/httpd_first.conf
sed -i 's/"logs\/error_log"/"logs\/error_httpd_second"/' /etc/httpd/conf/httpd_second.conf
setenforce 0
systemctl stop httpd
systemctl disable httpd
systemctl start httpd@first.service
systemctl start httpd@second.service
systemctl status httpd@first.service
systemctl status httpd@second.service
