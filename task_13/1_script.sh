yum install -y epel-release
yum install -y setools setroubleshoot-server nginx
systemctl enable nginx --now  
systemctl status nginx  

sed -i '/listen       80 default_server;/a \\tlisten       6781 ;' /etc/nginx/nginx.conf
systemctl restart nginx.service
systemctl status nginx

# 1 solution.
semanage port -l | grep http
semanage port -a -t http_port_t -p tcp 6781  
semanage port -l | grep http
systemctl restart nginx.service
systemctl status nginx  
ss -tulpn | column -t | grep nginx 

# 2 solution.
semanage port -d -t http_port_t -p tcp 6781 
echo > /var/log/audit/audit.log

systemctl restart nginx  
systemctl status nginx  

ausearch -c "nginx" --raw | audit2allow -M se-nginx  
semodule -i se-nginx.pp
systemctl restart nginx 
systemctl status nginx
ss -tulpn | column -t | grep nginx
