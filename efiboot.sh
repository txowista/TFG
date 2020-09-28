#/bin/bash
mkdir -p /target/boot/efi/EFI/BOOT
cp /cdrom/igor/BOOTX64ASKSERVER.EFI /target/boot/efi/EFI/BOOT/BOOTX64.EFI
for i in /sys /proc /dev; do mount --bind $i /target$i; done
cat <<EOF | chroot /target
efibootmgr -c -d /dev/sda -p 1 -w -L enigmedia -l '\EFI\BOOT\BOOTX64.EFI'; \
exit;
EOF
for i in /sys /proc /dev; do umount /target$i; done
