#!/bin/bash

# Set variables
VG_OLD='VolGroup00' # Old name
VG_NEW='NewRoot' # New name 

# Change vg name.
vgrename $VG_OLD $VG_NEW

# Change configs.
sed -i 's/'$VG_OLD'/'$VG_NEW'/g' /etc/fstab /etc/default/grub /boot/grub2/grub.cfg

# Recreate initramfs, that the new name would apply.
mkinitrd -f -v /boot/initramfs-$(uname -r).img $(uname -r)

# Restart system.
reboot