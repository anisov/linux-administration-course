#!/bin/bash

# Задаем переменные.
BUP_VG='VG_Backup'
BUP_LV='LV_Backup'
VG_Var="VG_Var"
LV_Var="LV_Var"

# Удаляем после перезагрузки том, который использовался для бэкапа.
lvremove -y /dev/$BUP_VG/$BUP_LV
vgremove -y /dev/$BUP_VG

# Создание зеркального тома для /var и перенос данных из старого /var в новый через монтирование нового тома в /mnt.
pvcreate /dev/sdc /dev/sdd -y
vgcreate $VG_Var /dev/sdc /dev/sdd
lvcreate -L 500M -m1 -n $LV_Var $VG_Var

# Создаём файловую систему.
mkfs.ext4 /dev/$VG_Var/$LV_Var

# Монтируем новый том в /mnt.
mount /dev/$VG_Var/$LV_Var /mnt

# Копируем все данные в новый том.
cp -aR /var/* /mnt/

# Размонтируем и монтируем данный том к /var.
umount /mnt
mount /dev/$VG_Var/$LV_Var /var

# Добовляем авто монтирование.
echo "/dev/mapper/$VG_Var-$LV_Var /var ext4 defaults 0 0" >> /etc/fstab
reboot
