#/bin/bash
mkdir -p /target/boot/efi/EFI/BOOT
cp /cdrom/igor/BOOTX64ASKCIPHER.EFI /target/boot/efi/EFI/BOOT/BOOTX64ASK.EFI
cp /cdrom/igor/BOOTX64.EFI /target/boot/efi/EFI/BOOT/BOOTX64.EFI
cp -r /cdrom/igor /target/tmp
cp /tmp/variable.txt /target/tmp/variable.txt
cp script_ch.sh /target/tmp
for i in /sys /proc /dev; do mount --bind $i /target$i; done
cat <<EOF | chroot /target
sh /tmp/script_ch.sh
exit;
EOF
for i in /sys /proc /dev; do umount /target$i; done
umount -lf /target
#umount /dev/.static/dev
#dd if=/cdrom/igor/systemimage.sqsh of=/dev/mapper/vg_root-root bs=128K
