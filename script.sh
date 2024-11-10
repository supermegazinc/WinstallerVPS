#!/bin/bash

iso_os_url="https://ia600508.us.archive.org/13/items/tiny-10-23-h2/tiny10%20x64%2023h2.iso"
iso_driver_url="https://drive.massgrave.dev/en-us_windows_server_2019_x64_dvd_f9475476.iso"

apt update -y && apt upgrade -y
apt install grub2 wimtools ntfs-3g -y

echo -e "\nWInstallerVPS 1.0 by supermegazinc. All credits to Ghostyenc."
sleep 2

disk="$1"

if [ -z "$disk" ]; then
    echo "No disk specified. Using default: /dev/sda"
    disk="/dev/sda"
fi

if [ ! -b "$disk" ]; then
    echo "Unknown disk"
    exit 1
fi

disk_size_kb=$(lsblk -bno SIZE "$disk" | head -n 1)
disk_size_gb=$(( disk_size_kb / 1024 / 1024 / 1024 ))

if [ "$disk_size_gb" -lt 20 ]; then
    echo "Not enough space"
    exit 1
fi

for part in $(lsblk -ln -o NAME "$disk" | tail -n +2); do
    mount_point=$(findmnt -n -o TARGET "/dev/$part")
    if [ -n "$mount_point" ]; then
        umount "$mount_point" &
    fi
done
wait

lsof | grep "$disk" | awk '{print $2}' | xargs -r kill -9

parted "$disk" --script mklabel gpt
parted "$disk" --script mkpart primary ntfs 1MB 10GB
parted "$disk" --script mkpart primary ntfs 10GB 20GB
blockdev --rereadpt "$disk"

for part in "${disk}1" "${disk}2"; do
    mkfs.ntfs -F "$part"
done
blockdev --rereadpt "$disk"

echo -e "r\ng\np\nw\nY\n" | gdisk "$disk"
blockdev --rereadpt "$disk"

mount "${disk}1" /mnt
mkdir -p /mnt/boot/grub
grub-install --root-directory=/mnt "$disk"
cd /mnt/boot/grub
cat <<EOF > grub.cfg
menuentry "Install OS" {
	insmod ntfs
	search --set=root --file=/bootmgr
	ntldr /bootmgr
	boot
}
EOF

mkdir -p windisk
mount "${disk}2" windisk
cd /root/windisk
mkdir winfile

wget -O os.iso $iso_os_url & 
wget -O driver.iso $iso_driver_url &
wait

mount -o loop os.iso winfile
rsync -avz --progress winfile/* /mnt
umount winfile

mount -o loop driver.iso winfile
mkdir /mnt/sources/virtio
rsync -avz --progress winfile/* /mnt/sources/virtio
umount winfile

cd /mnt/sources
touch cmd.txt
echo 'add virtio /virtio_drivers' >> cmd.txt
wimlib-imagex update boot.wim 2 < cmd.txt

reboot