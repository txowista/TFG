#!/bin/bash
apt-get install efitools
wget https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.5.0-amd64-netinst.iso
mkdir netinst
mkdir netinst_limpio
7z x -onetinst_limpio debian-10.5.0-amd64-netinst.iso
7z x -onetinst debian-10.5.0-amd64-netinst.iso

