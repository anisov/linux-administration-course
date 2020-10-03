# Create user and admin group.
useradd test_user
groupadd admin 
usermod -aG admin test_user

# Set password.
echo "qwery1234" | passwd --stdin test_user

# We will allow you to log in using a password.
bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"

# Setting the login time limit.
echo '*;*;*;!Wd' >> /etc/security/time.conf
echo '*;*;admin;Al' >> /etc/security/time.conf

# Change pam.d/login
sed -i '5i\account required pam_time.so' /etc/pam.d/login
