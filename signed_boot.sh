#/bin/bash
install -d /tmp/bootdebian
mount netinst/boot/grub/efi.img /tmp/bootdebian
sbsign --key certificates/db.key --cert certificates/db.crt --output /tmp/bootdebian/efi/boot/bootx64.efi /tmp/bootdebian/efi/boot/bootx64.efi
sbsign --key certificates/db.key --cert certificates/db.crt --output /tmp/bootdebian/efi/boot/grubx64.efi /tmp/bootdebian/efi/boot/grubx64.efi
sbsign --key certificates/db.key --cert certificates/db.crt --output netinst/igor/BOOTX64.EFI netinst/igor/BOOTX64.EFI
sbverify --cert certificates/db.crt /tmp/bootdebian/efi/boot/grubx64.efi
sbverify --cert certificates/db.crt /tmp/bootdebian/efi/boot/bootx64.efi
sbverify --cert certificates/db.crt netinst/igor/BOOTX64.EFI 
