#!/bin/bash

# Install utils.
BASE_DIR='/root'
yum install -y vim redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils gcc
# Download srpm package.
wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm -O $BASE_DIR/nginx-1.14.1-1.el7_4.ngx.src.rpm
rpm -i $BASE_DIR/nginx-1.14.1-1.el7_4.ngx.src.rpm
# Download openssl source.
wget https://www.openssl.org/source/openssl-1.1.1i.tar.gz -O $BASE_DIR/latest.tar.gz
tar -xvf $BASE_DIR/latest.tar.gz -C $BASE_DIR/
# Install dependence.
yum-builddep -y $BASE_DIR/rpmbuild/SPECS/nginx.spec
# Change spec.
sed -i '116i --with-openssl='$BASE_DIR/openssl-1.1.1i' \\' $BASE_DIR/rpmbuild/SPECS/nginx.spec
# Build rpm package.
rpmbuild -bb $BASE_DIR/rpmbuild/SPECS/nginx.spec
# Install rpm nginx.
yum localinstall -y $BASE_DIR/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm
# Start nginx.
systemctl start nginx
# Create dir for own repo.
mkdir /usr/share/nginx/html/repo
# Add rpm package in repo.
cp $BASE_DIR/rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/
wget https://downloads.percona.com/downloads/percona-release/percona-release-1.0-9/redhat/percona-release-1.0-9.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm
# Create repo.
createrepo /usr/share/nginx/html/repo
# Change nginx default.conf
sed -i 's/index  index.html index.htm;/index  index.html index.htm; autoindex on;/g' /etc/nginx/conf.d/default.conf
# Reload nginx.
nginx -t
nginx -s reload
# Add own repo in system.
cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo/
gpgcheck=0
enabled=1
EOF
# Install percona-release from own repo.
yum install percona-release -y
