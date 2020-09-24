#!/bin/bash
chmod +w -R netinst/install.amd/
cp netinst_limpio/install.amd/initrd.gz netinst/install.amd/initrd.gz
chmod +w  netinst/install.amd/initrd.gz
gunzip netinst/install.amd/initrd.gz
echo preseed.cfg | cpio -H newc -o -A -F netinst/install.amd/initrd
echo myquestion.sh | cpio -H newc -o -A -F netinst/install.amd/initrd
gzip netinst/install.amd/initrd
chmod -w -R netinst/install.amd
chmod +w netinst/md5sum.txt
find netinst -follow -type f ! -name md5sum.txt -print0 | xargs -0 md5sum > netinst/md5sum.txt 
chmod -w netinst/md5sum.txt
cd netinst 
genisoimage -r -J -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -o preseed-debian-10.5.0-amd64-netinst.iso ../netinst
cd ..
mv netinst/preseed-debian-10.5.0-amd64-netinst.iso .
