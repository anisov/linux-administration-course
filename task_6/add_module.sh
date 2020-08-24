
#!/bin/bash

# Create dir for own module.
mkdir /usr/lib/dracut/modules.d/01test

# Copy scripts.
cp /vagrant/scripts/* /usr/lib/dracut/modules.d/01test/

# Recreate initramfs.
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

# Change grub. Delete rhgb quiet params.
sed -i 's/rhgb quiet//g' /etc/default/grub
grub2-mkconfig -o /boot/grub2/grub.cfg

reboot