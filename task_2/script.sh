#!/bin/bash

mkdir -p ~root/.ssh
cp ~vagrant/.ssh/auth* ~root/.ssh
yum install -y mdadm smartmontools hdparm gdisk parted
mdadm —create —verbose /dev/md10 —level=10 —raid-devices=4 /dev/sdb /dev/sdc /dev/sdd /dev/sde
parted -s -a optimal -- /dev/sdf \
    mklabel gpt \
    mkpart primary 2048s 50MiB \
    mkpart primary 50MiB 80MiB \
    mkpart primary 80MiB 170MiB \
    mkpart primary 170MiB 200MiB \
    mkpart primary 200MiB -2048s
mkdir -p /gpt_disks/part_{1,2,3,4,5}
for i in $(seq 1 5); do mkfs.ext4 /dev/sdf$i; done
for i in $(seq 1 5); do mount /dev/sdf$i /gpt_disks/part_$i; done
for i in $(seq 1 5); do echo "/dev/sdf$i /gpt_disks/part_$i ext4 defaults 0 0" >> /etc/fstab; done