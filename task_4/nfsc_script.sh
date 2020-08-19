# Start and enable services.
for i in rpcbind nfs-server nfs-lock nfs-idmap; do
    systemctl start $i
    systemctl enable $i
done

# Add alias for servers.
echo -e "192.168.50.10 nfss" >> /etc/hosts
echo -e "192.168.50.11 nfsc" >> /etc/hosts

# Mount nfs.
mkdir -p /mnt/nfs/
mount -t nfs -o rw,nosuid,noexec,soft,intr,proto=udp,vers=3  nfss:/mnt/nfs /mnt/nfs

# Auto mount nfs.
echo "nfss:/mnt/nfs /mnt/nfs nfs rw,noauto,nosuid,noexec,soft,intr,proto=udp,vers=3,rsize=32768,wsize=32768 0 0 " >> /etc/fstab