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

# Создание специального логческого тома для бэкапа.
pvcreate /dev/sdb
vgcreate $BUP_VG /dev/sdb
lvcreate -n $BUP_LV -l +100%FREE /dev/$BUP_VG
# Создание файловой системы.
mkfs.xfs /dev/$BUP_VG/$BUP_LV
# Монтирование нового тома в /mnt для переноса данных.
mount /dev/$BUP_VG/$BUP_LV /mnt
# Используем xfsdump и xfsrestore для создание и восстановление бэкапа в новом томе.
xfsdump -J - /dev/$VG_MAIN/$LV_MAIN | xfsrestore -J - /mnt
# Переконфигурируем grub.
config_grub $VG_MAIN $LV_MAIN $BUP_VG $BUP_LV
reboot
