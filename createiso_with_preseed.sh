#!/bin/bash
chmod +w -R netinst/install/
cp netinst_limpio/install/initrd.gz netinst/install/initrd.gz
mkdir -p tmp/initrd
cd tmp/initrd
zcat ../../netinst_limpio/install/initrd.gz | cpio -iv
cp ../../preseed.cfg .
cp ../../randompass.sh .
cp ../../efiboot.sh .
cp ../../script_ch.sh .
mkdir -p lib/firmware
cp -a ../../rtl_nic lib/firmware
find . -print0 | cpio -0 -H newc -ov | gzip -c > ../../netinst/install/initrd.gz
cd ../../
rm -fr tmp/initrd
chmod -w -R netinst/install
chmod +w netinst/md5sum.txt
find netinst -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > netinst/md5sum.txt 
chmod -w netinst/md5sum.txt
cd netinst 
#genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -e EFI/boot/bootx64.efi  -no-emul-boot -boot-load-size 4 -boot-info-table -o preseed-debian-10.5.0-amd64-netinst.iso ../netinst 
xorriso -as mkisofs -o netinst_preseed.iso -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -isohybrid-gpt-basdat -no-emul-boot ../netinst
cd ..
mv netinst/netinst_preseed.iso .
