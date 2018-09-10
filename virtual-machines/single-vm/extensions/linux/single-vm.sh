#
# single-vm.sh
#
#!/bin/bash
sh install-apache.sh

# Format and mount drive 1
partprobe
echo ';' | sfdisk /dev/sdd
partprobe
mkfs -t ext3 /dev/sdd1
mkdir -p /data2
if grep -qs '/data2' /proc/mounts; then
    echo "already mounted."
else
    mount /dev/sdc1 /data1
fi

# Format and mount drive 2
partprobe
echo ';' | sfdisk /dev/sdc
partprobe
mkfs -t ext3 /dev/sdc1
mkdir -p /data1
if grep -qs '/data1' /proc/mounts; then
    echo "already mounted."
else
    mount /dev/sdc1 /data1
fi