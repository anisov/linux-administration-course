#!/bin/bash

# Задаем переменные.
VG_MAIN='VolGroup00'
LV_MAIN='LogVol00'
BUP_VG='VG_Backup'
BUP_LV='LV_Backup'

function config_grub {
    for i in /proc/ /sys/ /dev/ /run/ /boot/; do
        mount --bind $i /mnt$i;
    done
    grub2-mkconfig -o /boot/grub2/grub.cfg
    sed -i "s+root=/dev/mapper/$1-$2+root=/dev/mapper/$3-$4+" /boot/grub2/grub.cfg
    sed -i "s+rd.lvm.lv=$1/$2+rd.lvm.lv=$3/$4+" /boot/grub2/grub.cfg
}

# Тоже самое что в script_1, только в обратном порядке, данный механизм необходим был для того, что бы уменьшить старый том до 8GB.
lvremove -y /dev/$VG_MAIN/$LV_MAIN
lvcreate -y -L 8G -n $LV_MAIN $VG_MAIN
mkfs.xfs /dev/$VG_MAIN/$LV_MAIN
mount /dev/$VG_MAIN/$LV_MAIN /mnt
xfsdump -J - /dev/$BUP_VG/$BUP_LV | xfsrestore -J - /mnt
config_grub $BUP_VG $BUP_LV $VG_MAIN $LV_MAIN
reboot
