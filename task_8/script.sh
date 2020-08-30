#!/bin/bash

# Actiavte zfs
modprobe zfs

###### 1. Definition of the best compression algorithm ######

# Create zfs pool
zpool create testpool /dev/sdb

# Create fs with gzip compression
zfs create testpool/gzip_fs
zfs set compression=gzip testpool/gzip_fs

# Create fs with lzjb compression
zfs create testpool/lzjb_fs
zfs set compression=lzjb testpool/lzjb_fs

# Create fs with zle compression
zfs create testpool/zle_fs
zfs set compression=zle testpool/zle_fs

# Create fs with lz4 compression
zfs create testpool/lz4_fs
zfs set compression=lz4 testpool/lz4_fs

# Download file
wget -O /tmp/War_and_Peace.txt http://www.gutenberg.org/files/2600/2600-0.txt

ls -lah /tmp | grep War_and_Peace.txt

# Copy file
cp /tmp/War_and_Peace.txt /testpool/gzip_fs
cp /tmp/War_and_Peace.txt /testpool/lzjb_fs
cp /tmp/War_and_Peace.txt /testpool/zle_fs
cp /tmp/War_and_Peace.txt /testpool/lz4_fs

# Show info about zfs filesystems
zfs list -o name,mountpoint,used,compression,compressratio

###### END ######

###### 2. Work with pool ######
# Downloading pool
curl -L "https://drive.google.com/u/0/uc?id=1KRBNW33QWqbvbVHa3hLJivOAt60yukkg&export=download" > /tmp/zfs_task1.tar.gz

# Extract pool
cd /tmp/
tar -xvzf /tmp/zfs_task1.tar.gz

# Importing pool
zpool import -d /tmp/zpoolexport/ otus

# Get status and info
zpool status otus
zpool list otus

zfs list zpoolexport -o name,mountpoint,recordsize,compression,checksum
###### END ######

###### 3. Find message in snapshot ######

# Downloading snapshot
curl -L "https://drive.google.com/u/0/uc?id=1gH8gCL9y7Nd5Ti3IRmplZPF1XjzxeRAG&export=download" > /tmp/otus_task2.file

# Recieving snapshot
zfs recv testpool/otus_task2 < /tmp/otus_task2.file

# Find secret info
find /testpool/otus_task2 -name "secret*" -exec cat {} +
###### END ######
