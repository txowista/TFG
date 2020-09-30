#/bin/bash
mkdir -p /target/boot/efi/EFI/BOOT
cp /cdrom/igor/BOOTX64ASKCIPHER.EFI /target/boot/efi/EFI/BOOT/BOOTX64.EFI
cp /cdrom/igor/libsapi0/libsapi0_2.0-1_amd64.deb /target/tmp
cp /cdrom/igor/tpm2_1.0-1_amd64.deb /target/tmp
cp /cdrom/igor/tpm2-tools_3.0.2-1_amd64.deb /target/tmp
for i in /sys /proc /dev; do mount --bind $i /target$i; done
cat <<EOF | chroot /target
efibootmgr -c -d /dev/mmcblk0 -p 1 -w -L enigmedia -l '\EFI\BOOT\BOOTX64.EFI'; \
dpkg -i /tmp/libsapi0_2.0-1_amd64.deb; \
dpkg -i /tmp/tpm2_1.0-1_amd64.deb; \
dpkg -i /tmp/tpm2-tools_3.0.2-1_amd64.deb; \
exit;
EOF
for i in /sys /proc /dev; do umount /target$i; done
umount -lf /target
umount /dev/.static/dev
#dd if=/cdrom/igor/systemimage.sqsh of=/dev/mapper/vg_root-root bs=128K
