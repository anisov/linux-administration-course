# Create users and admin group.
useradd test_user
useradd test_user1
groupadd admin 
usermod -aG admin test_user

# Change date for weekend.
date -s "4 OCT 2020 18:00:00"

# Set password.
echo "vagrant" | passwd --stdin test_user
echo "vagrant" | passwd --stdin test_user1

# We will allow you to log in using a password.
bash -c "sed -i 's/^PasswordAuthentication.*$/PasswordAuthentication yes/' /etc/ssh/sshd_config && systemctl restart sshd.service"

# Setting the login time limit.
echo '*;*;*;!Wd' >> /etc/security/time.conf

# Change pam.d/login & sshd
# The pam_time module does not work with groups, add this line.
sed -i '5i\account    [success=1 default=ignore] pam_succeed_if.so user ingroup admin' /etc/pam.d/login
sed -i '6i\account required pam_time.so' /etc/pam.d/login
sed -i '7i\account    [success=1 default=ignore] pam_succeed_if.so user ingroup admin' /etc/pam.d/sshd 
sed -i '8i\account required pam_time.so' /etc/pam.d/sshd 