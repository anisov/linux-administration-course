yum install epel-release -y && yum install spawn-fcgi php mod_fcgid httpd -y
sed -i 's/#SOCKET/SOCKET/' /etc/sysconfig/spawn-fcgi
sed -i 's/#OPTION/OPTION/' /etc/sysconfig/spawn-fcgi
cp /vagrant/data/spawn-fcgi.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl start spawn-fcgi.service
sudo systemctl status spawn-fcgi.service