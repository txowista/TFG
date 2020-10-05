#!/bin/bash
PASS=`grep -e PASS /tmp/variable.txt| cut -d'=' -f 2`
DISK=`grep -e FIRST_DISK /tmp/variable.txt| cut -d'=' -f 2`
efibootmgr -c -d $DISK -p 1 -w -L enigmedia -l '\EFI\BOOT\BOOTX64.EFI'
modprobe tpm 
modprobe tpm_tis
modprobe tpm_tis_spi
dpkg -i /tmp/igor/libsapi0_2.0-1_amd64.deb
dpkg -i /tmp/igor/tpm2_1.0-1_amd64.deb
dpkg -i /tmp/igor/tpm2-tools_3.0.2-1_amd64.deb
#apt-get install libgio-cil
#tpm2_evictcontrol -A -S 0x81000010
tpm2_evictcontrol -c 0x81000010
echo -n $PASS > secret.bin
tpm2_pcrlist -L sha1:0,2,3,7 -o pcrs.bin
tpm2_createpolicy \--policy-pcr -L sha1:0,2,3,7 -F pcrs.bin -o policy.digest
tpm2_createprimary -a e -g sha1 -G rsa -o primary.context
tpm2_flushcontext -t
#tpm2_flushcontext -s
tpm2_create -g sha256 -u obj.pub -r obj.priv -C primary.context -L policy.digest -b "noda|adminwithpolicy|fixedparent|fixedtpm" -i secret.bin
tpm2_flushcontext -t
tpm2_load -C primary.context -u obj.pub -r obj.priv -o load.context
tpm2_flushcontext -t
tpm2_evictcontrol -c load.context -p 0x81000010
#rm secret.bin pcrs.bin policy.digest primary.context obj.pub obj.priv load.context
