#!/bin/bash

# Задаем переменные.
VG_MAIN='VolGroup00'
LV_MAIN='LogVol00'
LV_HOME="LV_HOME"
LV_HOME_SNAP="LV_HomeSnapshot"

# Монтируем главый lvm для удаление данных из /var.
mount /dev/$VG_MAIN/$LV_MAIN /mnt
rm -rf /mnt/var/*
umount /mnt

# Создание лоигческого тома для /home.
lvcreate -n $LV_HOME -L 5G /dev/$VG_MAIN
# Создаём файловую систему.
mkfs.ext4 /dev/$VG_MAIN/$LV_HOME
# Монтируем новый логический том в /mnt, копируем данные с /home в него, далее очищаем старый /home 
# и монтируем данный логический том в /home.
mount /dev/$VG_MAIN/$LV_HOME /mnt/

# Копируем всю информацию в новый том и удалём со старого.
cp -aR /home/* /mnt/
rm -rf /home/*

# Размонтируем и монтируем данный том к /home/.
umount /mnt/
mount /dev/$VG_MAIN/$LV_HOME /home/
# Добовляем авто монтирование.
echo "/dev/mapper/$VG_MAIN-$LV_HOME /home ext4 defaults 0 0" >> /etc/fstab

# Создание снэпшота и мёрдж снэпшота с тестовыми данными.
echo 123 > /home/test.txt
lvcreate -L 1GB -s -n $LV_HOME_SNAP /dev/$VG_MAIN/$LV_HOME
rm -rf /home/test.txt
cd / 
umount /home
lvconvert --merge /dev/$VG_MAIN/$LV_HOME_SNAP
mount /dev/$VG_MAIN/$LV_HOME /home
reboot

