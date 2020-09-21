#!/bin/bash

touch /etc/sysconfig/logfile
mkdir /var/log/test/

echo "ALERT" >> /var/log/test/logfile.log
echo 'WORD="ALERT"' >> /etc/sysconfig/logfile
echo 'LOG=/var/log/test/logfile.log' >> /etc/sysconfig/logfile

chmod +x /vagrant/data/logfile.sh
cp /vagrant/data/logfile.service /etc/systemd/system/
cp /vagrant/data/logfile.timer /etc/systemd/system/

systemctl enable logfile.timer
systemctl start logfile.timer
systemctl status logfile.timer
